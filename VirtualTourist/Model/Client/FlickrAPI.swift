//
//  FlickrAPI.swift
//  VirtualTourist
//
//  Created by Byron Ajin on 7/11/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import Foundation

class FlickrAPI {
    
    static let errorMessage = "An error ocurred loading images"
    
    enum Endpoints {
        static let apiKey = "afbc15c4c0db3a18d3c69b51067c8653"
        static let base = "https://www.flickr.com/services/rest/"
        static let perPage = 30
        
        case photosSearch(String, String, String)
        
        var stringValue: String {
            switch self {
            case .photosSearch(let latitude, let longitude, let page):
                return Endpoints.base +
                    "?method=flickr.photos.search" +
                    "&api_key=\(Endpoints.apiKey)" +
                    "&format=json" +
                    "&lat=\(latitude)" +
                    "&lon=\(longitude)" +
                    "&per_page=\(Endpoints.perPage)" +
                    "&page=\(page)" +
                "&extras=url_m"
            }
        }
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
    }
    
    
    class func getListOfPhotosUrl(latitude: String, longitude: String, page: String, completionHandler: @escaping ([PhotoUrl], String?) -> Void) {
        let photosURL = Endpoints.photosSearch(latitude, longitude, page).url
        let task = URLSession.shared.dataTask(with: photosURL) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler([], errorMessage)
                }
                return
            }
            do {
                let newData = data.subdata(in: (14..<data.count-1))
                let decoder = JSONDecoder()
                let photosList = try decoder.decode(PhotoCollection.self, from: newData)
                DispatchQueue.main.async {
                    completionHandler(photosList.photos.photo, nil)
                }
            }catch {
                DispatchQueue.main.async {
                    completionHandler([], errorMessage)
                }
            }
        }
        task.resume()
    }
    
}
