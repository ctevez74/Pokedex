//
//  ApiClientServiceProtocol.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 22/01/2023.
//

import Foundation

protocol ApiClientServiceProtocol {
    func request<T: Decodable>(url: URL?, type: T.Type) async throws -> T
}
