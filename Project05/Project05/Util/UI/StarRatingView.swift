//
//  StarRatingView.swift
//  Project05
//
//  Created by 이혜진 on 2018. 9. 19..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import Foundation
import UIKit

// https://github.com/magi82/MGStarRatingView
// https://github.com/evgenyneu/Cosmos

// MARK: - rating mode
enum RatingFillType: Int {
    case full
    case half
    case precise
}

// MAKR: - delegate
protocol StarRatingDelegate: class {
    func starRatingValueChanged(_ view: StarRatingView, rating: CGFloat)
}

// MARK: - star rating view
class StarRatingView: UIView {
    // MARK: - properties
    weak var delegate: StarRatingDelegate?
    
    private var type: RatingFillType = .full
    
    // MARK: ibinspectable
    @IBInspectable
    public var ratingMode: Int {
        get { return self.type.rawValue }
        set { self.type = RatingFillType(rawValue: newValue) ?? .full }
    }
    
    @IBInspectable
    public var rating: CGFloat = 0 {
        didSet {
            self.ratingWidth = rateToWidth(self.rating)
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var minRating: CGFloat = 0 {
        didSet {
            self.rating = self.rating < self.minRating ? self.minRating : self.rating
            self.minWidth = self.rateToWidth(self.minRating)
        }
    }
    @IBInspectable
    public var totalStars: CGFloat = 5
    
    @IBInspectable
    public var spacing: CGFloat = 0
    @IBInspectable
    public var starPoint: CGFloat = 20
    
    @IBInspectable
    public var emptyImage: UIImage?
    @IBInspectable
    public var fillImage: UIImage?
    
    // MARK: private properties
    private var minWidth: CGFloat = 0
    private var maxWidth: CGFloat = 0
    
    private var ratingWidth: CGFloat = 0
    private var emptyStar: UIImage?
    private var fillStar: UIImage?
    
    override var intrinsicContentSize: CGSize {
        let count: CGFloat = self.totalStars
        
        var width = self.starPoint * count
        width += self.spacing * (count - 1)
        return CGSize(width: width, height: self.starPoint)
    }
    
    // MARK: view init
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
    
    private func setupUI() {
        self.ratingWidth = self.rateToWidth(self.rating)
        self.maxWidth = self.rateToWidth(self.totalStars)
        
        self.backgroundColor = .clear
        
        guard let emptyImage = self.emptyImage,
            let fillImage = self.fillImage else { return }
        self.emptyStar = self.createImage(self.starPoint,
                                          spacing: self.spacing,
                                          image: emptyImage)
        self.fillStar = self.createImage(self.starPoint,
                                         spacing: self.spacing,
                                         image: fillImage)
    }
    
    // MARK: - action
    private func rateToWidth(_ rate: CGFloat) -> CGFloat {
        return (self.starPoint * rate) + (CGFloat(Int(rate)) * self.spacing)
    }
    
    private func createStar(_ size: CGFloat, image: UIImage) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size, height: size),
                                               false, 0)
        image.draw(in: CGRect(x: 0, y: 0, width: size, height: size))
        
        let star = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return star
    }
    
    private func createImage(_ size: CGFloat, spacing: CGFloat, image: UIImage) -> UIImage? {
        guard let starImage = self.createStar(size, image: image) else { return nil }
        
        var size = starImage.size
        size.width += self.spacing
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        starImage.draw(at: CGPoint(x: 0, y: 0))
        
        let star = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return star
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let emptyStar = self.emptyStar else { return }
        emptyStar.drawAsPattern(in: CGRect(x: 0, y: 0, width: self.maxWidth, height: self.starPoint))
        
        if self.rating > 0 {
            guard let fillStar = self.fillStar else { return }
            fillStar.drawAsPattern(in: CGRect(x: 0, y: 0, width: self.ratingWidth, height: self.starPoint))
        }
    }

    private func update(_ location: CGPoint) {
        var width = location.x < 0 ? 0 : location.x
        width = width < self.minWidth ? self.minWidth : width
        width = width > self.maxWidth ? self.maxWidth : width
        
        var count: CGFloat = 0
        
        switch type {
        case .precise:
            self.touchStarsAndGetRating(current: &count, touchX: &width)
            
            self.rating = count
            
        case .half:
            self.touchStarsAndGetRating(current: &count, touchX: &width)
            
            self.rating = floor(count)
            
            let remainder = count - self.rating
            if remainder > 0.5 {
                self.rating += 1
            } else if remainder > 0 {
                self.rating += 0.5
            }
            
        case .full:
            self.touchStarsAndGetRating(current: &count, touchX: &width)
            
            self.rating = ceil(count)
        }
        self.ratingWidth = self.rateToWidth(self.rating)
    }
    
    private func touchStarsAndGetRating(current star: inout CGFloat,
                                        touchX width: inout CGFloat) {
        while width > 0 {
            if width >= self.starPoint {
                star += 1
            } else {
                star += width / self.starPoint
            }
            width -= self.starPoint + self.spacing
        }
    }

    // MARK: touch event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let location = touches.first?.location(in: self) {
            self.update(location)
            setNeedsDisplay()
            
            if let view = touches.first?.view as? StarRatingView {
                guard let action = delegate?.starRatingValueChanged else { return }
                action(view, view.rating)
            }
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        if let location = touches.first?.location(in: self) {
            self.update(location)
            setNeedsDisplay()
            
            if let view = touches.first?.view as? StarRatingView {
                guard let action = delegate?.starRatingValueChanged else { return }
                action(view, view.rating)
            }
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if let location = touches.first?.location(in: self) {
            self.update(location)
            setNeedsDisplay()
        }
    }
}
