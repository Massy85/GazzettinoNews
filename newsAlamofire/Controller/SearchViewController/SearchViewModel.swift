//
//  SearchViewModel.swift
//  newsAlamofire
//
//  Created by Massimiliano Bonafede on 16/02/22.
//  Copyright © 2022 Massimiliano Bonafede. All rights reserved.
//

import Foundation

class SearchViewModel {
    
    private(set) var index: Int = 0
    
    func setIndexAt(_ index: Int) {
        self.index = index
    }
    
    private(set) var cities = Cities.allCases.sorted(by: { $0.rawValue < $1.rawValue })
    
    func getCityNameAtIndex(_ index: Int) -> String { cities[index].rawValue }
    
    func getInitial() -> String { cities[index].initial }
    
    func getCityName() -> String { cities[index].rawValue }
}
