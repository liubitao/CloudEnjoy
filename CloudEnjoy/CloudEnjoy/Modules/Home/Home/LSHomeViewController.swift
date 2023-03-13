//
//  LSHomeViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/2.
//

import Foundation
import UIKit

class LSHomeViewController: LSBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        

    }
    
}
