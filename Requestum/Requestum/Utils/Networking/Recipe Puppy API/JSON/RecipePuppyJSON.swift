//
//  RecipePuppyJSON.swift
//  Requestum
//
//  Created by Cong Viet Ho on 7/30/19.
//  Copyright © 2019 Viety Software. All rights reserved.
//

import Foundation

struct RecipePuppyJSON: Codable {
    var title: String?
    var version: Double?
    var href: String?
    var results: [RecipePuppyResultsJSON]?
}

struct RecipePuppyResultsJSON: Codable {
    var title: String?
    var href: String?
    var ingredients: String?
    var thumbnail: String?
}
