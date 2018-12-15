//
//  ErrorMessage.swift
//  Project05
//
//  Created by 이혜진 on 2018. 9. 10..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import Foundation

struct ErrorMessage: Codable {
    let error: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case error
        case message
    }
}
