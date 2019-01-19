//
//  BoxOfficeListCollectionViewController.swift
//  Project05
//
//  Created by 이혜진 on 2018. 9. 6..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import UIKit

// MARK: - BoxOfficeListCollectionViewController
class BoxOfficeListCollectionViewController: UIViewController {

    // MARK: properties
    @IBOutlet weak var boxOfficeListCollectionView: UICollectionView!
    
    var movies: Movies?
    var orderType: OrderType = .AdvanceRate
    var queue = DispatchQueue(label: "com.hyejin.image.queue")
    let notificationCenter = NotificationCenter.default
    
    struct Style {
        static let ratio: CGFloat = UIScreen.main.bounds.width/375
        static let width: CGFloat = 177.0
        static let height: CGFloat = 306.0
        static let lineSpacing: CGFloat = 5.0
        static let itemSpacing: CGFloat = 5.0
        static let edgeInset: CGFloat = 7.0
    }
    
    // MARK: view init
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addObserver()
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.collectionViewInit()
        
        self.loading(.start)
        self.getMovies()
    }

    // MAKR: - action
    // MARK: button action
    @IBAction func pressedSettingButton(_ sender: Any) {
        let actions = [
            UIAlertAction(title: "예매율", style: .default,
                          handler: { [weak self] (_) in self?.changeOrderType(.AdvanceRate)}),
            UIAlertAction(title: "큐레이션", style: .default,
                          handler: { [weak self] (_) in self?.changeOrderType(.Curation)}),
            UIAlertAction(title: "개봉일", style: .default,
                          handler: { [weak self] (_) in self?.changeOrderType(.ReleaseDate)}),
            UIAlertAction(title: "취소", style: .cancel, handler: nil)
        ]
        
        self.addAlert(title: "정렬방식 선택",
                      message: "영화를 어떤 순서로 정렬할까요?",
                      actions: actions, completion: nil)
    }
    
    // MARK: init
    private func setupUI() {
        let indicator = UIRefreshControl()
        indicator.addTarget(self, action: #selector(refreshCollectionView(_:)), for: .valueChanged)
        self.boxOfficeListCollectionView.refreshControl = indicator
    }
    
    private func addObserver() {
        notificationCenter.addObserver(self,
                                 selector: #selector(didObserberAction(_:)),
                                 name: OrderTypeSignal.TableView.name,
                                 object: nil)
    }
    
    @objc private func refreshCollectionView(_ sender: UIRefreshControl) {
        self.getMovies()
        sender.endRefreshing()
    }
    
    @objc private func didObserberAction(_ notification: Notification) {
        guard let type = notification.userInfo?["orderType"] as? OrderType else { return }
        
        self.orderType = type
        self.getMovies()
    }
    
    private func changeOrderType(_ type: OrderType) {
        self.orderType = type
        
        let userInfo = [
            "orderType" : type
        ]
        notificationCenter.post(name: OrderTypeSignal.CollectionView.name,
                          object: self, userInfo: userInfo)
        
        self.getMovies()
    }
    
    // MARK: - network
    private func getMovies() {
        MovieService.shared.getMovieList(self.orderType) { [weak self] (result) in
            switch result {
            case .success(let movies):
                self?.loading(.end)
                
                self?.navigationItem.title = (self?.orderType.title ?? "") + "순"
                
                self?.movies = movies
                self?.boxOfficeListCollectionView?.reloadData()
            case .error(let msg):
                print("get movies error : " + msg)
                self?.loading(.end)
                self?.networkError(message: "get movies error : " + msg)
            }
        }
    }
}

// MARK: - collectionView delegate, dataSource
extension BoxOfficeListCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    private func collectionViewInit() {
        self.boxOfficeListCollectionView.delegate = self; self.boxOfficeListCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.movies.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoxOfficeListCollectionViewCell.reuseIdentifier, for: indexPath) as? BoxOfficeListCollectionViewCell else { return UICollectionViewCell() }
        
        guard let movie = movies?.movies[indexPath.row] else { return cell }
        cell.configure(movie: movie)
        
        queue.async {
            guard let imgURL: URL = URL(string: movie.thumb ?? ""),
                let imgData: Data = try? Data(contentsOf: imgURL)  else { return }
            
            DispatchQueue.main.async {
                cell.setImage(imgData: imgData)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: MovieDetailViewController.reuseIdentifier) as? MovieDetailViewController else { return }
        
        viewController.movieID = movies?.movies[indexPath.row].id
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - collectionView layout
extension BoxOfficeListCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Style.width*Style.ratio, height: Style.height*Style.ratio)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Style.lineSpacing*Style.ratio
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Style.itemSpacing*Style.ratio
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Style.edgeInset*Style.ratio, left: Style.edgeInset*Style.ratio,
                            bottom: Style.edgeInset*Style.ratio, right: Style.edgeInset*Style.ratio)
    }
}
