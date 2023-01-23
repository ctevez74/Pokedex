//
//  PokemonAbilitieDTO.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 23/01/2023.
//

struct PokemonAbilitieDTO: Decodable {
    let ability: PokedexItemDTO?
}

extension PokemonAbilitieDTO: PropertyIterator {}
