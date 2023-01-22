//
//  AppFactory.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 22/01/2023.
//

import UIKit

protocol AppFactoryProtocol {
    func makePodexCoordinator(navigation: UINavigationController) -> Coordinator
}

struct AppFactory: AppFactoryProtocol {
    func makePodexCoordinator(navigation: UINavigationController) -> Coordinator {
        let pokedexFactory = PokedexFactory()
        let pokedexCoordinator = PokedexCoordinator(navigation: navigation, pokedexFactory: pokedexFactory)
        return pokedexCoordinator
    }
}
