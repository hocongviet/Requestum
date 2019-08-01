//
//  RecipeModel.swift
//  Requestum
//
//  Created by Cong Viet Ho on 8/1/19.
//  Copyright © 2019 Viety Software. All rights reserved.
//

import Foundation

class RecipeModel {
    
    private let networkManager = NetworkManager(environment: .recipePuppy)
    
    func getRecipiesFromAPI(completion: @escaping () -> ()) {
        DispatchQueue.global().async {
            self.networkManager.getModel(RecipePuppyJSON.self, fromAPI: .omelet) { (result) in
                switch result {
                case .success(let model):
                    guard let results = model?.results else { return }
                    for result in results {
                        self.savingData(result: result) { (thumbnailData) in
                            RecipeEntity.createRecipeEntity(thumbnailPngData: thumbnailData, title: result.title, ingredients: result.ingredients, href: result.href)
                        }
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
    
    private func savingData(result: RecipePuppyResultsJSON, completion: @escaping (Data?) -> ()) {
        var thumbnailTemp: Data?
        guard let thumbnailUrl = result.thumbnail else {
            thumbnailTemp = nil
            completion(thumbnailTemp)
            return
        }
        guard let url = URL(string: thumbnailUrl) else {
            thumbnailTemp = nil
            completion(thumbnailTemp)
            return
        }
        PhotosManager.saveImageFromUrl(url, completion: { (image) in
            thumbnailTemp = image.pngData()
            completion(thumbnailTemp)
        })
        
    }
}
