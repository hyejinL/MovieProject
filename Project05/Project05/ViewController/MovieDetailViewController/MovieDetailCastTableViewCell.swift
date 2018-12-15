//
//  MovieDetailCastTableViewCell.swift
//  Project05
//
//  Created by 이혜진 on 2018. 9. 5..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import UIKit

// MARK: - MovieDetailCastTableViewCell
class MovieDetailCastTableViewCell: UITableViewCell {

    // MAKR: properties
    @IBOutlet weak var movieDirectorLabel: UILabel!
    @IBOutlet weak var movieActorLabel: UILabel!
    
    // MARK: view init
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: configure
    public func configure(director: String, actor: String) {
        self.movieDirectorLabel.text = director
        self.movieActorLabel.text = actor
    }
}
