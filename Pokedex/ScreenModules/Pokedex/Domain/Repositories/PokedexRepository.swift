//
//  PokedexRepository.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 22/01/2023.
//

import Foundation
import Alamofire

struct PokedexRepository: PokedexRepositoryProtocol {
    let urlList: String
    
    // TODO: Replace AF to apiClient
    func fetchPokedexData() async throws -> Pokedex {
        try await AF.request(urlList, method: .get).serializingDecodable(PokedexDTO.self).value.toDomain()
    }
}
