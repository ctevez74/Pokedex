//
//  ItemPokedexViewModel.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 22/01/2023.
//

import UIKit

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
    
    var imageUrl: URL? {
        let urlString = Endpoint.detailPicture("\(pokedexItem.id)").path
        return URL(string: urlString)
    }
    
    func getPlaceholder() -> UIImage {
        #imageLiteral(resourceName: "placeholder")
    }
}

