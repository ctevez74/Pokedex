//
//  DetailFactory.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 23/01/2023.
//

import UIKit

protocol DetailFactoryProtocol {
    func makeModule(coordinator: DetailViewControllerCoordinator) -> UIViewController
}

struct DetailFactory: DetailFactoryProtocol {
    let urlList: Endpoint
    func makeModule(coordinator: DetailViewControllerCoordinator) -> UIViewController {
        let detailRepository = DetailRepository(urlList: urlList)
        let loadDetailUseCase = LoadDetailUseCase(detailRepository: detailRepository)
        let viewModel = DetailViewModel(loadDetailUseCase: loadDetailUseCase)
        let controller = DetailViewController(viewModel: viewModel)
        
        return controller
    }
}
