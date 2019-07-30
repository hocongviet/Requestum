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
    @IBOutlet weak var recipeDescription: UILabel!

    static let reuseIdentifier = "RecipeTableViewCellIdentifier"

    override func awakeFromNib() {
        super.awakeFromNib()
        recipeImageView.makeRounded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var recipePuppyModel: RecipePuppyModel? {
        didSet {
            if let thumbnailUrl = recipePuppyModel?.thumbnailUrl {
                if thumbnailUrl.isEmpty {
                    self.recipeImageView.image = #imageLiteral(resourceName: "empty-plate")
                } else {
                    PhotosManager.saveImageFromUrl(URL(string: thumbnailUrl)) { (image) in
                        self.recipeImageView.image = image
                    }
                }
            }
            
            recipeTitle.text = recipePuppyModel?.title
            recipeDescription.text = recipePuppyModel?.description
        }
    }
    
}
