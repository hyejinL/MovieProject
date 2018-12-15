//
//  Movies.swift
//  Project05
//
//  Created by 이혜진 on 2018. 8. 30..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import Foundation

struct Movies: Codable {
    let movies: [Movie]
    let orderType: Int
    
    enum CodingKeys: String, CodingKey {
        case movies
        case orderType = "order_type"
    }
}
