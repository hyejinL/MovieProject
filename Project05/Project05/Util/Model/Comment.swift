//
//  Comment.swift
//  Project05
//
//  Created by 이혜진 on 2018. 8. 30..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import Foundation

struct Comment: Codable {
    let timestamp: Date?
    let id: String?
    let rating: Double
    let contents: String
    let movieID: String
    let writer: String
    
    enum CodingKeys: String, CodingKey {
        case timestamp, id, rating, contents
        case movieID = "movie_id"
        case writer
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.timestamp = try? container.decode(Date.self, forKey: .timestamp)
        self.id = try? container.decode(String.self, forKey: .id)
        self.rating = try container.decode(Double.self, forKey: .rating)

        if let value = try? container.decode(Int.self, forKey: .contents) {
            self.contents = String(value)
        } else {
            self.contents = try container.decode(String.self, forKey: .contents)
        }

        self.movieID = try container.decode(String.self, forKey: .movieID)

        if let value = try? container.decode(Int.self, forKey: .writer) {
            self.writer = String(value)
        } else {
            self.writer = try container.decode(String.self, forKey: .writer)
        }
    }
}
