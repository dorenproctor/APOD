//
//  PhotoInfoController.swift
//  APOD
//
//  Created by Doren Proctor on 4/7/18.
//  Copyright © 2018 Doren Proctor. All rights reserved.
//

import UIKit
class PhotoInfoController {
    func fetchPhotoInfo(date: String, completion: @escaping (PhotoInfo?) -> Void)
    {
        let baseURL = URL(string: "https://api.nasa.gov/planetary/apod")!
        let query: [String: String] = [
            "api_key": "IBcypJSuljZUGsIthbZ9X8bF9eQVXQvpebRombt4",
            "date": date
        ]
        let url = baseURL.withQueries(query)!
        let task = URLSession.shared.dataTask(with: url) { (data,
            response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data {
                if let photoInfo = try?
                    jsonDecoder.decode(PhotoInfo.self, from: data) {
                completion(photoInfo)
                } else {
                    let alert = UIAlertController(title: "Data was not serialized.", message: String(data: data, encoding: .utf8), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .`default`, handler: { _ in
                    }))
                UIApplication.shared.windows[0].rootViewController?.present(alert, animated: true, completion: nil)
                    completion(nil)
                }
            } else {
                print("No data was returned.")
                let alert = UIAlertController(title: "No data was returned.", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .`default`, handler: { _ in
                }))
            UIApplication.shared.windows[0].rootViewController?.present(alert, animated: true, completion: nil)
                completion(nil)
            }
        }
        task.resume()
    }
}
