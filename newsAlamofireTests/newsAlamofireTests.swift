//
//  newsAlamofireTests.swift
//  newsAlamofireTests
//
//  Created by Massimiliano on 11/06/2019.
//  Copyright © 2019 Massimiliano Bonafede. All rights reserved.
//

import XCTest
@testable import GazzettinoNews

class newsAlamofireTests: XCTestCase {

    func test_successResponse() {
        var adapterError: Error?
        var object: NewsMO?
        
        let expectation = expectation(description: "test.news.success")
        
        MockAPI().performSuccess { result in
            switch result {
            case .success(let newsMO):
                object = newsMO
                expectation.fulfill()
            case .failure(let error):
                adapterError = error
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertNil(adapterError)
        XCTAssertNotNil(object)
    }
    
    func test_errorResponse() {
        var adapterError: Error?
        var object: NewsMO?
        
        let expectation = expectation(description: "test.news.failure")
        
        MockAPI().performError { result in
            switch result {
            case .success(let newsMO):
                object = newsMO
                expectation.fulfill()
            case .failure(let error):
                adapterError = error
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertNotNil(adapterError)
        XCTAssertEqual(adapterError, .decodeFailure)
        XCTAssertNil(object)
    }
    
    // MARK: - Helper

    private func createSUT() {}

}

class MockAPI {
    func performSuccess(_ completion: @escaping((Result) -> Void)) {
        MockClientSuccess().performRequest { data in
            if let data = data {
                MockAdapter(data: data).parseResponse { completion($0) }
            } else {
                completion(.failure(.genericError))
            }
        }
    }
    
    func performError(_ completion: @escaping((Result) -> Void)) {
        MockClientFailure().performRequest { data in
            if let data = data {
                MockAdapter(data: data).parseResponse { completion($0) }
            } else {
                completion(.failure(.genericError))
            }
        }
    }
}

class MockClientSuccess: ClietProtocol {
    func performRequest(_ completion: @escaping ((Data?) -> Void)) {
        completion(Data(json))
    }
}

class MockClientFailure: ClietProtocol {
    func performRequest(_ completion: @escaping ((Data?) -> Void)) {
        completion(Data())
    }
}

class MockAdapter: AdapterProtocol {
    let data: Data
    
    required init(data: Data) {
        self.data = data
    }
    
    func parseResponse(_ completion: @escaping ((Result) -> Void)) {
        do {
            let result = try JSONDecoder().decode(NewsMO.self, from: data)
            completion(.success(result))
        } catch {
            completion(.failure(.decodeFailure))
        }
    }
}


let json = """
{
  "status" : "ok",
  "totalResults" : 37,
  "articles" : [
    {
      "source" : {
        "id" : "cnn",
        "name" : "CNN"
      },
      "author" : "By Joshua Berlinger",
      "urlToImage" : "https://super-tease.jpg",
      "content" : "The largest flag in Ukraine -- all 200 meters (656 feet) of it -- was on display at Kiyvs Olympic stadium on Wednesday, with hundreds of people holding it up while singing the national anthem and othâ¦ [+3200 chars]",
      "title" : "The latest on the Ukraine-Russia border crisis: Live updates - cnn.com",
      "publishedAt" : "2022-02-16T12:22:00Z",
      "description" : "US President Biden called for a diplomatic solution to the Russia-Ukraine crisis in a White House speech this week and cautioned Russia against invading. Follow here for the latest news updates.",
      "url" : "https:www.cn.com"
    }
]
}
""".utf8



