//
//  UIViewController+Alert.swift
//  Project05
//
//  Created by 이혜진 on 2018. 9. 5..
//  Copyright © 2018년 hyejin. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func addAlert(style: UIAlertControllerStyle = .actionSheet,
                        title: String,
                        message msg: String,
                        actions: [UIAlertAction],
                        completion: (()->Swift.Void)?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: style)
        
        for action in actions {
            alert.addAction(action)
        }
        
        self.present(alert, animated: true, completion: completion)
    }
    
    func networkError(message msg: String) {
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        self.addAlert(style: .alert,
                      title: "Error",
                      message: msg,
                      actions: [confirmAction],
                      completion: nil)
    }
}
