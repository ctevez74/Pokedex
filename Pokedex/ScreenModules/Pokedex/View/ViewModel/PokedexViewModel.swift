//
//  PokedexViewModel.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 22/01/2023.
//

import UIKit
import Combine

protocol PokedexViewModelProtocol {
    var reloadData: PassthroughSubject<Void, Error> { get }
    var isLoadingPublisher:  Published<Bool?>.Publisher { get }
    var pokemonsItemsCount: Int { get }
    
    func getPokemonCellViewModel(for indexPath: IndexPath) -> ItemPokedexViewModel
    func getPokemons()
    func getPokemonItem(in indexPath: IndexPath) -> PokedexItem
    
    func search(by name: String)
}

final class PokedexViewModel: PokedexViewModelProtocol {
    private let loadPokedexUseCase: LoadPokedexUseCaseProtocol
    private var pokemonsList: [PokedexItem] = []
    private var filteredTableData: [PokedexItem] = []
    private var isSearching = false
    var reloadData = PassthroughSubject<Void, Error>()
    var pokemonsItemsCount: Int {
        isSearching ? filteredTableData.count : pokemonsList.count
    }
    @Published private var isLoading: Bool?
    var isLoadingPublisher: Published<Bool?>.Publisher { $isLoading }
    
    init(loadPokedexUseCase: LoadPokedexUseCaseProtocol) {
        self.loadPokedexUseCase = loadPokedexUseCase
    }
    
    func getPokemons() {
        // TODO: Implement not have connection
        isLoading = true
        Task {
            let result = await loadPokedexUseCase.execute()
            self.isLoading = false
            switch result {
            case .success(let pokedex):
                self.pokemonsList = pokedex.pokemons
                // TODO: Implement persist data
                self.reloadData.send()
            case .failure(let error):
                print("Ctvz error--- implement", error)
            }
        }
    }
    
    func search(by name: String) {
        if name.isEmpty {
            isSearching = false
            reloadData.send()
            return
        }
        
        isSearching = true
        
        filteredTableData = pokemonsList.filter{ pokemon in
            pokemon.name.lowercased().contains(name.lowercased())}
        reloadData.send()
    }
    
    func getPokemonCellViewModel(for indexPath: IndexPath) -> ItemPokedexViewModel {
        
        let pokedexItem = isSearching ? filteredTableData[indexPath.row] : pokemonsList[indexPath.row]
        return ItemPokedexViewModel(pokedexItem: pokedexItem)
    }
    
    func getPokemonItem(in indexPath: IndexPath) -> PokedexItem {
        isSearching ? filteredTableData[indexPath.row] : pokemonsList[indexPath.row]
    }
}
