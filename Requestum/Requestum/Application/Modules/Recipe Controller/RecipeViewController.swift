//
//  RecipeViewController.swift
//  Requestum
//
//  Created by Cong Viet Ho on 7/30/19.
//  Copyright © 2019 Viety Software. All rights reserved.
//

import UIKit
import CoreData

class RecipeViewController: UIViewController {

    @IBOutlet weak var recipeTableView: UITableView!
    let searchRecipeVC = SearchRecipeViewController()
    var searchController: UISearchController?
    let recipeModel = RecipeModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setSearchBar()
        setTableView()
        recipeModel.getRecipiesFromAPI {
            self.recipeTableView.reloadData()
        }
    }
    
    private func setNavigationBar() {
        title = "Recipe labs"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.barTintColor = UIColor.init(hexString: "2D8706")
    }
    
    private func setSearchBar() {
        // Setup search controller
        searchController = UISearchController(searchResultsController: searchRecipeVC)
        searchController?.searchBar.delegate = searchRecipeVC
        searchController?.searchBar.placeholder = "Search"
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        if let txfSearchField = searchController?.searchBar.value(forKey: "_searchField") as? UITextField {
            txfSearchField.borderStyle = .none
            txfSearchField.backgroundColor = .white
            txfSearchField.layer.cornerRadius = 12
            txfSearchField.layer.masksToBounds = true
        }
        
    }
    
    private func setTableView() {
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
        recipeTableView.register(RecipeTableViewCell.nib, forCellReuseIdentifier: RecipeTableViewCell.reuseIdentifier)
        recipeTableView.estimatedRowHeight = 100
        recipeTableView.rowHeight = UITableView.automaticDimension
    }
    
}

extension RecipeViewController: UITableViewDelegate {
    
}

extension RecipeViewController: UITableViewDataSource {
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
