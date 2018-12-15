//
//  MovieDetailCommentTableViewCell.swift
//  Project05
//
//  Created by 이혜진 on 2018. 9. 5..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import UIKit

// MAKR: - MovieDetailCommentTableViewCell
class MovieDetailCommentTableViewCell: UITableViewCell {

    // MAKR: properties
    @IBOutlet weak var commentWriterImageView: UIImageView!
    @IBOutlet weak var commentNicknameLabel: UILabel!
    @IBOutlet weak var commentRatingView: StarRatingView!
    @IBOutlet weak var commentDateLabel: UILabel!
    @IBOutlet weak var commentContentsLabel: UILabel!
    
    // MARK: view init
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.commentWriterImageView.cornerRadius = self.commentWriterImageView.layer.frame.width/2
    }

    // MAKR: cell configure
    public func configure(comment: Comment) {
        self.commentNicknameLabel.text = comment.writer
        self.commentRatingView.rating = CGFloat(comment.rating / 2)
        self.commentDateLabel.text = comment.timestamp?.dateToString("yyyy년 MM월 dd일 작성")
        self.commentContentsLabel.text = comment.contents
    }
    
    public func setImage(imgData: Data) {
        self.commentWriterImageView.image = UIImage(data: imgData)
    }
}
