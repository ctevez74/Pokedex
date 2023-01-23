//
//  PokemonDetailDTO.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 23/01/2023.
//

struct PokemonDetailDTO: Decodable {
    let id: Int?
    let name: String?
    let types: [PokemonTypesDTO]
    let moves: [PokemonMoveDTO]
    let abilities: [PokemonAbilitieDTO]
    let forms: [PokedexItemDTO]
}

extension PokemonDetailDTO: PropertyIterator {}
