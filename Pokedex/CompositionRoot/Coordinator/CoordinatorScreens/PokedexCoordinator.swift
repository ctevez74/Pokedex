//
//  PokedexCoordinator.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 22/01/2023.
//

import UIKit

final class PokedexCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let pokedexFactory: PokedexFactory
    
    init(navigation: UINavigationController, pokedexFactory: PokedexFactory){
        self.navigationController = navigation
        self.pokedexFactory = pokedexFactory
    }
    
    func start() {
        let controller = pokedexFactory.makeModule(coordinator: self)
        navigationController.pushViewController(controller, animated: true)
    }
}

extension PokedexCoordinator: PokedexTableViewControllerCoordinator {
    func didSelectPokedexCell(model: PokedexItem) {
        let urlDetail = "\(Endpoint.detailUrl)\(model.id)"
        // TODO: Go to detail
    }
}
