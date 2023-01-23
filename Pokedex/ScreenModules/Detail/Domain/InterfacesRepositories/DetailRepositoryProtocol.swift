//
//  DetailRepositoryProtocol.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 23/01/2023.
//

protocol DetailRepositoryProtocol {
    func fetchDetail() async throws -> PokemonDetail
}

