//
//  LoadPokedexUseCase.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 22/01/2023.
//

import Foundation

protocol LoadPokedexUseCaseProtocol {
    func execute() async -> Result<Pokedex, Error>
}

struct LoadPokedexUseCase: LoadPokedexUseCaseProtocol {
    
    let pokedexRepository: PokedexRepositoryProtocol
    
    func execute() async -> Result<Pokedex, Error> {
        do {
            let repositoryResult = try await pokedexRepository.fetchPokedexData()
            return .success(repositoryResult)
        } catch {
            return .failure(error)
        }
    }
}


