//
//  GetNewsFromJSON.swift
//  newsAlamofire
//
//  Created by Massimiliano on 11/03/2020.
//  Copyright © 2020 Massimiliano Bonafede. All rights reserved.
//

import UIKit
//import Alamofire
//import SwiftyJSON


protocol FetchedNewDidSuccessfullyDelegate: class {
    func retriveNews(_ news: [News])
    func retriveNewsDidFail(_ error: String)
}


class GetNewsFromJSON {
    
    var delegate: FetchedNewDidSuccessfullyDelegate?
    
    func retriveNewsFromServer(_ city: String) {
        let APP_ID = "d1100591b9054c3da2fef23e4c9a2a15"
        let MY_URL = "https://newsapi.org/v2/top-headlines?country="
        let params : [String : String] = ["apiKey" : APP_ID]
        
        
        let url = MY_URL + city
        
//        AF.request(url, method: .get, parameters: params).responseJSON { [weak self] response in
//
//            guard let self = self else { return }
//
//            switch response.result {
//            case .success(let value):
//                let json = JSON(arrayLiteral: value)
//                let news = self.updateNewsData(json: json)
//                self.delegate?.retriveNews(news)
//
//            case .failure(let error):
//                self.delegate?.retriveNewsDidFail(error.localizedDescription)
//            }
//        }
    }

//    private func updateNewsData(json : JSON) -> [News] {
//
//        var newsContainer: [News] = []
//        let articles = json[0]["articles"].count
//
//        for i in 0 ... articles - 1 {
//            let image = json[0]["articles"][i]["urlToImage"].stringValue
//            let title = json[0]["articles"][i]["title"].stringValue
//            let url = json[0]["articles"][i]["url"].stringValue
//            let auth = json[0]["articles"][i]["source"]["name"].stringValue
//            // let link = json[0]["articles"][i]["url"]
//            let news = News(author: auth, title: title, url: url, urlImage: image)
//            newsContainer.append(news)
//        }
//        return newsContainer
//    }
}









