//
//  DogAPI.swift
//  RanDog
//
//  Created by Sean Williams on 30/07/2019.
//  Copyright © 2019 Sean Williams. All rights reserved.
//

import Foundation
import UIKit

class DogAPI {
    enum Endpoint: String {
        case randomImageFromAllDogsCollection = "https://dog.ceo/api/breeds/image/random"
        
        var url: URL {
            return URL(string: self.rawValue)!
        }
    }
    
    // If the data request is successful the DogImage will be returned by complettion handler, if not the error will be.
    class func requestRandomImage(completionHandler: @escaping (DogImage?, Error?) -> Void ) {
        let randomImageEndpoint =  DogAPI.Endpoint.randomImageFromAllDogsCollection.url

        
        // Fetch JSON response from DogAPI to obtain the images URL
        let task = URLSession.shared.dataTask(with: randomImageEndpoint) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return }
            
            // Parse JSON data and place in Dogimage object
            let decoder = JSONDecoder()
            let imageData = try! decoder.decode(DogImage.self, from: data)
            completionHandler(imageData, nil)
        }
        task.resume()
    }
    
    
    class func requestImageFile(url: URL, completetionHandler: @escaping (UIImage?, Error?) -> Void ) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data else {
                completetionHandler(nil, error)
                return }
            
            let downloadedImage = UIImage(data: data)
            completetionHandler(downloadedImage, nil)
        })
        task.resume()
    }
}
