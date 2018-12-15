//
//  NetworkServiceProtocol.swift
//  Project05
//
//  Created by 이혜진 on 2018. 9. 10..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import Foundation

// MARK: function for get and post network
protocol NetworkServiceProtocol {
    func request(_ url: String,
                 method: HTTPMethod,
                 parameters: HTTPBody?,
                 completion: @escaping (Result<Data>) -> Swift.Void)
}
