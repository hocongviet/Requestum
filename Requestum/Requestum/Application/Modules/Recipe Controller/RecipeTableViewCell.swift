//
//  RecipeTableViewCell.swift
//  Requestum
//
//  Created by Cong Viet Ho on 7/30/19.
//  Copyright © 2019 Viety Software. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell, NibLoadable {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeIngredients: UILabel!

    static let reuseIdentifier = "RecipeTableViewCellIdentifier"

    
    override func awakeFromNib() {
        super.awakeFromNib()
        recipeImageView.makeRounded()
        setSeparatorEndToEnd()
    }
    
    private func setSeparatorEndToEnd() {
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var recipePuppyEntity: RecipeEntity? {
        didSet {
            if let thumbnail = recipePuppyEntity?.thumbnail {
                if thumbnail.isEmpty {
                    self.recipeImageView.image = #imageLiteral(resourceName: "empty-plate")
                } else {
                    PhotosManager.saveImageFromUrl(URL(string: thumbnail)) { (image) in
                        self.recipeImageView.image = image
                    }
                }
            }
            
            recipeTitle.text = recipePuppyEntity?.title
            recipeIngredients.text = recipePuppyEntity?.ingredients
        }
    }
    
    var recipeCellModel: RecipeCellModel? {
        didSet {
            if let thumbnailUrl = recipeCellModel?.thumbnailUrl {
                if thumbnailUrl.isEmpty {
                    self.recipeImageView.image = #imageLiteral(resourceName: "empty-plate")
                } else {
                    PhotosManager.saveImageFromUrl(URL(string: thumbnailUrl)) { (image) in
                        self.recipeImageView.image = image
                    }
                }
            }
            
            recipeTitle.text = recipeCellModel?.title
            recipeIngredients.text = recipeCellModel?.ingredients
        }
    }
    
}
