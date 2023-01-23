//
//  PokemonList+CoreDataProperties.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 23/01/2023.
//
//

import Foundation
import CoreData


extension PokemonList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonList> {
        return NSFetchRequest<PokemonList>(entityName: "PokemonList")
    }

    @NSManaged public var list: PokemonsStoredData?

}

extension PokemonList : Identifiable {

}
