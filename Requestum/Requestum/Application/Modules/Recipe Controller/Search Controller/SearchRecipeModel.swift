//
//  SearchRecipeModel.swift
//  Requestum
//
//  Created by Cong Viet Ho on 8/1/19.
//  Copyright © 2019 Viety Software. All rights reserved.
//

import Foundation

class SearchRecipeModel {
    private let networkManager = NetworkManager(environment: .recipePuppy)
    private(set) var recipeCellModels = [RecipeCellModel]()
    
    func mappingSearchingFor(completion: @escaping ([IndexPath]) -> ()) {
        self.recipeCellModels.removeAll()
        let oldValue = self.recipeCellModels.count
        var recipeCellModel = RecipeCellModel()
        recipeCellModel.thumbnailUrl = ""
        recipeCellModel.title = "Searching for..."
        recipeCellModel.ingredients = "Ingredients..."
        recipeCellModel.href = nil
        self.recipeCellModels.append(recipeCellModel)
        DispatchQueue.main.async {
            if let indexPaths = DiffUtil.getInsertionItems(oldValue: oldValue, newValue: self.recipeCellModels.count) {
                completion(indexPaths)
            }
        }
    }
    
    func getReloadDataSearch(searchText: String, completion: @escaping ([IndexPath]) -> ()) {
        networkManager.getModel(RecipePuppyJSON.self, fromAPI: .search(title: searchText)) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.recipeCellModels.removeAll()
                let oldValue = self.recipeCellModels.count
                guard let results = model?.results else { return }
                for result in results {
                    var recipeCellModel = RecipeCellModel()
                    recipeCellModel.thumbnailUrl = result.thumbnail
                    recipeCellModel.title = result.title
                    recipeCellModel.ingredients = result.ingredients
                    recipeCellModel.href = result.href
                    self.recipeCellModels.append(recipeCellModel)
                }
                
                if self.recipeCellModels.isEmpty {
                    var recipeCellModel = RecipeCellModel()
                    recipeCellModel.thumbnailUrl = ""
                    recipeCellModel.title = "Not found"
                    recipeCellModel.ingredients = "No ingredients"
                    recipeCellModel.href = nil
                    self.recipeCellModels.append(recipeCellModel)
                }
                
                DispatchQueue.main.async {
                    if let indexPaths = DiffUtil.getInsertionItems(oldValue: oldValue, newValue: self.recipeCellModels.count) {
                        completion(indexPaths)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func removeSearchModel(completion: @escaping ([IndexPath]) -> ()) {
        let oldValue = recipeCellModels.count
        recipeCellModels.removeAll()
        
        DispatchQueue.main.async {
            if let indexPaths = DiffUtil.getDeletionItems(oldValue: oldValue) {
                completion(indexPaths)
                
            }
        }
    }
    
}
