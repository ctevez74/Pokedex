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
        let id = "\(model.id)"
        let urlDetail = Endpoint.detail(id)
        goToDetail(in: urlDetail)
    }
    
    private func goToDetail(in urlList: Endpoint) {
        let detailCoordinator = pokedexFactory.makeCoordinatorDetail(navigationController: navigationController, urlList: urlList)

        detailCoordinator.start()
    }
}
