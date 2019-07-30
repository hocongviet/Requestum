//
//  RecipeEntity+CoreDataClass.swift
//  Requestum
//
//  Created by Cong Viet Ho on 7/31/19.
//  Copyright © 2019 Viety Software. All rights reserved.
//

import Foundation
import CoreData

class RecipeEntity: NSManagedObject {
    class func createRecipeEntity(thumbnailUrl: String?, title: String?, ingredients: String?) -> RecipeEntity {
        //        if let userEntity = getUserEntity(username: username, context: CoreDataStack.shared.mainManagedObjectContext) {
        //            return userEntity
        //        } else {
        let recipeEntity = RecipeEntity(context: CoreDataStack.shared.backgroundManagedObjectContext)
        recipeEntity.thumbnailUrl = thumbnailUrl
        recipeEntity.title = title
        recipeEntity.ingredients = ingredients
        CoreDataStack.shared.saveContext()
        
        return recipeEntity
        //}
        
    }
}
