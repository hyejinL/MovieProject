//
//  BoxOfficeListTableViewController.swift
//  Project05
//
//  Created by 이혜진 on 2018. 9. 6..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import UIKit

// MARK: - order type tab bar notification name
enum OrderTypeSignal: String {
    case TableView
    case CollectionView
    
    var name: Notification.Name {
        return NSNotification.Name("com.sendNOTI.ordertype." + self.rawValue)
    }
}

// MARK: - BoxOfficeListTableViewController
class BoxOfficeListTableViewController: UIViewController {
    
    // MARK: properties
    @IBOutlet weak var boxOfficeListTableView: UITableView!
    
    var movies: Movies?
    var orderType: OrderType = .AdvanceRate {
        didSet {
            self.getMovies()
        }
    }
    var queue = DispatchQueue(label: "com.hyejin.image.queue")
    let notificationCenter = NotificationCenter.default
    
    // MARK: view init
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addObserver()
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.initTableView()
        
        self.loading(.start)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getMovies()
    }
    
    // MARK: - action
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
    private func addObserver() {
        notificationCenter.addObserver(self,
                                 selector: #selector(didObserberAction(_:)),
                                 name: OrderTypeSignal.CollectionView.name,
                                 object: nil)
    }
    
    private func setupUI() {
        let indicator = UIRefreshControl()
        indicator.addTarget(self, action: #selector(refreshTableView(_:)), for: .valueChanged)
        self.boxOfficeListTableView.refreshControl = indicator
    }
    
    @objc private func refreshTableView(_ sender: UIRefreshControl) {
        self.getMovies()
        sender.endRefreshing()
    }
    
    @objc private func didObserberAction(_ notification: Notification) {
        guard let type = notification.userInfo?["orderType"] as? OrderType else { return }
        self.orderType = type
    }
    
    private func changeOrderType(_ type: OrderType) {
        self.orderType = type
        
        let userInfo = [
            "orderType" : type
        ]
        notificationCenter.post(name: OrderTypeSignal.TableView.name,
                          object: self, userInfo: userInfo)
    }
    
    // MARK: network
    private func getMovies() {
        MovieService.shared.getMovieList(self.orderType) { [weak self] (result) in
            switch result {
            case .success(let movies):
                self?.loading(.end)
                
                self?.navigationItem.title = (self?.orderType.title ?? "") + "순"
                
                self?.movies = movies
                self?.boxOfficeListTableView?.reloadData()
            case .error(let msg):
                print("get movies error : " + msg)
                self?.loading(.end)
                self?.networkError(message: "get movies error : " + msg)
            }
        }
    }
}

// MARK: - tableView delegate, dataSource
extension BoxOfficeListTableViewController: UITableViewDelegate, UITableViewDataSource {
    private func initTableView() {
        self.boxOfficeListTableView.delegate = self; self.boxOfficeListTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.movies.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BoxOfficeListTableViewCell.reuseIdentifier) as? BoxOfficeListTableViewCell else { return UITableViewCell() }
        
        guard let movie = movies?.movies[indexPath.row] else { return cell }
        cell.configure(movie: movie)
        
        queue.async {
            guard let imgURL: URL = URL(string: movie.thumb ?? ""),
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: MovieDetailViewController.reuseIdentifier) as? MovieDetailViewController else { return }
        
        viewController.movieID = movies?.movies[indexPath.row].id
        
        self.navigationController?.pushViewController(viewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
