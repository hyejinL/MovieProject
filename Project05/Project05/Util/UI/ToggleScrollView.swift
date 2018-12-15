//
//  ToggleScrollView.swift
//  Project05
//
//  Created by 이혜진 on 2018. 9. 12..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import Foundation
import UIKit

protocol ToggleScrollViewDelegate: UIScrollViewDelegate {
    func touchedToggleScrollView(_ view: ToggleScrollView)
}

class ToggleScrollView: UIScrollView {
    
    weak var tDelegate: ToggleScrollViewDelegate?
    
    var isSelected: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchedScrollView(_:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc func touchedScrollView(_ gesture: UITapGestureRecognizer) {
        self.isSelected = !self.isSelected
        guard let action = tDelegate?.touchedToggleScrollView else { return }
        if let scrollview = gesture.view as? ToggleScrollView {
            action(scrollview)
        }
    }
}
