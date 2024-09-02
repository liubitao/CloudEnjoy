//
//  LSUserqueryViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/3.
//

import UIKit
import RxDataSources
import RxSwift
import SwifterSwift
import LSBaseModules
import SmartCodable

class LSUserqueryViewController: LSBaseViewController {

    @IBOutlet weak var keyTextField: UITextField!
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!

    @IBOutlet weak var headView: UIView!
    
    @IBOutlet weak var balanceLab: UILabel!
    @IBOutlet weak var integralLab: UILabel!
    @IBOutlet weak var vipNumberlab: UILabel!

    
    var tableView: UITableView!
    var refreshControl: KyoRefreshControl!
    
    var items = PublishSubject<[SectionModel<String, LSVipModel>]>()
    var models = [LSVipModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "会员查询"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vhl_navBarBackgroundAlpha = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.vhl_navBarBackgroundAlpha = 1
    }
    
    override func setupViews() {
        headerHeight.constant = 75 + UI.STATUS_NAV_BAR_HEIGHT
        
        self.headerImageView.image = UIImage.createGradientImage(startColor: Color(hexString: "#00AAB7")!, endColor: Color(hexString: "#00C294")!, width: UI.SCREEN_WIDTH, height: 75 + UI.STATUS_NAV_BAR_HEIGHT, isTopToBottom: false)

        self.headView.isHidden = true
        self.tableView = {
            var tableView = UITableView(frame: CGRect.zero, style: .grouped)
            if #available(iOS 13.0, *) {
                tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
            }
            tableView.backgroundColor = Color.clear
            tableView.tableFooterView = UIView()
            tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UI.SCREEN_WIDTH, height: 0.01))
            tableView.sectionHeaderHeight = 6
            tableView.sectionFooterHeight = 0
            tableView.rowHeight = 114
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
            tableView.register(nibWithCellClass: LSVipTableViewCell.self)
            view.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top:  75 + UI.STATUS_NAV_BAR_HEIGHT + 7 + 86 + 8, left: 0, bottom: 0, right: 0))
            }
            
            let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, LSVipModel>> { dataSource, tableView, indexPath, element in
                let cell: LSVipTableViewCell = tableView.dequeueReusableCell(withClass: LSVipTableViewCell.self)
                cell.numberLab.text = "NO.\(element.vipno)"
                let expireTime = element.validdate.isEmpty ? "永久" : element.validdate
                cell.expireLab.text =  "有效期：\(expireTime)"
                cell.nameLab.text = "会员姓名：\(element.name)"
                cell.integralLab.text = "会员积分：\(element.nowpoint.stringValue(retain: 2))"
                cell.balanceLab.text = "会员余额：\(element.nowmoney.stringValue(retain: 2))"
                cell.vipLab.text = element.typename
                return cell
            }
            items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
            
            tableView.rx.modelSelected(LSVipModel.self).subscribe(onNext: { [weak self] model in
                guard let self = self else {return}
                self.navigationController?.pushViewController(LSVipDetailsViewController(vipModel: model), animated: true)
            }).disposed(by: self.rx.disposeBag)
            return tableView
        }()
        
        self.refreshControl = {
            let refreshControl = KyoRefreshControl(scrollView: self.tableView, with: self)
            refreshControl?.kyoRefreshDoneRefreshOrLoadMore(true, withHadData: false, withError: nil)
            return refreshControl
        }()
    }
    
    func netwrokData(page: Int) {
        var networkError: Error? = nil
        LSWorkbenchServer.getVipList(page: page, cond: self.keyTextField.text ?? "").subscribe(onSuccess: { listModels in
            guard let listModels = listModels else{return}
            if page == 1 { self.models.removeAll() }
            self.refreshControl.numberOfPage = listModels.pages
            self.models.append(contentsOf: listModels.list)
            let sumModel: LSVipSumModel? = LSVipSumModel.deserialize(from: listModels.sumdata as? [String: Any])
            self.balanceLab.text = sumModel?.nowmoney.roundString(retain: 2) ?? "0"
            self.integralLab.text = sumModel?.nowpoint.roundString(retain: 2) ?? "0"
            self.vipNumberlab.text = listModels.total.string
            self.refreshUI()
        }, onFailure: { error in
            networkError = error
        }, onDisposed: {
            let hadData: Bool = !self.models.isEmpty
            self.headView.isHidden = !hadData
            self.refreshControl.kyoRefreshDoneRefreshOrLoadMore(page == 1 ? true : false,
                                                          withHadData: hadData,
                                                          withError: networkError)
        }).disposed(by: self.rx.disposeBag)
    }
    func refreshUI() {
        let sectionModels = self.models.map{SectionModel.init(model: "", items: [$0])}
        self.items.onNext(sectionModels)
    }
    
    
    @IBAction func searchAction(_ sender: Any) {
        guard let keyText = self.keyTextField.text,
              !keyText.isEmpty else {
            Toast.show("请输入会员卡号/手机号")
            return
        }
        self.keyTextField.resignFirstResponder()
        refreshControl?.kyoRefreshOperation(withDelay: 0, with: KyoManualRefreshType.center)
    }
}


extension LSUserqueryViewController: KyoRefreshControlDelegate{
    func kyoRefreshDidTriggerRefresh(_ refreshControl: KyoRefreshControl!) {
        netwrokData(page: 1)
    }
    
    func kyoRefreshLoadMore(_ refreshControl: KyoRefreshControl!, loadPage index: Int) {
        netwrokData(page: index + 1)
    }
    func kyoRefresh(_ refreshControl: KyoRefreshControl!, withNoDataShow kyoDataTipsView: KyoDataTipsView!, withCurrentKyoDataTipsModel kyoDataTipsModel: KyoDataTipsModel!, with kyoDataTipsViewType: KyoDataTipsViewType) -> KyoDataTipsModel! {
        kyoDataTipsModel.img = UIImage(named: "无信息")
        kyoDataTipsModel.tip = NSAttributedString(string: "未搜索到相关会员", attributes: [.foregroundColor: UIColor(hexString: "#999999")!, .font: Font.pingFangRegular(14)])
        return kyoDataTipsModel
    }
}
