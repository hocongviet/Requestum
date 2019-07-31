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
    
    let networkManager = NetworkManager(environment: .recipePuppy)

    @IBOutlet weak var recipeTableView: UITableView!
    let searchRecipeVC = SearchRecipeViewController()
    var searchController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setSearchBar()
        setTableView()
        getRecipiesFromAPI()
    }
    
    private func setNavigationBar() {
        title = "Recipe labs"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.barTintColor = UIColor.init(hexString: "2D8706")
    }
    
    private func setSearchBar() {
        // Set delegate for did select actions
        //searchController?.searchBar.delegate = searchRecipeVC

        // Setup search controller
        searchController = UISearchController(searchResultsController: searchRecipeVC)
        searchController?.searchBar.delegate = searchRecipeVC
        //searchController?.dimsBackgroundDuringPresentation = false
        //searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.placeholder = "Search"
        definesPresentationContext = true
        //navigationItem.titleView = searchController?.searchBar
        
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
    
    private func getRecipiesFromAPI() {
        DispatchQueue.global().async {
            self.networkManager.getModel(RecipePuppyJSON.self, fromAPI: .omelet) { [weak self] (result) in
                switch result {
                case .success(let model):
                    guard let results = model?.results else { return }
                    for result in results {
                        RecipeEntity.createRecipeEntity(thumbnailUrl: result.thumbnail, title: result.title, ingredients: result.ingredients)
                    }
                    
                    DispatchQueue.main.async {
                        self?.recipeTableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
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
