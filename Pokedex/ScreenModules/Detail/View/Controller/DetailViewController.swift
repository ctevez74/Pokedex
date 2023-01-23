//
//  DetailViewController.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 23/01/2023.
//

import UIKit
import AlamofireImage
import Combine

protocol DetailViewControllerCoordinator: AnyObject {
}

class DetailViewController: UIViewController {
    // Combine
    private var anyCancellable: [AnyCancellable] = []
    
    // Architecture
    private var viewModel: DetailViewModelProtocol!
    
    // UI
    private var idLabel = UILabel()
    private var pokeImageView = UIImageView()
    private var nameLabel = UILabel()
    private var typesStackview = UIStackView()
    private var typeLabels = [UILabel]()
    private var headerView = UIView()
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = UITableView.automaticDimension
        
        tv.register(ItemPokedexCell.self, forCellReuseIdentifier: "ItemPokedexCell")
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    var hiddenSections = Set<Int>() // TODO: Move vm ?
    var loading: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView(style: .large)
        loading.color = .yellow
        loading.translatesAutoresizingMaskIntoConstraints = false
        return loading
    }()
    
    // MARK: - Init
    init(viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        
        if !Reachability.isConnectedToNetwork() {
            configureOffline()
            return
        }
        
        configureView()
        configureSubscriptions()
        viewModel.fetchDetail()
    }
    
    // MARK: - Configure
    private func configureOffline() {
        let notConnectionImg = #imageLiteral(resourceName: "pikachu-questionMark")
        let errorImageView = UIImageView(image: notConnectionImg)
        view.addSubview(errorImageView)
        errorImageView.contentMode = .scaleAspectFit
        errorImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let errorLabel = UILabel()
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.numberOfLines = 0
        errorLabel.text = "No connection detected" // TODO: Localizable
        errorLabel.textAlignment = .center
        view.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            errorImageView.topAnchor.constraint(equalTo: view.topAnchor),
            errorImageView.bottomAnchor.constraint(equalTo: errorLabel.topAnchor),
            errorImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            errorLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func configureVC() {
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func configureView() {
        configureHeaderView()
        configureBackground()
        configureTableView()
        configureElements()
    }
    
    private func configureSubscriptions() {
        viewModel.reloadData
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.configureIdLabel()
                self.loadPokeImageView()
                self.configureNameLabel()
                self.configureTypesLabel()
            }.store(in: &anyCancellable)
        
        viewModel.isLoadingPublisher.sink {[weak self] state in
            guard let state = state else { return }
            self?.configureLoading(state: state)
        }.store(in: &anyCancellable)
    }
    
    private func configureLoading(state: Bool) {
        if state {
            loading.startAnimating()
            view.addSubview(loading)
            NSLayoutConstraint.activate([
                loading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                loading.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            return
        }
        
        DispatchQueue.main.async() {
            self.loading.removeFromSuperview()
        }
    }
}

extension DetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        hiddenSections.contains(section) ? 0 : viewModel.getContentIn(section: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.getSectionTitle(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let data = viewModel.getDetailsForCell(in: indexPath)
        cell?.textLabel?.text = data?.name
        return cell ?? UITableViewCell()
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionButton = UIButton()
        
        sectionButton.setTitle(viewModel.getSectionTitle(for: section),
                               for: .normal)
        sectionButton.backgroundColor = .systemBlue
        sectionButton.tag = section
        sectionButton.addTarget(self,
                                action: #selector(self.hideSection(sender:)),
                                for: .touchUpInside)
        
        return sectionButton
    }
    
    @objc private func hideSection(sender: UIButton) {
        let section = sender.tag
        
        func indexPathsForSection() -> [IndexPath] {
            var indexPaths = [IndexPath]()
            
            for row in 0..<viewModel.getContentIn(section: section) {
                indexPaths.append(IndexPath(row: row, section: section))
            }
            
            return indexPaths
        }
        
        if self.hiddenSections.contains(section) {
            self.hiddenSections.remove(section)
            self.tableView.insertRows(at: indexPathsForSection(), with: .fade)
        } else {
            self.hiddenSections.insert(section)
            self.tableView.deleteRows(at: indexPathsForSection(), with: .fade)
        }
    }
}

// MARK: - Configure UI
extension DetailViewController {
    private func configureBackground() {
        let background = UIImageView(image: UIImage(named: "battlefield"))
        headerView.addSubview(background)
        background.translatesAutoresizingMaskIntoConstraints = false
        background.layer.masksToBounds = true
        background.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            background.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10),
            background.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10),
            background.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10),
            background.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10)
        ])
    }
    
    private func configureHeaderView() {
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 300),
            headerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureElements() {
        loadIdLabelConstraints()
        loadPokeImageViewConstraints()
        loadNameLabelConstraints()
        loadLabelsConstraints()
    }
    
    private func loadIdLabelConstraints() {
        view.addSubview(idLabel)
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            idLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            idLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 15)
        ])
    }
    
    private func loadLabelsConstraints() {
        headerView.addSubview(typesStackview)
        typesStackview.translatesAutoresizingMaskIntoConstraints = false
        // TODO: Add constraint to edges less than
        NSLayoutConstraint.activate([
            typesStackview.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            typesStackview.heightAnchor.constraint(equalToConstant: 25),
            typesStackview.centerXAnchor.constraint(equalTo: headerView.centerXAnchor)
        ])
    }
    
    private func loadPokeImageViewConstraints() {
        headerView.addSubview(pokeImageView)
        pokeImageView.translatesAutoresizingMaskIntoConstraints = false
        pokeImageView.contentMode = .scaleAspectFit // TODO: Move
        NSLayoutConstraint.activate([
            pokeImageView.topAnchor.constraint(equalTo: idLabel.bottomAnchor),
            pokeImageView.widthAnchor.constraint(equalToConstant: 150),
            pokeImageView.heightAnchor.constraint(equalToConstant: 150),
            pokeImageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor)
        ])
    }
    
    private func loadNameLabelConstraints() {
        headerView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: pokeImageView.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor)
        ])
    }
    
    private func configureIdLabel() {
        idLabel.text = viewModel.getId()
        idLabel.textColor = .white
    }
    
    private func loadPokeImageView() {
        guard let url = viewModel.getPictureUrl() else { return }
        pokeImageView.af_setImage(withURL: url, completion: { _ in
            self.pokeImageView.image = self.pokeImageView.image?.cropAlpha()
        })
    }
    
    private func configureNameLabel() {
        nameLabel.text = viewModel.getName()
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name: nameLabel.font.fontName, size: 40)
    }
    
    private func configureTypesLabel() {
        typesStackview.distribution = .fillProportionally
        typesStackview.alignment = .center
        typesStackview.spacing = 10

        for type in viewModel.getTypes() {
            let icon = UIImageView(image: UIImage(named: type.name))
            icon.contentMode = .scaleAspectFit
            icon.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                icon.widthAnchor.constraint(equalToConstant: 25)
            ])
            typesStackview.addArrangedSubview(icon)
        }
    }
}
