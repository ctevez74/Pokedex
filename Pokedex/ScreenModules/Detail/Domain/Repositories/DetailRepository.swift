//
//  DetailRepository.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 23/01/2023.
//

import Foundation
import Alamofire

struct DetailRepository: DetailRepositoryProtocol {
    let urlList: Endpoint
    
    func fetchDetail() async throws -> PokemonDetail {
        return try await AF.request(urlList.path, method: .get).serializingDecodable(PokemonDetailDTO.self).value.toDomain()
    }
}
