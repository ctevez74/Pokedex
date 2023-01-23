//
//  PokemonDetailDTO+Mapper.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 23/01/2023.
//

extension PokemonDetailDTO {
    func toDomain() -> PokemonDetail {
        
        let types = types.compactMap { ($0.type?.name, $0.type?.url) as? (String, String) }.map(DetailData.init)
        
        let attacks = moves.compactMap { ($0.move?.name, $0.move?.url) as? (String, String) }.map(DetailData.init)
        
        let abilities = abilities.compactMap { ($0.ability?.name, $0.ability?.url) as? (String, String) }.map(DetailData.init)
        
        let forms = forms.compactMap { ($0.name, $0.url) as? (String, String) }.map(DetailData.init)
        
        // TODO: Catch id
        return PokemonDetail(id: id ?? 0, name: name ?? "", types: types, forms: forms, attacks: attacks, abilities: abilities)
    }
}
