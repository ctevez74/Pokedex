//
//  PokemonTypesDTO.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 23/01/2023.
//

struct PokemonTypesDTO: Decodable {
    let type: PokedexItemDTO?
}

extension PokemonTypesDTO: PropertyIterator {}
