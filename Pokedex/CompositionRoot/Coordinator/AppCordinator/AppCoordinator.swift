//
//  AppCoordinator.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 22/01/2023.
//

import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let appFactory: AppFactoryProtocol
    private var podexCoordinator: Coordinator?
    
    init(navigationController: UINavigationController, appFactory: AppFactoryProtocol, window: UIWindow?) {
        self.navigationController = navigationController
        self.appFactory = appFactory
        configWindow(window: window)
    }
    
    func start() {
        podexCoordinator = appFactory.makePodexCoordinator(navigation: navigationController)
        podexCoordinator?.start()
    }
    
    private func configWindow(window: UIWindow?) {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
