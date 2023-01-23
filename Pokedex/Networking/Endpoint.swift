//
//  Endpoint.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 22/01/2023.
//

//struct Endpoint {
//    static let podexUrl = "https://pokeapi.co/api/v2/pokemon?limit=151&offset=0"
//    static let detailUrl = "https://pokeapi.co/api/v2/pokemon/"
//}

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
    /// The backend API endpoint path. E.g `/data/id`
    var path: String { get }
}
