//
//  DataPersistenceManager.swift
//  Netflix clone
//
//  Created by AMAN K.A on 18/09/23.
//

//
//import Foundation
//import UIKit
//import CoreData
//
//class DataPersistenceManager {
//    
//    enum DatabaseError: Error {
//        case failedToSaveData
//        case failedToFetchData
//        case failedToDeleteData
//        case failedToGetContext
//    }
//    
//    static let shared = DataPersistenceManager()
//    
//    private init() {}
//    
//    func downloadTitleWith(model: Title, completion: @escaping (Result<Void, Error>) -> Void) {
//        print("🔽 Starting download for: \(model.original_title ?? model.original_name ?? "Unknown")")
//        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            print("❌ Failed to get AppDelegate")
//            completion(.failure(DatabaseError.failedToGetContext))
//            return
//        }
//        
//        let context = appDelegate.persistentContainer.viewContext
//        
//        // Check if already exists
//        let request: NSFetchRequest<TitleItem> = TitleItem.fetchRequest()
//        request.predicate = NSPredicate(format: "id == %d", model.id)
//        
//        do {
//            let existingItems = try context.fetch(request)
//            if !existingItems.isEmpty {
//                print("⚠️ Title already downloaded")
//                completion(.success(()))
//                return
//            }
//        } catch {
//            print("❌ Error checking existing title: \(error)")
//        }
//        
//        // Create new item
//        let item = TitleItem(context: context)
//        
//        // Map properties (use your Core Data model's actual property names)
//        item.id = Int64(model.id)
//        item.orignal_title = model.original_title    // Note: keeping your typo to match Core Data
//        item.orignal_name = model.original_name      // Note: keeping your typo to match Core Data
//        item.overview = model.overview
//        item.media_type = model.media_type
//        item.poster_path = model.poster_path
//        item.release_date = model.release_date
//        item.vote_count = Int64(model.vote_count)
//        item.vote_average = model.vote_average
//        
//        print("📊 Mapped title: \(item.orignal_title ?? item.orignal_name ?? "Unknown")")
//        
//        // Save to Core Data
//        do {
//            try context.save()
//            print("✅ Successfully saved to Core Data!")
//            completion(.success(()))
//        } catch {
//            print("❌ Core Data save error: \(error)")
//            completion(.failure(DatabaseError.failedToSaveData))
//        }
//    }
//    
//    func fetchingTitlesFromDatabase(completion: @escaping (Result<[TitleItem], Error>) -> Void) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            completion(.failure(DatabaseError.failedToGetContext))
//            return
//        }
//        
//        let context = appDelegate.persistentContainer.viewContext
//        let request: NSFetchRequest<TitleItem> = TitleItem.fetchRequest()
//        
//        do {
//            let titles = try context.fetch(request)
//            print("📥 Fetched \(titles.count) downloaded titles")
//            completion(.success(titles))
//        } catch {
//            print("❌ Fetch error: \(error)")
//            completion(.failure(DatabaseError.failedToFetchData))
//        }
//    }
//    
//    func deleteTitleWith(model: TitleItem, completion: @escaping (Result<Void, Error>) -> Void) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            completion(.failure(DatabaseError.failedToGetContext))
//            return
//        }
//        
//        let context = appDelegate.persistentContainer.viewContext
//        context.delete(model)
//        
//        do {
//            try context.save()
//            print("✅ Successfully deleted from database")
//            completion(.success(()))
//        } catch {
//            print("❌ Delete error: \(error)")
//            completion(.failure(DatabaseError.failedToDeleteData))
//        }
//    }
//}


//
//  DataPersistenceManager.swift
//  Netflix Clone
//
//  Created by Amr Hossam on 20/01/2022.
//

import Foundation
import UIKit
import CoreData


class DataPersistenceManager {
    
    enum DatabasError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    static let shared = DataPersistenceManager()
    
    
    func downloadTitleWith(model: Title, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        
        item.orignal_title = model.original_title
        item.id = Int64(model.id)
        item.orignal_name = model.original_name
        item.overview = model.overview
        item.media_type = model.media_type
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_count = Int64(model.vote_count)
        item.vote_average = model.vote_average
        
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabasError.failedToSaveData))
        }
    }
    
    
    func fetchingTitlesFromDataBase(completion: @escaping (Result<[TitleItem], Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem>
        
        request = TitleItem.fetchRequest()
        
        do {
            
            let titles = try context.fetch(request)
            completion(.success(titles))
            
        } catch {
            completion(.failure(DatabasError.failedToFetchData))
        }
    }
    
    func deleteTitleWith(model: TitleItem, completion: @escaping (Result<Void, Error>)-> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabasError.failedToDeleteData))
        }
        
    }
}
