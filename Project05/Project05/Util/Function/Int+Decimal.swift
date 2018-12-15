//
//  Int+Decimal.swift
//  Project05
//
//  Created by 이혜진 on 2018. 9. 5..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import Foundation

extension Int {
    func getDecimalNumber() -> String? {
        let numberformatter = NumberFormatter()
        numberformatter.numberStyle = .decimal
        
        let number = NSNumber(value: self)
        return numberformatter.string(from: number)
    }
}
