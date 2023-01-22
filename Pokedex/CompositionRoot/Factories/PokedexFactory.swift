//
//  PokedexFactory.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 22/01/2023.
//

import Combine
import UIKit

protocol PokedexFactoryProtocol {
    func makeModule(coordinator: PokedexTableViewControllerCoordinator) -> UIViewController
}

struct PokedexFactory: PokedexFactoryProtocol {
    func makeModule(coordinator: PokedexTableViewControllerCoordinator) -> UIViewController {
        let pokedexRepository = PokedexRepository(urlList: Endpoint.podexUrl)
        let pokedexUseCase = LoadPokedexUseCase(pokedexRepository: pokedexRepository)
        let pokedexViewModel = PokedexViewModel(loadPokedexUseCase: pokedexUseCase)
        let pokedexController = PokedexTableViewController(viewModel: pokedexViewModel, coordinator: coordinator)
        pokedexController.title = "Pokedex" // TODO: Localizable
        return pokedexController
    }
}


