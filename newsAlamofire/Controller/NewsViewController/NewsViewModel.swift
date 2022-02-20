//
//  NewsViewModel.swift
//  newsAlamofire
//
//  Created by Massimiliano Bonafede on 20/02/22.
//  Copyright © 2022 Massimiliano Bonafede. All rights reserved.
//

import Foundation

class NewsViewModel {
    
    private let client: Client
    private(set) var newsMO: NewsMO?
    private var error: Error?
    
    init(country: String) {
        client = Client(country: country)
    }
    
    func performRequest(_ completion: @escaping((Result) -> Void)) {
        client.performRequest { data in
            if let data = data {
                ClientAdapter(data: data).parseResponse { result in
                    switch result {
                    case .success(let newsMO):
                        self.newsMO = newsMO
                    case .failure(let error):
                        self.error = error
                    }
                    completion(result)
                }
            } else {
                completion(.failure(.genericError))
            }
        }
    }
    
    func retriveAuthorAndURLAt(_ indexPath: IndexPath) -> (auth: String, url: String) {
        let auth = newsMO?.articles[indexPath.row].author ?? "Unknown"
        let url = newsMO?.articles[indexPath.row].url ?? ""
        return (auth, url)
    }
}
