//
//  ItemPokedexCell.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 22/01/2023.
//

import UIKit
import AlamofireImage

class ItemPokedexCell: UITableViewCell {
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameLabel = UILabel()
    let numberLabel = UILabel()
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let im = UIImageView(image: UIImage(named: "kalos"))
        im.contentMode = .top
        im.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(im)
        NSLayoutConstraint.activate([
            im.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            im.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            im.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            im.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10)
        ])
        // Add the UI components
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        ])
        containerView.addSubview(nameLabel)
        containerView.addSubview(numberLabel)
        containerView.addSubview(pokeImageView)

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            pokeImageView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 20),
            pokeImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            pokeImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 25),
            pokeImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -25)
        ])
        
        let constraint = pokeImageView.heightAnchor.constraint(equalToConstant: 100)
        constraint.priority = UILayoutPriority(999)
        constraint.isActive = true
        
        let constraint2 = pokeImageView.widthAnchor.constraint(equalToConstant: 100)
        constraint2.priority = UILayoutPriority(999)
        constraint2.isActive = true
        
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        pokeImageView.af_setImage(withURL: URL(string: viewModel.imageUrl)!, completion: { _ in
            // TODO: Implement remove transparent border
        })
    }
    
    override func prepareForReuse() {
        pokeImageView.image = nil
    }
}
