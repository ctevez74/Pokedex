//
//  CoreDataManager.swift
//  Pokedex
//
//  Created by Carlos Gabriel Tevez on 23/01/2023.
//

import CoreData

class CoreDataManager {
    private let container : NSPersistentContainer!

    init() {
        container = NSPersistentContainer(name: "PokemonData")
        ValueTransformer.setValueTransformer(PokedexItemTransformer(), forName: NSValueTransformerName("PokedexItemTransformer"))
        setupDatabase()
    }
    
    private func setupDatabase() {
        container.loadPersistentStores { (desc, error) in
            if let error = error {
                print("Error loading store \(desc) — \(error)")
                return
            }
            print("Database ready!")
        }
    }
    
    func saveData(list: [PokedexItem]) {
        let context = container.viewContext
        let user = PokemonList(context: context)
        let paths = PokemonsStoredData(paths: list)
        user.list = paths
        
        do {
            try context.save()
        } catch {
            print("Error guardando — \(error)")
        }
    }
    
    func fetch() -> [PokedexItem] {
        var collegeData = [PokemonList]()
        do {
            collegeData =
            try container.viewContext.fetch(PokemonList.fetchRequest())
        } catch {
            print("couldnt fetch")
        }

        return collegeData.last?.list?.data ?? []
    }
    
    func clean() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PokemonList")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try container.viewContext.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
            print("Error in delete: ", error)
        }
    }
}
