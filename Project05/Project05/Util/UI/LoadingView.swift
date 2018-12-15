//
//  LoadingView.swift
//  Project05
//
//  Created by 이혜진 on 2018. 9. 10..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import Foundation
import UIKit

class LoadingView: UIView {
    static let shared = LoadingView()
    
    private var indicatorView: UIView = UIView()
    
    public var indicatorViewColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)
    public var indicatorViewSize: CGSize = CGSize(width: 60.0, height: 60.0)
    public var indicatorViewCornerRadius: CGFloat = 5.0
    
    private let indicator = UIActivityIndicatorView()
    
    var isAnimating: Bool = false {
        didSet {
            switch self.isAnimating {
            case true:
                self.indicator.startAnimating()
                self.isHidden = false
                
            case false:
                self.indicator.stopAnimating()
                self.isHidden = true
//                self.removeFromSuperview()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
    
    private func setupUI() {
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.clear
        self.isHidden = true
        
        self.indicatorView.layer.backgroundColor = self.indicatorViewColor.cgColor
        self.indicatorView.layer.frame.size = self.indicatorViewSize
        self.indicatorView.cornerRadius = self.indicatorViewCornerRadius
        
        self.indicatorView.center = self.center
        
        let centerXY: CGFloat = self.indicatorViewSize.width/2
        self.indicator.center = CGPoint(x: centerXY, y: centerXY)
        self.indicatorView.addSubview(self.indicator)
        
        self.addSubview(self.indicatorView)
        
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        keyWindow.addSubview(self)
    }
}
