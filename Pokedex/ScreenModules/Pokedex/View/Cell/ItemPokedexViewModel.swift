//
//  ItemPokedexViewModel.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 22/01/2023.
//

struct ItemPokedexViewModel {
    private let pokedexItem: PokedexItem
    
    init(pokedexItem: PokedexItem) {
        self.pokedexItem = pokedexItem
    }
    
    var name: String {
        pokedexItem.name
    }
    
    var url: String {
        pokedexItem.url
    }
    
    var imageName: Int {
        pokedexItem.id
    }
    
    // TODO: Move to constants
    var imageUrl: String {
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(imageName).png"
    }
}

