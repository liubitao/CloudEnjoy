//
//  LSRoyaltiesDetailsController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/10.
//

import UIKit
import RxDataSources
import RxSwift
import SwifterSwift
class LSRoyaltiesDetailsController: LSBaseViewController {
    var tableView: UITableView!
    @IBOutlet weak var listNumberLab: UILabel!
    @IBOutlet weak var totalRoyaltiesLab: UILabel!
    
    var refreshControl: KyoRefreshControl!
    
    var selecttype: Int!
    var startdate: String!
    var enddate: String!
    var count: String!
    var commission: String!
    
    var items = PublishSubject<[SectionModel<String, LSRoyaltiesDetailsModel>]>()
    var models = [LSRoyaltiesDetailsModel]()
    
    convenience init(selecttype: Int, startdate: String, enddate: String, count: String, commission: String) {
        self.init()
        self.selecttype = selecttype
        self.startdate = startdate
        self.enddate = enddate
        self.count = count
        self.commission = commission
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "提成详情"
    }

    override func setupViews() {
        self.tableView = {
            var tableView = UITableView(frame: CGRect.zero, style: .grouped)
            if #available(iOS 13.0, *) {
                tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
            }
            tableView.backgroundColor = Color.clear
            tableView.tableFooterView = UIView()
            tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UI.SCREEN_WIDTH, height: 0.01))
            tableView.sectionHeaderHeight = 5
            tableView.sectionFooterHeight = 0
            tableView.rowHeight = 100
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
            tableView.register(nibWithCellClass: LSRoyaltiesDetailsCell.self)
            view.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview().offset(-45)
                make.top.equalToSuperview().offset(UI.STATUS_NAV_BAR_HEIGHT + 5)
            }
            
            let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, LSRoyaltiesDetailsModel>> { dataSource, tableView, indexPath, element in
                let cell: LSRoyaltiesDetailsCell = tableView.dequeueReusableCell(withClass: LSRoyaltiesDetailsCell.self)
                cell.projectNameLab.text = element.projectname
                cell.commissionLab.text = "￥\(element.commission)"
                cell.roomNameLab.text = "房间：\(element.roomname)"
                cell.projectTypeLab.text = "类型：\(element.ctypename)"
                cell.amtLab.text = "金额：￥\(element.amt)"
                cell.timeLab.text = "时间：\(element.createtime)"
                return cell
            }
            items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
            return tableView
        }()
        
        self.refreshControl = {
            let refreshControl = KyoRefreshControl(scrollView: self.tableView, with: self)
            refreshControl?.kyoRefreshOperation(withDelay: 0, with: KyoManualRefreshType.center)
            return refreshControl
        }()
    }
    
    override func setupData() {
        self.listNumberLab.text = "共\(self.count.unwrapped(or: "0"))条记录"
        self.totalRoyaltiesLab.text = "提成总和：￥\(self.commission.unwrapped(or: "0.00"))"
    }
    
    func netwrokData(page: Int) {
        var networkError: Error? = nil
        LSWorkbenchServer.findMeCommission(page: page, startdate: self.startdate, enddate: self.enddate, selecttype: self.selecttype).subscribe(onSuccess: { listModels in
            guard let listModels = listModels else{return}
            if page == 1 { self.models.removeAll() }
            self.refreshControl.numberOfPage = listModels.pages
            self.models.append(contentsOf: listModels.list)
            self.refreshUI()
        }, onFailure: { error in
            networkError = error
        }, onDisposed: {
            let hadData: Bool = !self.models.isEmpty
            self.refreshControl.kyoRefreshDoneRefreshOrLoadMore(page == 1 ? true : false,
                                                          withHadData: hadData,
                                                          withError: networkError)
        }).disposed(by: self.rx.disposeBag)
    }
    
    func refreshUI() {
        let sectionModels = self.models.map{SectionModel.init(model: "", items: [$0])}
        self.items.onNext(sectionModels)
    }
}

extension LSRoyaltiesDetailsController: KyoRefreshControlDelegate{
    func kyoRefreshDidTriggerRefresh(_ refreshControl: KyoRefreshControl!) {
        netwrokData(page: 1)
    }
    
    func kyoRefreshLoadMore(_ refreshControl: KyoRefreshControl!, loadPage index: Int) {
        netwrokData(page: index + 1)
    }
    func kyoRefresh(_ refreshControl: KyoRefreshControl!, withNoDataShow kyoDataTipsView: KyoDataTipsView!, withCurrentKyoDataTipsModel kyoDataTipsModel: KyoDataTipsModel!, with kyoDataTipsViewType: KyoDataTipsViewType) -> KyoDataTipsModel! {
        kyoDataTipsModel.img = UIImage(named: "无信息")
        kyoDataTipsModel.tip = NSAttributedString(string: "暂无提成数据", attributes: [.foregroundColor: UIColor(hexString: "#999999")!, .font: Font.pingFangRegular(14)])
        return kyoDataTipsModel
    }
}
