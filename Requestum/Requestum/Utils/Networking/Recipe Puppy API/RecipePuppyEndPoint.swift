//
//  RecipePuppyEndPoint.swift
//  Requestum
//
//  Created by Cong Viet Ho on 7/30/19.
//  Copyright © 2019 Viety Software. All rights reserved.
//

import Foundation

public enum NetworkEnvironment: String {
    case recipePuppy = "http://www.recipepuppy.com/api/"
}

public enum RecipePuppyApi {
    // Private API
    case omelet
    case search(title: String)
}

extension RecipePuppyApi: EndpointType {
    var endpoint: String {
        switch self {
        case .omelet:
            var components = URLComponents()
            let ingredientsQueryItem = URLQueryItem(name: "i", value: "onions,garlic")
            let searchQueryItem = URLQueryItem(name: "q", value: "omelet")
            let pageQueryItem = URLQueryItem(name: "p", value: "3")
            components.queryItems = [ingredientsQueryItem, searchQueryItem, pageQueryItem]
            guard let path = components.url else { return String() }
            return path.absoluteString
        case .search(let title):
            var components = URLComponents()
            components.queryItems = [URLQueryItem(name: "q", value: title)]
            guard let path = components.url else { return String() }
            return path.absoluteString
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}


