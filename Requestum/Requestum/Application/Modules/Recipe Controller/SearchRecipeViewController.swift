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
        
//        networkManager.getModel(RecipePuppyJSON.self, fromAPI: .search(title: "tomato")) { [weak self] (result) in
//            switch result {
//            case .success(let model):
//                guard let results = model?.results else { return }
//                for result in results {
//                    var recipeCellModel = RecipeCellModel()
//                    recipeCellModel.thumbnailUrl = result.thumbnail
//                    recipeCellModel.title = result.title
//                    recipeCellModel.ingredients = result.ingredients
//                    self?.recipeCellModels.append(recipeCellModel)
//                }
//                DispatchQueue.main.async {
//                    self?.recipeTableView.reloadData()
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
            recipeCellModel.thumbnailUrl = "searching.thumbnail"
            recipeCellModel.title = "searching.thumbnail.title"
            recipeCellModel.ingredients = "searching.thumbnail.ingredients"
            self.recipeCellModels.append(recipeCellModel)
            DispatchQueue.main.async {
                if let indexPaths = DiffUtil.getInsertionItems(oldValue: oldValue, newValue: self.recipeCellModels.count) {
                    DiffUtil.reloadTableViewRows(self.recipeTableView, atIndexPaths: indexPaths)
                }
                //self.recipeTableView.reloadData()
            }
            perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.5)
        }
        
    }
    
    @objc func reload(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, searchText.trimmingCharacters(in: .whitespaces) != "" else {
            print("nothing to search")
            let oldValue = recipeCellModels.count
            recipeCellModels.removeAll()
            
            DispatchQueue.main.async {
                searchBar.isLoading = false
                if let indexPaths = DiffUtil.getDeletionItems(oldValue: oldValue) {
                    self.recipeTableView.deleteRows(at: indexPaths, with: .fade)
                }
                //self.recipeTableView.reloadData()

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
                    recipeCellModel.thumbnailUrl = "result.thumbnail"
                    recipeCellModel.title = "result.title"
                    recipeCellModel.ingredients = "result.ingredients"
                    self.recipeCellModels.append(recipeCellModel)
                }
                
                DispatchQueue.main.async {
                    searchBar.isLoading = false
                    if let indexPaths = DiffUtil.getInsertionItems(oldValue: oldValue, newValue: self.recipeCellModels.count) {
                        DiffUtil.reloadTableViewRows(self.recipeTableView, atIndexPaths: indexPaths, animation: .fade)
                    }
                    //self.recipeTableView.reloadData()
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
