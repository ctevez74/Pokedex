//
//  PokedexItemDTO.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 22/01/2023.
//

struct PokedexItemDTO: Decodable {
    let name: String?
    let url: String?
}

extension PokedexItemDTO: PropertyIterator {}
