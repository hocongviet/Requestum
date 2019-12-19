//
//  TabBarController.swift
//  Requestum
//
//  Created by Vladimir Ho on 20.12.2019.
//  Copyright © 2019 Viety Software. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let vc1 = R.storyboard.main.recipeViewController()!
        
        viewControllers = [UINavigationController(rootViewController: vc1)]
    }

}
