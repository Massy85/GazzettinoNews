//
//  ClientAdapter.swift
//  newsAlamofire
//
//  Created by Massimiliano Bonafede on 16/02/22.
//  Copyright © 2022 Massimiliano Bonafede. All rights reserved.
//

import Foundation

enum Error: Swift.Error {
    case genericError
    case decodeFailure
}

enum Result {
    case success(NewsMO)
    case failure(Error)
}

protocol AdapterProtocol {
    init(data: Data)
    func parseResponse(_ completion: @escaping((Result) -> Void))
}

class ClientAdapter {
    
    let data: Data
    
    required init(data: Data) {
        self.data = data
    }
}

extension ClientAdapter: AdapterProtocol {
    func parseResponse(_ completion: @escaping((Result) -> Void)) {
        do {
            let result = try JSONDecoder().decode(NewsMO.self, from: data)
            completion(.success(result))
        } catch {
            completion(.failure(.decodeFailure))
        }
    }
}
