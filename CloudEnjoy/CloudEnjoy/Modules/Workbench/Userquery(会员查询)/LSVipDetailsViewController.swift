//
//  LSVipDetailsViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/14.
//

import UIKit
import AttributedString
import SwifterSwift

class LSVipDetailsViewController: LSBaseViewController {

    @IBOutlet weak var vipNoLab: UILabel!
    
    @IBOutlet weak var vipTypeLab: UILabel!
    
    @IBOutlet weak var nameLab: UILabel!
    
    @IBOutlet weak var mobileLab: UILabel!
    
    @IBOutlet weak var sexLab: UILabel!
    
    @IBOutlet weak var balanceLab: UILabel!
    
    @IBOutlet weak var capitalmoneyLab: UILabel!
    
    @IBOutlet weak var givemoneyLab: UILabel!
    
    @IBOutlet weak var nowpointLab: UILabel!
    
    
    @IBOutlet weak var arrearagesLab: UILabel!
    
    @IBOutlet weak var viptypeLab: UILabel!
    
    
    @IBOutlet weak var rfcodeLab: UILabel!
    
    
    @IBOutlet weak var cardStatusLab: UILabel!
    
    @IBOutlet weak var publishCardLab: UILabel!
    
    @IBOutlet weak var publishCardTimeLab: UILabel!
    
    @IBOutlet weak var validDateLab: UILabel!
    
    @IBOutlet weak var birthdayLab: UILabel!
    
    
    @IBOutlet weak var writteFlagLab: UILabel!
    
    @IBOutlet weak var writteNamtLab: UILabel!
    
    @IBOutlet weak var remarkLab: UILabel!
    @IBOutlet weak var jscardidLab: UILabel!
    
    var vipModel: LSVipModel!
    convenience init(vipModel: LSVipModel) {
        self.init()
        self.vipModel = vipModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "会员详情"
    }
    
    
    override func setupViews() {
        self.vipNoLab.text = "NO.\(self.vipModel.vipno)"
        self.vipTypeLab.text = self.vipModel.typename
        self.nameLab.text = "会员姓名：\(self.vipModel.name)"
        self.sexLab.text = "会员性别：\(self.vipModel.sex == 0 ? "女": "男")"
        self.mobileLab.text = "手机号码：\(self.vipModel.mobile)"
        let a: ASAttributedString = "\("金额", .font(Font.pingFangRegular(13)), .foreground(Color(hexString: "#666666")!))"
        let b: ASAttributedString = "\("￥"+self.vipModel.nowmoney, .font(Font.pingFangRegular(18)), .foreground(Color(hexString:"#FF0000")!))"
        self.balanceLab.attributed.text = a + b
        
        self.capitalmoneyLab.attributed.text = "本金：￥\(self.vipModel.capitalmoney)"
        self.givemoneyLab.attributed.text = "本金：￥\(self.vipModel.givemoney)"
        
        let c: ASAttributedString = "\("积分 ", .font(Font.pingFangRegular(13)), .foreground(Color(hexString: "#666666")!))"
        let d: ASAttributedString = "\(self.vipModel.nowpoint, .font(Font.pingFangRegular(18)), .foreground(Color(hexString:"#000000")!))"
        self.nowpointLab.attributed.text = c + d
        
        let e: ASAttributedString = "\("欠款 ", .font(Font.pingFangRegular(13)), .foreground(Color(hexString: "#666666")!))"
        let f: ASAttributedString = "\(self.vipModel.arrearages, .font(Font.pingFangRegular(18)), .foreground(Color(hexString:"#000000")!))"
        self.arrearagesLab.attributed.text = e + f

        self.viptypeLab.text = self.vipModel.typename
        self.rfcodeLab.text = self.vipModel.rfcode
        self.cardStatusLab.text = self.vipModel.cardstatus.statusString
        self.publishCardLab.text = self.vipModel.bsid
        self.publishCardTimeLab.text = self.vipModel.createtime
        self.validDateLab.text = self.vipModel.validdate.isEmpty ? "永久" : self.vipModel.validdate
        self.birthdayLab.text = self.vipModel.birthday.components(separatedBy: " ").first?.slicing(from: 5, length: 5)
        self.writteFlagLab.text = self.vipModel.writtenflag ? "允许" : "不允许"
        self.writteNamtLab.isHidden = !self.vipModel.writtenflag
        self.writteNamtLab.text = "￥\(self.vipModel.writtenamt)"
        self.jscardidLab.text = self.vipModel.jscardname
        self.remarkLab.text = self.vipModel.remark
    }
}
