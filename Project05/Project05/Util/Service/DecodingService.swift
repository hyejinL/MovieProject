//
//  DecodingService.swift
//  Project05
//
//  Created by 이혜진 on 2018. 8. 31..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import Foundation

protocol DecodingService {}

extension DecodingService {
    func decodeJSONData<T: Codable>(_ type: T.Type,
                                    dateformatter: JSONDecoder.DateDecodingStrategy,
                                    data: Data) -> Result<T> {
        let decoder = JSONDecoder()
        do {
            decoder.dateDecodingStrategy = dateformatter
            
            let decodeData = try decoder.decode(T.self, from: data)
            
            return .success(decodeData)
        } catch let err {
//            do {
//                let error = try decoder.decode(ErrorMessage.self, from: data)
//                print(error)
//                let msg = (error.error ?? "") + (error.message ?? "")
//                return .error("encode error : " + msg)
//
//            } catch let err {
                return .error(err.localizedDescription)
//            }
        }
    }
}
