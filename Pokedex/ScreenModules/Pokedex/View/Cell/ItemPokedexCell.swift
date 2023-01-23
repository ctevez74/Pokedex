//
//  ItemPokedexCell.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 22/01/2023.
//

import UIKit
import AlamofireImage

class ItemPokedexCell: UITableViewCell {
    // UI
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameLabel = UILabel()
    lazy var favoriteBtn : UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    lazy var pokeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        configureBackground()
        configureContainerView()
        configureUIElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    func configData(viewModel: ItemPokedexViewModel) {
        let backgroundColor = UIColor(red: 255/255, green: 203/255, blue: 5/255, alpha: 1)
        let borderColor = UIColor(red: 61/255, green: 125/255, blue: 202/255, alpha: 1)
        let textAttributes = [
            NSAttributedString.Key.foregroundColor: backgroundColor,
            NSAttributedString.Key.strokeColor: borderColor,
            NSAttributedString.Key.font: UIFont(name: "PokemonSolidNormal", size: 25)!,
            NSAttributedString.Key.strokeWidth: -3.0
        ] as [NSAttributedString.Key : Any]
        
        nameLabel.attributedText = NSAttributedString(string: viewModel.name, attributes: textAttributes)
        // TODO: Add placeholder
        
        if let url = viewModel.imageUrl, Reachability.isConnectedToNetwork() {
            pokeImageView.af_setImage(withURL: url, placeholderImage: viewModel.getPlaceholder(), completion: { _ in
                self.pokeImageView.image = self.pokeImageView.image?.cropAlpha()
            })
        } else {
            pokeImageView.image =  viewModel.getPlaceholder()
        }
    }
    
    private func configureBackground() {
        let background = UIImageView(image: UIImage(named: "kalos"))
        background.contentMode = .top
        background.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(background)
        NSLayoutConstraint.activate([
            background.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            background.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            background.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            background.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10)
        ])
    }
    
    private func configureContainerView() {
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        ])
    }
    
    private func configureUIElements() {
        configureNameLabel()
        configurePokeImageView()
    }
    
    private func configureNameLabel() {
        containerView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0)
        ])
    }
    
    private func configurePokeImageView() {
        containerView.addSubview(pokeImageView)
        
        NSLayoutConstraint.activate([
            pokeImageView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 20),
            pokeImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            pokeImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 25),
            pokeImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -25)
        ])
        
        let heightConstraint = pokeImageView.heightAnchor.constraint(equalToConstant: 100)
        heightConstraint.priority = UILayoutPriority(999)
        heightConstraint.isActive = true
        
        let widthConstraint = pokeImageView.widthAnchor.constraint(equalToConstant: 100)
        widthConstraint.priority = UILayoutPriority(999)
        widthConstraint.isActive = true
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        pokeImageView.image = nil
    }
}
