//
//  String+Spacing.swift
//  Project05
//
//  Created by 이혜진 on 2018. 9. 5..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func setSpacing() -> NSMutableAttributedString {
        let attrString = NSMutableAttributedString(string: self)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        style.minimumLineHeight = 3
        style.alignment = .center
        
        // Line spacing attribute
        attrString.addAttribute(NSAttributedStringKey.paragraphStyle,
                                value: style,
                                range: NSRange(location: 0, length: self.count))
        
        // Character spacing attribute
        attrString.addAttribute(NSAttributedStringKey.kern,
                                value: 1,
                                range: NSMakeRange(0, attrString.length))
        
        return attrString
    }
}
