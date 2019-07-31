//
//  RecipeDataSourceDelegate.swift
//  Requestum
//
//  Created by Cong Viet Ho on 7/31/19.
//  Copyright © 2019 Viety Software. All rights reserved.
//

import Foundation
import UIKit

protocol RecipeDelegate: class {
    func getRecipesCount() -> Int
    func getRecipeItem(_ row: Int) -> RecipeEntity?
}


class RecipeDataSourceDelegate: NSObject {
    weak var recipeDelegate: RecipeDelegate!
}

extension RecipeDataSourceDelegate: UITableViewDelegate {
    
}

extension RecipeDataSourceDelegate: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecipeEntity.getRecipeCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.reuseIdentifier, for: indexPath) as! RecipeTableViewCell
        let recipies = RecipeEntity.getAllRecipes()
        cell.recipePuppyEntity = recipies?[indexPath.row]
        return cell
    }
    
    
}
