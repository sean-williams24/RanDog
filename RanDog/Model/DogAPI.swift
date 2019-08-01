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
    enum Endpoint {
        case randomImageFromAllDogsCollection
        case randomImageFromBreed(String)
        case listAllBreeds
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
        // switch on self which is whatever the enum case happens to be
        var stringValue: String {
            switch self {
            case .randomImageFromAllDogsCollection:
                return "https://dog.ceo/api/breeds/image/random"
            case .randomImageFromBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
            case .listAllBreeds:
                return "https://dog.ceo/api/breeds/list/all"
            }
        }
    }
    
    class func requestBreedsList(completionHandler: @escaping ([String], Error?) -> Void ) {
        let task = URLSession.shared.dataTask(with: DogAPI.Endpoint.listAllBreeds.url) { (data, response, error) in
            guard let data = data else {
                completionHandler([], error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let breedsData = try decoder.decode(Breed.self, from: data)
                let breedsDict = breedsData.message
                // Map over the keys in the dictionary and pass into constant as array
                let breed = breedsDict.keys.map({$0})
                // Call completion handler, passing in the breeds array.
                completionHandler(breed, nil)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    
    // If the data request is successful the DogImage will be returned by complettion handler, if not the error will be.
    class func requestRandomImage(breed: String, completionHandler: @escaping (DogImage?, Error?) -> Void ) {
        let randomImageEndpoint =  DogAPI.Endpoint.randomImageFromBreed(breed).url

        
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
