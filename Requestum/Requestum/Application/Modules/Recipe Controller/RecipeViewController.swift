//
//  RecipeViewController.swift
//  Requestum
//
//  Created by Cong Viet Ho on 7/30/19.
//  Copyright © 2019 Viety Software. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {
    
    let networkManager = NetworkManager(environment: .recipePuppy)

    @IBOutlet weak var recipeTableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    var recipePuppyModel = [RecipePuppyModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setSearchBar()
        setTableView()
        
        
        networkManager.getModel(RecipePuppyJSON.self, fromAPI: .omelet) { [weak self] (result) in
            switch result {
            case .success(let model):
                guard let results = model?.results else { return }
                for result in results {
                    var recipeModel = RecipePuppyModel()
                    recipeModel.thumbnailUrl = result.thumbnail
                    recipeModel.title = result.title
                    recipeModel.ingredients = result.ingredients
                    self?.recipePuppyModel.append(recipeModel)
                }
                DispatchQueue.main.async {
                    self?.recipeTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
        
    private func setNavigationBar() {
        title = "Recipe labs"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.barTintColor = UIColor.init(hexString: "2D8706")

    }
    
    private func setSearchBar() {
//        searchController.searchBar.barTintColor = .white
        //searchController.searchBar.tintColor = .white
        //searchController.searchBar.backgroundColor = .white

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setTableView() {
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
        recipeTableView.register(RecipeTableViewCell.nib, forCellReuseIdentifier: RecipeTableViewCell.reuseIdentifier)
    }

}

extension RecipeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}

extension RecipeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipePuppyModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.reuseIdentifier, for: indexPath) as! RecipeTableViewCell
        cell.recipePuppyModel = recipePuppyModel[indexPath.row]
        return cell
    }

}
