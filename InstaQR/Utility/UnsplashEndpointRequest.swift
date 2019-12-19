//
//  UnsplashEndpointRequest.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit
import UnsplashPhotoPicker

class UnsplashEndpointRequest {
    
    var unsplashPhoto: UnsplashPhoto
    
    init(unsplashPhoto: UnsplashPhoto) {
        self.unsplashPhoto = unsplashPhoto
    }
    
    func start(completion: @escaping ((UIImage?) -> ())) {
        guard let url = unsplashPhoto.urls[.full] else { completion(nil); return }
        
        URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            guard
            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
            let data = data, error == nil,
            let image = UIImage(data: data)
            else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                let errorMessage = error?.localizedDescription
                
                print("\n---Request Failed---")
                print("URL: \(url)")
                print("Status Code: \(String(describing: statusCode))")
                print("Error Message: \(String(describing: errorMessage))")
                
                completion(nil)
                return
            }
            
            completion(image)
            
        }.resume()
    }
}
