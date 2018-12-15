//
//  BoxOfficeListTableViewCell.swift
//  Project05
//
//  Created by 이혜진 on 2018. 8. 30..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import Foundation
import UIKit

//enum MovieGrade: Int {
//    case allages = 0
//    case age12 = 12
//    case age15 = 15
//    case age19 = 19
//}

// MARK: - BoxOfficeListTableViewCell
class BoxOfficeListTableViewCell: UITableViewCell {
    
    // MARK: properties
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieGradeImageView: UIImageView!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieRakingLabel: UILabel!
    @IBOutlet weak var movieAdvanceRateLabel: UILabel!
    @IBOutlet weak var movieReleaseDateLabel: UILabel!
    
    // MARK: prepare reuse cell
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.movieImageView.image = #imageLiteral(resourceName: "img_placeholder")
    }
    
    // MARK: cell configure
    public func configure(movie: Movie) {
        self.movieTitleLabel.text = movie.title
        self.movieRatingLabel.text = "평점: \(movie.userRating)"
        self.movieRakingLabel.text = "예매순위: \(movie.reservationGrade)"
        self.movieAdvanceRateLabel.text = "예매율: \(movie.reservationRate)"
        
        self.movieReleaseDateLabel.text = movie.date.dateToString("개봉일: yyyy년 MM월 dd일")
        
//        let imageName = movie.grade == MovieGrade.allages.rawValue ? "ic_allages" : "ic_\(movie.grade)"
//        self.movieGradeImageView.image = UIImage(named: imageName)
        self.movieGradeImageView.image = UIImage(named: movie.grade.imageName)
    }
    
    public func setImage(imgData: Data) {
        self.movieImageView.image = UIImage(data: imgData)
    }
}
