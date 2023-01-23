//
//  LoadDetailUseCase.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 23/01/2023.
//

protocol LoadDetailUseCaseProtocol {
    func execute() async -> Result<PokemonDetail, Error>
}

struct LoadDetailUseCase: LoadDetailUseCaseProtocol {
    
    let detailRepository: DetailRepositoryProtocol
    
    func execute() async -> Result<PokemonDetail, Error> {
        do {
            let repositoryResult = try await detailRepository.fetchDetail()
            return .success(repositoryResult)
        } catch {
            return .failure(error)
        }
    }
}

