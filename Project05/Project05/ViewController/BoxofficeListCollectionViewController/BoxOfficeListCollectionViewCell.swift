//
//  BoxOfficeListCollectionViewCell.swift
//  Project05
//
//  Created by 이혜진 on 2018. 9. 6..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import UIKit

// MARK: - BoxOfficeListCollectionViewCell
class BoxOfficeListCollectionViewCell: UICollectionViewCell {
    
    // MARK: properties
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieGradeImageView: UIImageView!
    @IBOutlet weak var movieRakingAndRateLabel: UILabel!
    @IBOutlet weak var movieReleaseDateLabel: UILabel!
    
    // MAKR: prepare reuse cell
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.movieImageView.image = #imageLiteral(resourceName: "img_placeholder")
    }
    
    // MAKR: cell configure
    public func configure(movie: Movie) {
        self.movieTitleLabel.text = movie.title
        
        let ranking = "\(movie.reservationGrade)위 "
        let rating = "(\(movie.userRating))"
        let advanceRate = "\(movie.reservationRate)%"
        self.movieRakingAndRateLabel.text = ranking + rating + " / " + advanceRate
        
        self.movieReleaseDateLabel.text = movie.date.dateToString("yyyy년 MM월 dd일")
        
        self.movieGradeImageView.image = UIImage(named: movie.grade.imageName)
    }
    
    public func setImage(imgData: Data) {
        self.movieImageView.image = UIImage(data: imgData)
    }
}
