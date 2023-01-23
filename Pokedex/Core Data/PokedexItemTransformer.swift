//
//  PokedexItemTransformer.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 23/01/2023.
//

import Foundation

@objc(PokedexItemTransformer)
class PokedexItemTransformer: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        guard let list = value as? [PokemonList] else { return nil }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: list, requiringSecureCoding: true)
            return data
        } catch {
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }

        do {
            let records = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [PokemonList.self], from: data)
            return records

        } catch {
            return nil
        }
    }
}
