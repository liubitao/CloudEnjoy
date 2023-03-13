//
//  LSTextViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/8.
//

import Foundation

class LSTextViewController: LSBaseViewController {
    
    @IBOutlet weak var textView: UITextView!
     
    var titleName = ""
    var content = ""
    convenience init(titleName: String, content: String) {
        self.init()
        self.titleName = titleName
        self.content = content
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        self.title = titleName
        self.textView.text = content
    }
    
    override func setupNavigation() {
        self.addBackBarButtonItem()
    }
}
