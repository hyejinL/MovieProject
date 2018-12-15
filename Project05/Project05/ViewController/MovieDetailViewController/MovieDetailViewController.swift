//
//  MovieDetailViewController.swift
//  Project05
//
//  Created by 이혜진 on 2018. 9. 5..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import Foundation
import UIKit

// MARK: - MovieDetailViewController
class MovieDetailViewController: UIViewController {
    
    // MARK: properties
    @IBOutlet weak var movieDetailTableView: UITableView!
    @IBOutlet var movieCommentHeaderView: UIView!
    
    let headerHeight: CGFloat = 48.0
    let goWriteCommentViewIdentifier: String =  "goWriteCommentView"
    
    var movieID: String?
    var movie: Movie?
    var comments: Comments?
    var queue = DispatchQueue(label: "com.hyejin.image.queue")
    
    var getMovieCheck: Bool = false
    var getCommentCheck: Bool = false
    
    // MAKR: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableviewInit()
        
        self.getMovie()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loading(.start)
        self.getComments()
    }
    
    // MARK: - action
    @IBAction func pressedMovieImageView(_ sender: Any) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: PhotoViewController.reuseIdentifier) as? PhotoViewController else { return }
        viewController.imageURL = self.movie?.image
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.goWriteCommentViewIdentifier {
            guard let navi = segue.destination as? UINavigationController,
                let viewController = navi.viewControllers.first as? CommentWriteViewController else { return }
            viewController.movieID = self.movieID
            viewController.movieTitle = self.movie?.title
            viewController.movieGrade = self.movie?.grade
        }
    }
    
    // MARK: - network
    private func getMovie() {
        self.getMovieCheck = false
        
        MovieService.shared.getDetailMovie(movieID ?? "") { [weak self] (result) in
            switch result {
            case .success(let movie):
                self?.getMovieCheck = true
                self?.getAllDataLoadingEnd()
                
                self?.movie = movie
                self?.title = movie.title
//                self?.movieDetailTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                self?.movieDetailTableView.reloadData()
                
            case .error(let msg):
                print("get movie error : " + msg)
                self?.loading(.end)
                self?.networkError(message: "get movie error : " + msg)
            }
        }
    }
    
    private func getComments() {
        self.getCommentCheck = false
        
        MovieService.shared.getComments(movieID ?? "") { [weak self] (result) in
            switch result {
            case .success(let comments):
                self?.getCommentCheck = true
                self?.getAllDataLoadingEnd()
                
                self?.comments = comments
                
                self?.movieDetailTableView.reloadSections(IndexSet(integer: 1), with: .automatic)
//                self?.movieDetailTableView.reloadData()
                
            case .error(let msg):
                print("get comments error : " + msg)
                self?.loading(.end)
                self?.networkError(message: "get comments error : " + msg)
            }
        }
    }
    
    private func getAllDataLoadingEnd() {
        if self.getMovieCheck && self.getCommentCheck {
            self.loading(.end)
        }
    }
}

// MARK: - tableView delegate, dataSource
extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    private func tableviewInit() {
        self.movieDetailTableView.delegate = self; self.movieDetailTableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            return self.movieCommentHeaderView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return headerHeight
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        return comments?.comments.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let movie = movie else { return UITableViewCell() }
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailInfoTableViewCell.reuseIdentifier) as? MovieDetailInfoTableViewCell else { return UITableViewCell() }
                
                cell.configure(movie: movie)
                
                queue.async {
                    guard let imgURL: URL = URL(string: movie.image ?? ""),
                        let imgData: Data = try? Data(contentsOf: imgURL)  else { return }
                    
                    DispatchQueue.main.async {
                        if let index: IndexPath = tableView.indexPath(for: cell) {
                            if index.row == indexPath.row {
                                cell.setImage(imgData: imgData)
                            }
                        }
                    }
                }
                
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailSummaryTableViewCell.reuseIdentifier) as? MovieDetailSummaryTableViewCell else { return UITableViewCell() }
                
                cell.configure(summary: movie.synopsis ?? "")
                
                return cell
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailCastTableViewCell.reuseIdentifier) as? MovieDetailCastTableViewCell else { return UITableViewCell() }
                
                cell.configure(director: movie.director ?? "",
                               actor: movie.actor ?? "")
                
                return cell
                
            default:
                break
            }
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailCommentTableViewCell.reuseIdentifier) as? MovieDetailCommentTableViewCell else { return UITableViewCell() }
        
        guard let comment = comments?.comments[indexPath.row] else { return UITableViewCell() }
        cell.configure(comment: comment)
        
        return cell
    }
}
