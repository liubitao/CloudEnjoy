//
//  LSMessageViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/3.
//

import UIKit
import SwifterSwift

class LSMessageViewController: LSBaseViewController {
    var isEdit = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "消息中心"
    }
    
    override func setupNavigation() {
        let rightBarBtn = UIBarButtonItem(title: "管理", style: .plain, target: self, action: #selector(editMessage))
        rightBarBtn.setTitleTextAttributes([.foregroundColor: Color(hexString: "#333333")!], for: .normal)
        self.navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    
    
    
    
    
    
    
    @objc func editMessage() {
        self.isEdit = !self.isEdit
        let rightBarBtn = UIBarButtonItem(title: self.isEdit ? "取消" : "管理", style: .plain, target: self, action: #selector(editMessage))
        rightBarBtn.setTitleTextAttributes([.foregroundColor: Color(hexString: "#333333")!], for: .normal)
        self.navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    
    
    
    

}
