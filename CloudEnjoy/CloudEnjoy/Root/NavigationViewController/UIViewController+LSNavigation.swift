//
//  UIViewController+LSNavigation.swift
//  Haylou_Fun
//
//  Created by liubitao on 2021/11/19.
//   
//

import Foundation
import UIKit

private var key: Any?

extension UIViewController {
    var viewControllerNameback: String {
        set {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            let obj = objc_getAssociatedObject(self, &key) as? String
            return obj ?? ""
        }
    }
    
    var isHiddenBackItem: Bool {
        set {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
        get {
            return false
        }
    }
}
