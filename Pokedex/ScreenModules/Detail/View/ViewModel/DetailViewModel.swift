//
//  DetailViewModel.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 23/01/2023.
//

import UIKit
import Combine

protocol DetailViewModelProtocol {
    var pokemon: PokemonDetail? { get }
    
    // -- Combine
    var reloadData: PassthroughSubject<Void, Error> { get }
    var isLoadingPublisher:  Published<Bool?>.Publisher { get }
    
    func fetchDetail()
   
    // -- Sections
    var sectionsCount: Int { get }
    func getSectionTitle(for section: Int) -> String
    
    // -- Content Table
    func getContentIn(section: Int) -> Int
    func getDetailsForCell(in indexPath: IndexPath) -> DetailData?
    
    // -- Content View
    func getId() -> String
    func getName() -> String
    func getTypes() -> [DetailData]
    func getPictureUrl() -> URL?
}

final class DetailViewModel: DetailViewModelProtocol {
    var pokemon: PokemonDetail?
    var reloadData = PassthroughSubject<Void, Error>()
    @Published private var isLoading: Bool?
    var isLoadingPublisher: Published<Bool?>.Publisher { $isLoading }
    private let loadDetailUseCase: LoadDetailUseCaseProtocol
    private let details = [String]()
    var sectionsCount: Int {
        DetailViewModel.Sections.allCases.count
    }
    
    enum Sections: String, CaseIterable {
        case forms
        case moves
        case abilities
    }
    
    init(loadDetailUseCase: LoadDetailUseCaseProtocol) {
        self.loadDetailUseCase = loadDetailUseCase
    }
    
    func fetchDetail() {
        isLoading = true
        Task {
            self.isLoading = false
            // TODO: Unrw
            let result = await loadDetailUseCase.execute()
            switch result {
            case .success(let detail):
                pokemon = detail
                self.reloadData.send()
            case .failure(let error):
                print("Ctvz error---", error)
            }
        }
    }
    
    func getSectionTitle(for section: Int) -> String {
        DetailViewModel.Sections.allCases[section].rawValue
    }
    
    func getContentIn(section: Int) -> Int {
        let section = DetailViewModel.Sections.allCases[section]
        guard let pokemon = pokemon else { return 0 }
        switch section {
        case .forms:       return pokemon.forms.count
        case .moves:       return pokemon.attacks.count
        case .abilities:   return pokemon.abilities.count
        }
    }
    
    func getDetailsForCell(in indexPath: IndexPath) -> DetailData? {
        let section = DetailViewModel.Sections.allCases[indexPath.section]
        guard let pokemon = pokemon else { return nil }
        switch section {
        case .forms:       return pokemon.forms[indexPath.row]
        case .moves:       return pokemon.attacks[indexPath.row]
        case .abilities:   return pokemon.abilities[indexPath.row]
        }
    }
    
    func getId() -> String {
        guard let id = pokemon?.id else { return "undefined" }
        return "#\(id)"
    }
    
    func getName() -> String {
        pokemon?.name ?? "undefined"
    }
    
    func getTypes() -> [DetailData] {
        pokemon?.types ?? []
    }
    
    func getPictureUrl() -> URL? {
        guard let id = pokemon?.id else { return nil }
        let urlString = Endpoint.detailPicture("\(id)").path
        return URL(string: urlString)
    }
}

