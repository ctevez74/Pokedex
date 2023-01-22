//
//  PokedexRepositoryProtocol.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 22/01/2023.
//

protocol PokedexRepositoryProtocol {
    func fetchPokedexData() async throws -> Pokedex
}
