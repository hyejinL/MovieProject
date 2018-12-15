//
//  Movie.swift
//  Project05
//
//  Created by 이혜진 on 2018. 8. 30..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import Foundation

// MARK: - MovieGrade : image name by grade
enum MovieGrade: Int, Codable {
    case allages = 0
    case age12 = 12
    case age15 = 15
    case age19 = 19
    
    var imageName: String {
        switch self {
        case .allages:
            return "ic_allages"
        default:
            return "ic_\(self.rawValue)"
        }
    }
}

// MAKR: - network json struct
struct Movie: Codable {
    let thumb: String?
    let userRating: Double
    let synopsis: String?
    let reservationGrade: Int
    let date: Date
    let grade: MovieGrade
    let reservationRate: Double
    let actor, genre, image: String?
    let audience: Int?
    let director: String?
    let id, title: String
    let duration: Int?
    
    enum CodingKeys: String, CodingKey {
        case thumb
        case userRating = "user_rating"
        case synopsis
        case reservationGrade = "reservation_grade"
        case date, grade
        case reservationRate = "reservation_rate"
        case actor, genre, id, image, audience, director, title, duration
    }
}
