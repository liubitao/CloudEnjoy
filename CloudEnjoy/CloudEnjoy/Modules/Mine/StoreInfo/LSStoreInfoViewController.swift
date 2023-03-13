//
//  LSStoreInfoViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/9.
//

import UIKit
import LSBaseModules

class LSStoreInfoViewController: LSBaseViewController {

    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeAddress: UILabel!
    @IBOutlet weak var storekeeper: UILabel!
    @IBOutlet weak var storePhone: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "商家信息"
    }
    
    override func setupViews() {
        storeName.text = storeModel().name
        storeAddress.text = storeModel().linkaddr
        storekeeper.text = storeModel().linkman
        storePhone.text = storeModel().linkmobile
    }

}
