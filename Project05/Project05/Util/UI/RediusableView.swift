//
//  RediusableView.swift
//  Project05
//
//  Created by 이혜진 on 2018. 9. 9..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import Foundation
import UIKit

protocol RediuseableView {
    var cornerRadius: CGFloat { get set }
    var borderWidth: CGFloat { get set }
    var borderColor: UIColor { get set }
}

@IBDesignable
extension UIView: RediuseableView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get { return self.layer.cornerRadius }
        set { self.layer.cornerRadius = newValue}
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get { return self.layer.borderWidth }
        set { self.layer.borderWidth = newValue }
    }
    
    @IBInspectable
    var borderColor: UIColor {
        get {
            guard let color = self.layer.borderColor else { return UIColor() }
            return UIColor(cgColor: color)
        }
        set { self.layer.borderColor = newValue.cgColor }
    }
}
