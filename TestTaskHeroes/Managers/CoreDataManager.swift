//
//  CoreDataManager.swift
//  TestTaskHeroes
//
//  Created by leanid niadzelin on 11/23/18.
//  Copyright © 2018 Leanid Niadzelin. All rights reserved.
//

import UIKit
import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TestTaskHeroesModel")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()
    
    func fetchFavoriteHero() -> FavoriteHero? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<FavoriteHero>(entityName: "FavoriteHero")
        do {
            let favoriteHero = try context.fetch(fetchRequest)
            return favoriteHero.first
        } catch let fetchErr {
            print("Failed to fetch alarms:", fetchErr)
            return nil
        }
    }
    
    func deleteFavoriteHero() {
        let context = persistentContainer.viewContext
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: FavoriteHero.fetchRequest())
        do {
            try context.execute(deleteRequest)
        } catch let err {
            print("Failed to delete favoriteHero from Core Data:", err)
        }
    }
    
    func saveFavorite(hero: Hero, image: UIImage) {
        let context = persistentContainer.viewContext
        let favoriteHero = NSEntityDescription.insertNewObject(forEntityName: "FavoriteHero", into: context) as! FavoriteHero
        favoriteHero.heroDescription = hero.description
        favoriteHero.heroName = hero.name
        favoriteHero.id = hero.id
        let imageData = image.jpegData(compressionQuality: 1)
        favoriteHero.imageData = imageData
        do {
            try context.save()
        } catch let err {
            print("Failed to save favorite hero:", err)
        }
    }
}
