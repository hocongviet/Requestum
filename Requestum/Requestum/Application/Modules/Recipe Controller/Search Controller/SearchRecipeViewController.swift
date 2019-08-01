//
//  SearchRecipeViewController.swift
//  Requestum
//
//  Created by Cong Viet Ho on 7/31/19.
//  Copyright © 2019 Viety Software. All rights reserved.
//

import UIKit
import SafariServices

class SearchRecipeViewController: UIViewController {

    private let searchRecipeModel = SearchRecipeModel()
    private let recipeTableView = UITableView()
    
    override func loadView() {
        super.loadView()
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
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
        searchBar.isLoading = true
        if searchText.isEmpty {
            perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.0)
        } else {
            searchRecipeModel.mappingSearchingFor { [weak self] (indexPaths) in
                guard let self = self else { return }
                DiffUtil.reloadTableViewRows(self.recipeTableView, atIndexPaths: indexPaths)
            }
            perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.5)
        }
        
    }
    
    @objc func reload(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, searchText.trimmingCharacters(in: .whitespaces) != "" else {
            // NOTHING TO SEARCH
            searchRecipeModel.removeSearchModel { (indexPaths) in
                searchBar.isLoading = false
                self.recipeTableView.deleteRows(at: indexPaths, with: .fade)
            }
            return
        }
        searchRecipeModel.getReloadDataSearch(searchText: searchText) { [weak self] (indexPaths) in
            guard let self = self else { return }
            searchBar.isLoading = false
            DiffUtil.reloadTableViewRows(self.recipeTableView, atIndexPaths: indexPaths, animation: .fade)
        }
        
    }
}

extension SearchRecipeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)

        guard let validUrlString = searchRecipeModel.recipeCellModels[indexPath.row].href else { return }
        guard let url = URL(string: validUrlString) else {
            return
        }
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }
    
}

extension SearchRecipeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchRecipeModel.recipeCellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.reuseIdentifier, for: indexPath) as! RecipeTableViewCell
        cell.recipeCellModel = searchRecipeModel.recipeCellModels[indexPath.row]
        return cell
    }
}
