//
//  PokemonMoveDTO.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 23/01/2023.
//

struct PokemonMoveDTO: Decodable {
    let move: PokedexItemDTO?
}

extension PokemonMoveDTO: PropertyIterator {}
