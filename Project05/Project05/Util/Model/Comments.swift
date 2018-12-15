//
//  Comments.swift
//  Project05
//
//  Created by 이혜진 on 2018. 8. 30..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import Foundation

struct Comments: Codable {
    let movieID: String
    let comments: [Comment]
    
    enum CodingKeys: String, CodingKey {
        case movieID = "movie_id"
        case comments
    }
}
