//
//  Coordinator.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 22/01/2023.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }
    func start()
}
