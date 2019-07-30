//
//  EndpointType.swift
//  Requestum
//
//  Created by Cong Viet Ho on 7/30/19.
//  Copyright © 2019 Viety Software. All rights reserved.
//

import Foundation

protocol EndpointType {
    var endpoint: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
