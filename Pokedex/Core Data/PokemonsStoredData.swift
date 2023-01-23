//
//  PokemonsStoredData.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 23/01/2023.
//

import Foundation

public class PokemonsStoredData: NSObject, NSSecureCoding {
    public static var supportsSecureCoding = true
    
    public var data: [PokedexItem] = []
    
    enum Key: String {
        case data = "data"
    }
    
    init(paths: [PokedexItem]) {
        self.data = paths
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(data, forKey: Key.data.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mPaths = aDecoder.decodeObject(of: [NSArray.self, PokedexItem.self], forKey: Key.data.rawValue) as! [PokedexItem]
        
        self.init(paths: mPaths)
    }
}
