//
//  PhotosManager.swift
//  Requestum
//
//  Created by Cong Viet Ho on 7/30/19.
//  Copyright © 2019 Viety Software. All rights reserved.
//

import Photos

struct PhotosManager {
    static func saveImageFromUrl(_ url: URL?, completion: @escaping (UIImage) -> ()) {
        guard let url = url else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            guard let data = try? Data(contentsOf: url) else  { return }
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
}
