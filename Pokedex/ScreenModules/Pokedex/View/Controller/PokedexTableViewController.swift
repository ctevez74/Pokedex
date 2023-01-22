//
//  PokedexTableViewController.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 22/01/2023.
//

import UIKit
import Combine

protocol PokedexTableViewControllerCoordinator: AnyObject {
    func didSelectPokedexCell(model: PokedexItem)
}

class PokedexTableViewController: UIViewController {
    private var viewModel: PokedexViewModelProtocol!
    private var anyCancellable: [AnyCancellable] = []
    private weak var coordinator: PokedexTableViewControllerCoordinator?
    private var lastContentOffset: CGFloat = 0
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        tv.register(ItemPokedexCell.self, forCellReuseIdentifier: "ItemPokedexCell")
        return tv
    }()
    
    lazy var searchBarController: UISearchController = UISearchController()
    
    
    // MARK: - Init
    init(viewModel: PokedexViewModelProtocol, coordinator: PokedexTableViewControllerCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        viewModel.getPokemons()
        configureSubscriptions()
        configureSearchBar()
    }
    
    // MARK: - Setup
    private func configureSearchBar() {
        searchBarController.searchBar.delegate = self
        navigationItem.searchController = searchBarController
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController!.navigationBar.sizeToFit()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    private func configureSubscriptions() {
        viewModel.reloadData
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.tableView.reloadData()
            }.store(in: &anyCancellable)
    }
    
    // MARK: - Scroll
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            navigationItem.hidesSearchBarWhenScrolling = false
        } else if (self.lastContentOffset < scrollView.contentOffset.y) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
        
        self.lastContentOffset = scrollView.contentOffset.y
    }
}

// MARK: - TableView Methods
extension PokedexTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.pokemonsItemsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: Guard let
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemPokedexCell", for: indexPath) as! ItemPokedexCell
        let viewModelCell = viewModel.getPokemonCellViewModel(for: indexPath)
        cell.configData(viewModel: viewModelCell)
        
        return cell
    }
}


extension PokedexTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.getPokemonItem(in: indexPath)
        coordinator?.didSelectPokedexCell(model: model)
    }
}

// MARK: - UISearchBarDelegate Methods
extension PokedexTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        viewModel.search(by: textSearched)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.search(by: "") // TODO: Create struct EMPTY_STRING
    }
}

