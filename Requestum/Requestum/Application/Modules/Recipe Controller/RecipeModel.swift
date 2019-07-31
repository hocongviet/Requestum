//
//  RecipeModel.swift
//  Requestum
//
//  Created by Cong Viet Ho on 8/1/19.
//  Copyright © 2019 Viety Software. All rights reserved.
//

import Foundation

class RecipeModel {
    let networkManager = NetworkManager(environment: .recipePuppy)

    func getRecipiesFromAPI(completion: @escaping () -> ()) {
        DispatchQueue.global().async {
            self.networkManager.getModel(RecipePuppyJSON.self, fromAPI: .omelet) { (result) in
                switch result {
                case .success(let model):
                    guard let results = model?.results else { return }
                    for result in results {
                        RecipeEntity.createRecipeEntity(thumbnailUrl: result.thumbnail, title: result.title, ingredients: result.ingredients)
                    }
                    
                    DispatchQueue.main.async {
                        completion()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
