//
//  Endpoint.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 22/01/2023.
//

enum Endpoint {
    case podexList
    case detail(String)
    case detailPicture(String)
}

// MARK: -
extension Endpoint: EndpointType {

    var path: String {
        switch self {
        case .podexList: return "https://pokeapi.co/api/v2/pokemon?limit=151&offset=0"
        case .detail(let id): return "https://pokeapi.co/api/v2/pokemon/\(id)"
        case .detailPicture(let id): return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
        }
    }
}

public protocol EndpointType {
    var path: String { get }
}
