//
//  PokedexItem.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 22/01/2023.
//

//import Foundation
import CoreData
import UIKit

public class PokedexItem: NSObject, NSSecureCoding {
    public static var supportsSecureCoding = true
    
    let id: Int
    let name: String
    let url: String
    
    enum Key: String {
        case id = "id"
        case name = "name"
        case url = "url"
    }
    
    init(id: Int, name: String, url: String) {
        self.id = id
        self.name = name
        self.url = url
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: Key.id.rawValue)
        let name = aDecoder.decodeObject(of: NSString.self, forKey: Key.name.rawValue)! as String
        let url = aDecoder.decodeObject(of: NSString.self, forKey: Key.url.rawValue)! as String
        
        self.init(id: id, name: name, url: url)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: Key.id.rawValue)
        aCoder.encode(name, forKey: Key.name.rawValue)
        aCoder.encode(url, forKey: Key.url.rawValue)
    }
}
