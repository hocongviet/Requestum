//
//  RecipeEntity+CoreDataClass.swift
//  Requestum
//
//  Created by Cong Viet Ho on 7/31/19.
//  Copyright © 2019 Viety Software. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class RecipeEntity: NSManagedObject {
    
    class func getRecipeCount() -> Int {
        return getAllRecipes()?.count ?? 0
    }
    
    class func getRecipeEntity(_ title: String?) -> RecipeEntity? {
        let context = CoreDataStack.shared.mainManagedObjectContext
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        guard let title = title else { return nil }
        request.predicate = NSPredicate(format: "title == %@", title)
        request.fetchLimit = 1
        
        do {
            let recipes = try context.fetch(request)
            if recipes.count > 0 {
                return recipes[0]
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
        
    }
    
    class func getAllRecipes() -> [RecipeEntity]? {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        do {
            let recipes = try CoreDataStack.shared.mainManagedObjectContext.fetch(request)
            return recipes
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    class func createRecipeEntity(thumbnailUrl: String?, title: String?, ingredients: String?) {
        if RecipeEntity.getRecipeEntity(title) == nil {
            let recipeEntity = RecipeEntity(context: CoreDataStack.shared.backgroundManagedObjectContext)

            recipeEntity.thumbnail = thumbnailUrl
            recipeEntity.title = title
            recipeEntity.ingredients = ingredients
            CoreDataStack.shared.saveContext()
            
        }
    }
}
