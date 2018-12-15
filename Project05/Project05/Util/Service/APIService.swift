//
//  APIService.swift
//  Project05
//
//  Created by 이혜진 on 2018. 8. 30..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import Foundation

// MAKR: - network result type
enum Result<T> {
    case success(T)
    case error(String)
}

// MAKR: - APIService : protocol for api
let baseURL: String = "http://connect-boxoffice.run.goorm.io/"

protocol APIService {}

extension APIService {
    func url(_ path: String) -> String {
        return baseURL + path
    }
}
