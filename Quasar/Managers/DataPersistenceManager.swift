//
//  DataPersistanceManager.swift
//  Quasar
//
//  Created by Basem El kady on 4/2/22.
//

import Foundation
import UIKit
import CoreData

class DataPersistenceManager {
    
    static let shared = DataPersistenceManager()
    
    
    
    /// This method is responsible for saving the articles to the local data base when the user adds it to favorites
    /// - Parameters:
    ///   - article: The article object that corresponds to the article the user added to favorites
    ///   - completion: The completion handler will return an error in case the saving failed, and in case of success it will return nothing
    func persistArticleWith(article:Article, completion:@escaping(Result<Void,QuasarError>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let storedArticle = StoredArticle(context: context)
        
        storedArticle.imageUrl    = article.imageUrl
        storedArticle.title       = article.title
        storedArticle.id          = Int64 (article.id)
        storedArticle.newsSite    = article.newsSite
        storedArticle.publishedAt = article.publishedAt
        storedArticle.summary     = article.summary
        storedArticle.url         = article.url
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            print (error)
            completion(.failure(QuasarError.savingDataFailure))
        }
    }
    
    /// This method is responsible for loading the saved articles from the local data base
    /// - Parameter completion: The completion handler will return an arrray of StoredArticles  in case success, and in case of failure it will return an error
    func loadArticleFromDataBase(completion:@escaping(Result<[StoredArticle],QuasarError>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<StoredArticle>
        request = StoredArticle.fetchRequest()
        
        do {
            let fetchedArticles = try context.fetch(request)
            completion(.success(fetchedArticles))
        } catch {
            print(error.localizedDescription)
            completion(.failure(QuasarError.loadingDataFailure))
        }
    }
    
    /// This method is responsible for deleting an article from the local data base
    /// - Parameters:
    ///   - storedArticle: The stored article object that needs to be deleted
    ///   - completion: The completion handler will return an error in case the saving failed, and in case of success it will return nothing
    func deleteArticleFromDataBaseWith(storedArticle:StoredArticle, completion:@escaping(Result<Void,QuasarError>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(storedArticle)
        do {
            try context.save()
            completion(.success(()))
        } catch {
            print(error.localizedDescription)
            completion(.failure(QuasarError.deletingDataFailure))
        }
    }
    
    func checkIfArticleIsStoredWith(_ articleId:Int) -> Bool {
      
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let context = appDelegate!.persistentContainer.viewContext
        
        let request: NSFetchRequest<StoredArticle>
        request = StoredArticle.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %d" ,articleId)
        do {
            let count = try context.count(for: request)
            if count > 0{
                                return true
            } else {

                return false
            }
        } catch {
            print(QuasarError.dataRetrivingFailure)
        }
        return true
    }
}
