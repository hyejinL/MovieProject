//
//  NSObject+String.swift
//  Project05
//
//  Created by 이혜진 on 2018. 8. 30..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import Foundation

extension NSObject {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
