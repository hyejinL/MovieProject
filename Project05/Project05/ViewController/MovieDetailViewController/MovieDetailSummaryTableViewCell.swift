//
//  MovieDetailSummaryTableViewCell.swift
//  Project05
//
//  Created by 이혜진 on 2018. 9. 5..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import UIKit

// MARK: - MovieDetailSummaryTableViewCell
class MovieDetailSummaryTableViewCell: UITableViewCell {

    // MAKR: properties
    @IBOutlet weak var movieSummaryLabel: UILabel!
    
    // MARK: view init
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MAKR: cell configure
    public func configure(summary: String) {
        self.movieSummaryLabel.attributedText = summary.setSpacing()
    }
}
