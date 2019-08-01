//
//  UIImageView+Extensions.swift
//  Requestum
//
//  Created by Cong Viet Ho on 7/30/19.
//  Copyright © 2019 Viety Software. All rights reserved.
//

import UIKit

extension UIImageView {
    func makeRounded() {
        let radius = self.bounds.width / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
