//
//  PhotoViewController.swift
//  Project05
//
//  Created by 이혜진 on 2018. 9. 12..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    // MARK: - properties
    @IBOutlet weak var zoomScrollView: ToggleScrollView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    var imageURL: String?
    var queue = DispatchQueue(label: "com.hyejin.image.queue")
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollViewInit()
        
        self.setupUI()
    }
    
    // MARK: - device landscape action
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
//        if UIDevice.current.orientation != .portrait {
//        }
        self.zoomScrollView.setZoomScale(1.0, animated: true)
        self.zoomScrollView.isSelected = false
        touchedToggleScrollView(self.zoomScrollView)
    }
    
    // MARK: - action
    // MARK: init
    private func setupUI() {
        queue.async {
            guard let imgURL: URL = URL(string: self.imageURL ?? ""),
                let imgData: Data = try? Data(contentsOf: imgURL)  else { return }
            
            DispatchQueue.main.async {
                self.photoImageView.image = UIImage(data: imgData)
            }
        }
    }
}

// MARK: - toggle scrollview delegate
extension PhotoViewController: ToggleScrollViewDelegate {
    private func scrollViewInit() {
        self.zoomScrollView.tDelegate = self
        self.zoomScrollView.delegate = self
        
        self.zoomScrollView.minimumZoomScale = 1.0
        self.zoomScrollView.maximumZoomScale = 3.0
    }
    
    // 사진 확대시 이미지가 아닌 부분은 스크롤이 되지 않게 함
    // https://stackoverflow.com/questions/39460256/uiscrollview-zooming-contentinset
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            
            if let image = photoImageView.image {
                
                let ratioW = photoImageView.frame.width / image.size.width
                let ratioH = photoImageView.frame.height / image.size.height
                
                let ratio = ratioW<ratioH ? ratioW : ratioH
                
                let newWidth = image.size.width*ratio
                let newHeight = image.size.height*ratio
                
                let left = 0.5 * (newWidth * scrollView.zoomScale > photoImageView.frame.width ? (newWidth - photoImageView.frame.width) : (scrollView.frame.width - scrollView.contentSize.width))
                let top = 0.5 * (newHeight * scrollView.zoomScale > photoImageView.frame.height ? (newHeight - photoImageView.frame.height) : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsetsMake(top, left, top, left)
            }
        } else {
            scrollView.contentInset = .zero
        }
        
        self.zoomScrollView.isSelected = true
        touchedToggleScrollView(self.zoomScrollView)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoImageView
    }
    
    func touchedToggleScrollView(_ view: ToggleScrollView) {
        switch view.isSelected {
        case true:
            UIView.animate(withDuration: 0.15, animations: {
                self.navigationController?.navigationBar.alpha = 0
                self.toolbar.alpha = 0
                self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            })
        case false:
            UIView.animate(withDuration: 0.15, animations: {
                self.navigationController?.navigationBar.alpha = 1
                self.toolbar.alpha = 1
                self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            })
        }
    }
}

