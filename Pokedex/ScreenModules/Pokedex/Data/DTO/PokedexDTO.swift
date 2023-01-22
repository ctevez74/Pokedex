//
//  PokedexDTO.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 22/01/2023.
//

struct PokedexDTO: Decodable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [PokedexItemDTO]
}

extension PokedexDTO: PropertyIterator {}
