//
//  NetworkManager.swift
//  Requestum
//
//  Created by Cong Viet Ho on 7/30/19.
//  Copyright © 2019 Viety Software. All rights reserved.
//

import Foundation

enum NetworkResponse: Error {
    case networkConnection
    case authenticationError
    case tooManyRequests
    case badRequest
    case outdated
    case failed
    case noData
    case unableToDecode
}

extension NetworkResponse: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .networkConnection:
            return "Please check your network connection."
        case .authenticationError:
            return "You need to be authenticated first."
        case .tooManyRequests:
            return "The user has sent too many requests in a given amount of time (\"rate limiting\")."
        case .badRequest:
            return "Bad request"
        case .outdated:
            return "The url you requested is outdated."
        case .failed:
            return "Network request failed."
        case .noData:
            return "Response returned with no data to decode."
        case .unableToDecode:
            return "We could not decode the response."
        }
    }
}

struct NetworkManager {
    
    enum ResponseResult<NetworkResponse>{
        case success
        case failure(NetworkResponse)
    }
    
    init(environment: NetworkEnvironment) {
        self.environment = environment
    }
    
    let environment: NetworkEnvironment!
    let router = Router<RecipePuppyApi>()
    
    func getModel<T: Decodable>(_ model: T.Type, fromAPI api: RecipePuppyApi, completion: @escaping (Result<T?, NetworkResponse>) -> ()) {
        router.request(environment: environment, api) { data, response, error in
            
            if error != nil {
                completion(.failure(.networkConnection))
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(.failure(.noData))
                        return
                    }
                    do {
                        //print(responseData)
                        //let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        //print(jsonData)
                        let apiResponse = try JSONDecoder().decode(model.self, from: responseData)
                        completion(.success(apiResponse))
                    } catch {
                        print(error)
                        completion(.failure(.unableToDecode))
                    }
                case .failure(let networkFailureError):
                    completion(.failure(networkFailureError))
                }
            }
        }
    }
    
    private func handleNetworkResponse(_ response: HTTPURLResponse) -> ResponseResult<NetworkResponse> {
        switch response.statusCode {
        case 200...299: return .success
        case 429: return .failure(NetworkResponse.tooManyRequests)
        case 400...428, 430...500: return .failure(NetworkResponse.authenticationError)
        case 501...599: return .failure(NetworkResponse.badRequest)
        case 600: return .failure(NetworkResponse.outdated)
        default: return .failure(NetworkResponse.failed)
        }
    }
}

