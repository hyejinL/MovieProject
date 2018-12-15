//
//  MovieDetailInfoTableViewCell.swift
//  Project05
//
//  Created by 이혜진 on 2018. 9. 5..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import UIKit

// MARK: - MovieDetailInfoTableViewCell
class MovieDetailInfoTableViewCell: UITableViewCell {
    
    // MAKR: properties
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieGradeImageView: UIImageView!
    @IBOutlet weak var movieDateLabel: UILabel!
    @IBOutlet weak var movieGenreAndTimeLabel: UILabel!
    @IBOutlet weak var movieAdvanceRateLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieRatingView: StarRatingView!
    @IBOutlet weak var movieAudienceLabel: UILabel!
    
    // MARK: view init
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: cell configure
    public func configure(movie: Movie) {
        self.movieTitleLabel.text = movie.title
        self.movieDateLabel.text = movie.date.dateToString("yyyy년 MM월 dd일 개봉")
        self.movieGenreAndTimeLabel.text = "\(movie.genre ?? "") / \(movie.duration ?? 0)분"
        self.movieAdvanceRateLabel.text = "\(movie.reservationGrade)위 \(movie.reservationRate)%"
        self.movieRatingLabel.text = "\(movie.userRating)"
        self.movieRatingView.rating = CGFloat(movie.userRating / 2)
        self.movieAudienceLabel.text = movie.audience?.getDecimalNumber()
        
        self.movieGradeImageView.image = UIImage(named: movie.grade.imageName)
    }
    
    public func setImage(imgData: Data) {
        self.movieImageView.image = UIImage(data: imgData)
    }
}
