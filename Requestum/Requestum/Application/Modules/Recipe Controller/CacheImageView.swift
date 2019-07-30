//
//  CacheImageView.swift
//  Requestum
//
//  Created by Cong Viet Ho on 7/30/19.
//  Copyright © 2019 Viety Software. All rights reserved.
//

import UIKit

class CacheImageView: UIImageView {
    private let imageCache = NSCache<NSString, UIImage>()
    private var activityIndicatorView = UIActivityIndicatorView()
    private var imageUrlString: String?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setActivityIndicator()
        self.contentMode = .scaleAspectFill
    }
    
    private func setActivityIndicator() {
        addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func loadImageUsingUrlString(urlString: String) {
        
        imageUrlString = urlString
        guard let url = URL(string: urlString) else { return }
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.activityIndicatorView.stopAnimating()
            self.image = imageFromCache
            return
        } else {
            activityIndicatorView.startAnimating()
            //self.image = UIImage(color: UIColor.init(hexString: "DCDCDC"))
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, respones, error) in
            if error != nil {
                print(error ?? "")
                return
            }
            DispatchQueue.main.async {
                guard let imageToCache = UIImage(data: data!) else { return }
                
                if self.imageUrlString == urlString {
                    self.activityIndicatorView.stopAnimating()
                    self.image = imageToCache
                }
                
                self.imageCache.setObject(imageToCache, forKey: urlString as NSString)
            }
        }).resume()
        
    }
}
