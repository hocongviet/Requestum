//
//  SearchRecipeViewController.swift
//  Requestum
//
//  Created by Cong Viet Ho on 7/31/19.
//  Copyright © 2019 Viety Software. All rights reserved.
//

import UIKit

class SearchRecipeViewController: UIViewController {
    let networkManager = NetworkManager(environment: .recipePuppy)

    let recipeTableView = UITableView()
    var recipeCellModels = [RecipeCellModel]()
    
    override func loadView() {
        view = recipeTableView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(hexString: "F5F5F5")
        
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
        recipeTableView.register(RecipeTableViewCell.nib, forCellReuseIdentifier: RecipeTableViewCell.reuseIdentifier)
        recipeTableView.estimatedRowHeight = 100
        recipeTableView.rowHeight = UITableView.automaticDimension
    }

}

extension SearchRecipeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
        searchBar.isLoading = true
        if searchText.isEmpty {
            perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.0)
        } else {
            self.recipeCellModels.removeAll()
            let oldValue = self.recipeCellModels.count
            var recipeCellModel = RecipeCellModel()
            recipeCellModel.thumbnailUrl = ""
            recipeCellModel.title = "Searching for..."
            recipeCellModel.ingredients = "Ingredients..."
            self.recipeCellModels.append(recipeCellModel)
            DispatchQueue.main.async {
                if let indexPaths = DiffUtil.getInsertionItems(oldValue: oldValue, newValue: self.recipeCellModels.count) {
                    DiffUtil.reloadTableViewRows(self.recipeTableView, atIndexPaths: indexPaths)
                }
            }
            perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.5)
        }
        
    }
    
    @objc func reload(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, searchText.trimmingCharacters(in: .whitespaces) != "" else {
            // NOTHING TO SEARCH
            let oldValue = recipeCellModels.count
            recipeCellModels.removeAll()
            
            DispatchQueue.main.async {
                searchBar.isLoading = false
                if let indexPaths = DiffUtil.getDeletionItems(oldValue: oldValue) {
                    self.recipeTableView.deleteRows(at: indexPaths, with: .fade)
                }
            }
            return
        }
        
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
                    self.recipeCellModels.append(recipeCellModel)
                }

                if self.recipeCellModels.isEmpty {
                    var recipeCellModel = RecipeCellModel()
                    recipeCellModel.thumbnailUrl = ""
                    recipeCellModel.title = "Not found"
                    recipeCellModel.ingredients = "No ingredients"
                    self.recipeCellModels.append(recipeCellModel)
                }
                
                DispatchQueue.main.async {
                    searchBar.isLoading = false
                    if let indexPaths = DiffUtil.getInsertionItems(oldValue: oldValue, newValue: self.recipeCellModels.count) {
                        DiffUtil.reloadTableViewRows(self.recipeTableView, atIndexPaths: indexPaths, animation: .fade)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchRecipeViewController: UITableViewDelegate {
    
}

extension SearchRecipeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeCellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.reuseIdentifier, for: indexPath) as! RecipeTableViewCell
        cell.recipeCellModel = recipeCellModels[indexPath.row]
        return cell
    }
}
