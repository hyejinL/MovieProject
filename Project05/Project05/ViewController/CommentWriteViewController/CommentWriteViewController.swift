//
//  CommentWriteViewController.swift
//  Project05
//
//  Created by 이혜진 on 2018. 9. 9..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import UIKit

// MAKR: - CommentWriteViewController
class CommentWriteViewController: UIViewController {

    // MAKR: properties
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieGradeImageView: UIImageView!
    @IBOutlet weak var commentRatingView: StarRatingView!
    @IBOutlet weak var commentCurrentRatingLabel: UILabel!
    @IBOutlet weak var commentWriterTextField: UITextField!
    @IBOutlet weak var commentContentsTextView: UITextView!
    
    struct Style {
        static let commentCornerRadius: CGFloat = 5.0
        static let commentBorderWidth: CGFloat = 1.0
        static let commentBorderColor: UIColor = #colorLiteral(red: 0.3137254902, green: 0.431372549, blue: 0.7843137255, alpha: 1)
    }
    
    var movieID: String?
    var movieTitle: String?
    var movieGrade: MovieGrade?
    
    let userdefault = UserDefaults.standard
    let nickName = "nickName"
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.starRatingInit()
    }
    
    // MAKR: - action
    // MAKR: button action
    @IBAction func pressedSendCommentButton(_ sender: Any) {
        self.sendComment()
    }
    
    @IBAction func pressedDismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: init
    private func setupUI() {
        self.commentContentsTextView.cornerRadius = Style.commentCornerRadius
        self.commentContentsTextView.borderWidth = Style.commentBorderWidth
        self.commentContentsTextView.borderColor = Style.commentBorderColor
        
        self.movieTitleLabel.text = self.movieTitle
        self.movieGradeImageView.image = UIImage(named: self.movieGrade?.imageName ?? "")
        
        let rating = self.commentRatingView.rating * 2
        self.commentCurrentRatingLabel.text = "\(Int(rating))"
        
        self.commentWriterTextField.text = userdefault.string(forKey: nickName) ?? ""
    }
    
    // MARK: network
    private func sendComment() {
        self.addSendCommentError {
            guard let id = self.movieID,
                let writer = self.commentWriterTextField.text,
                let contents = self.commentContentsTextView.text else { return }
            
            let rating = Double(self.commentRatingView.rating) * 2
            
            MovieService.shared.sendComment(id,
                                            rating: rating,
                                            writer: writer,
                                            contents: contents) { [weak self] (result) in
                                                guard let `self` = self else { return }
                                                
                                                switch result {
                                                case .success(_):
                                                    print("success")
                                                    self.userdefault.set(self.commentWriterTextField.text ?? "", forKey: self.nickName)
                                                    self.loading(.end)
                                                    self.dismiss(animated: true, completion: nil)
                                                    
                                                case .error(let msg):
                                                    print("send comment error : " + msg)
                                                    self.loading(.end)
                                                    self.networkError(message: "send comment error : " + msg)
                                                }
            }
        }
    }
    
    private func addSendCommentError(completion: () -> Swift.Void) {
        if self.commentWriterTextField.text?.isEmpty ?? true ||
            self.commentContentsTextView.text.isEmpty {
            let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            
            self.addAlert(style: .alert,
                          title: "댓글전송 에러",
                          message: "모든 항목을 채워주세요 :(",
                          actions: [confirmAction], completion: nil)
        } else {
            self.loading(.start)
            completion()
        }
    }
    
}

extension CommentWriteViewController: StarRatingDelegate {
    private func starRatingInit() {
        self.commentRatingView.delegate = self
    }
    
    func starRatingValueChanged(_ view: StarRatingView, rating: CGFloat) {
        self.commentCurrentRatingLabel.text = "\(Int(rating * 2))"
    }
}
