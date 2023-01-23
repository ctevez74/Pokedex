//
//  PokedexRepository.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 22/01/2023.
//

import Foundation
import Alamofire

struct PokedexRepository: PokedexRepositoryProtocol {
    private let manager = CoreDataManager()
    let urlList: String
    
    // TODO: Replace AF to apiClient
    func fetchPokedexData() async throws -> Pokedex {
        try await AF.request(urlList, method: .get).serializingDecodable(PokedexDTO.self).value.toDomain()
    }
    
    func fetchPokedexDataStored() -> [PokedexItem] {
        manager.fetch()
    }
    
    func savePokedexDataStorage(data: [PokedexItem]) {
        manager.clean() // save just one record
        manager.saveData(list: data)
    }
}
