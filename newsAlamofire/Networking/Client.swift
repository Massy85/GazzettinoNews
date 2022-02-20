//
//  Client.swift
//  newsAlamofire
//
//  Created by Massimiliano Bonafede on 16/02/22.
//  Copyright © 2022 Massimiliano Bonafede. All rights reserved.
//

import Foundation

protocol ClietProtocol {
    func performRequest(_ completion: @escaping ((Data?) -> Void))
}

class Client {
    
    private let country: String
    
    init(country: String) {
        self.country = country
    }
    
    private func createURL() -> URL {
        return URL(string: "https://newsapi.org/v2/top-headlines?country=\(country)&apiKey=d1100591b9054c3da2fef23e4c9a2a15")!
    }
}

extension Client: ClietProtocol {
    func performRequest(_ completion: @escaping ((Data?) -> Void)) {
        URLSession.shared.dataTask(with: createURL()) { data, response, error in
            if let _ = error {
                completion(nil)
            } else if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String:Any]
                    guard let json = json else {
                        completion(nil)
                        return
                    }
                    let theJSONData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    let theJSONText = String(data: theJSONData, encoding: .ascii)
                    //print("🚀🚀🚀 JSON string = \(theJSONText!)")
                    completion(data)
                } catch {
                    completion(nil)
                }
            }
        }.resume()
    }
}
