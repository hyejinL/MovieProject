//
//  MovieService.swift
//  Project05
//
//  Created by 이혜진 on 2018. 8. 31..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import Foundation

enum OrderType: Int {
    case AdvanceRate = 0
    case Curation = 1
    case ReleaseDate = 2
    
    var title: String {
        switch self {
        case .AdvanceRate:
            return "예매율"
        case .Curation:
            return "큐레이션"
        case .ReleaseDate:
            return "개봉일"
        }
    }
}

struct MovieService: APIService, DecodingService {
    static let shared = MovieService()
    
    func getMovieList(_ orderType: OrderType, completion: @escaping (Result<Movies>) -> Swift.Void) {
        let URL = self.url("movies")
        
        let params = [
            "order_type" : orderType.rawValue
        ]
        
        NetworkService.shared.request(URL, parameters: params) { (result) in
            switch result {
            case .success(let data):
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "yyyy-MM-dd"
                
                completion(self.decodeJSONData(Movies.self,
                                               dateformatter: .formatted(dateformatter),
                                               data: data))
                
            case .error(let msg):
                completion(.error(msg))
            }
        }
    }
    
    func getDetailMovie(_ id: String, completion: @escaping (Result<Movie>) -> Swift.Void) {
        let URL = self.url("movie")
        
        let params = [
            "id" : id
        ]
        
        NetworkService.shared.request(URL, parameters: params) { (result) in
            switch result {
            case .success(let data):
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "yyyy-MM-dd"
                
                completion(self.decodeJSONData(Movie.self,
                                               dateformatter: .formatted(dateformatter),
                                               data: data))
                
            case .error(let msg):
                completion(.error(msg))
            }
        }
    }
    
    func getComments(_ id: String, completion: @escaping (Result<Comments>) -> Swift.Void) {
        let URL = self.url("comments")
        
        let params = [
            "movie_id" : id
        ]
        
        NetworkService.shared.request(URL, parameters: params) { (result) in
            switch result {
            case .success(let data):
                completion(self.decodeJSONData(Comments.self,
                                               dateformatter: .secondsSince1970,
                                               data: data))
                
            case .error(let msg):
                completion(.error(msg))
            }
        }
    }
    
    func sendComment(_ id: String,
                     rating: Double, writer: String, contents: String,
                     completion: @escaping (Result<(Comment)>) -> Swift.Void) {
        let URL = self.url("comment")
        
        let params: [String:Any] = [
            "rating" : rating,
            "writer" : writer,
            "movie_id" : id,
            "contents" : contents
        ]
        
        NetworkService.shared.request(URL, method: .POST, parameters: params) { (result) in
            switch result {
            case .success(let data):
                completion(self.decodeJSONData(Comment.self,
                                               dateformatter: .secondsSince1970,
                                               data: data))
                
            case .error(let msg):
                completion(.error(msg))
            }
        }
    }
}
