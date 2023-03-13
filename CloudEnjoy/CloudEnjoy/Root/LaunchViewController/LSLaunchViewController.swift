//
//  LSLaunchViewController.swift
//  Haylou_Fun
//
//  Created by liubitao on 2022/11/26.
//     
//

import Foundation

class LSLaunchViewController: LSBaseViewController {
    typealias Closure = ()->()
    private var hide: Closure?
    
    convenience init(hide: Closure?){
        self.init()
        self.hide = hide
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0)) {
            self.hide?()
        }
    }
}
