//
//  PokedexDTO+Mapper.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 22/01/2023.
//

extension PokedexDTO {
    func toDomain() -> Pokedex {
        // TODO: Mejorar el id
        let pokemons = results.enumerated().compactMap { $1.name != nil && $1.url != nil ? ($0 + 1, $1.name!, $1.url!) : nil }.map(PokedexItem.init)
        return Pokedex(count: count, next: next, previous: previous, pokemons: pokemons)
    }
}
