//
//  DetailCoordinator.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 23/01/2023.
//

import UIKit

final class DetailCoordinator: Coordinator {
    var navigationController: UINavigationController
    private var detailFactory: DetailFactoryProtocol
    
    init(navigation: UINavigationController, detailFactory: DetailFactoryProtocol){
        self.navigationController = navigation
        self.detailFactory = detailFactory
    }
    
    func start() {
        let controller = detailFactory.makeModule(coordinator: self)
        navigationController.navigationBar.prefersLargeTitles = true
        self.navigationController.pushViewController(controller, animated: true)
    }
}

extension DetailCoordinator: DetailViewControllerCoordinator {

}


