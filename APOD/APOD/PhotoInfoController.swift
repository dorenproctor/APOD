//
//  PhotoInfoController.swift
//  APOD
//
//  Created by Doren Proctor on 4/7/18.
//  Copyright © 2018 Doren Proctor. All rights reserved.
//

import Foundation
class PhotoInfoController {
    func fetchPhotoInfo(date: String, completion: @escaping (PhotoInfo?) -> Void)
    {
        let baseURL = URL(string: "https://api.nasa.gov/planetary/apod")!
        let query: [String: String] = [
            "api_key": "IBcypJSuljZUGsIthbZ9X8bF9eQVXQvpebRombt4",
            "date": date
        ]
        print(date)
        let url = baseURL.withQueries(query)!
        let task = URLSession.shared.dataTask(with: url) { (data,
            response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data {
                if let photoInfo = try?
                    jsonDecoder.decode(PhotoInfo.self, from: data) {
                completion(photoInfo)
                } else {
                    print(String(data: data, encoding: .utf8))
                    print("Data was not serialized.")
                    completion(nil)
                }
            } else {
                print("No data was returned.")
                completion(nil)
            }
        }
        task.resume()
    }
}
