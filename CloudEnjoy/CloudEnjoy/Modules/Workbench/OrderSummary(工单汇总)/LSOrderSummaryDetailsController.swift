//
//  LSOrderSummaryDetailsController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/5/21.
//

import UIKit
import RxDataSources
import RxSwift
import SwifterSwift

class LSOrderSummaryDetailsController: LSBaseViewController {
    var tableView: UITableView!
    
    var refreshControl: KyoRefreshControl!
    
    var startdate: String!
    var enddate: String!
    var projectid: String!
    
    var items = PublishSubject<[SectionModel<String, LSOrderServerModel>]>()
    var models = [LSOrderServerModel]()
    
    convenience init(startdate: String, enddate: String, projectid: String) {
        self.init()
        self.startdate = startdate
        self.enddate = enddate
        self.projectid = projectid
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "工单记录"
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
            tableView.rowHeight = 134
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
            tableView.register(nibWithCellClass: LSOrderSummaryCell.self)
            view.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview()
                make.top.equalToSuperview().offset(UI.STATUS_NAV_BAR_HEIGHT + 5)
            }
            
            let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, LSOrderServerModel>> { dataSource, tableView, indexPath, element in
                let cell: LSOrderSummaryCell = tableView.dequeueReusableCell(withClass: LSOrderSummaryCell.self)
                cell.titleLab.text = "\(element.roomname)房--\(element.projectname)/\(element.ctypename)"
                cell.statusLab.text = element.statusname
                cell.statusView.backgroundColor = element.status.backColor
                cell.royaltyLab.text = "￥\(element.commission.stringValue(retain: 2))"
                cell.createTimeLab.text = "\(element.createtime)"
                cell.amtLab.text = "￥\(element.amt.stringValue(retain: 2))"
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
    
    func netwrokData(page: Int) {
        var networkError: Error? = nil
        LSWorkbenchServer.getSaleUserProjectMe(page: page, startdate: self.startdate, enddate: self.enddate, projectid: self.projectid).subscribe(onSuccess: { listModels in
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

extension LSOrderSummaryDetailsController: KyoRefreshControlDelegate{
    func kyoRefreshDidTriggerRefresh(_ refreshControl: KyoRefreshControl!) {
        netwrokData(page: 1)
    }
    
    func kyoRefreshLoadMore(_ refreshControl: KyoRefreshControl!, loadPage index: Int) {
        netwrokData(page: index + 1)
    }
    func kyoRefresh(_ refreshControl: KyoRefreshControl!, withNoDataShow kyoDataTipsView: KyoDataTipsView!, withCurrentKyoDataTipsModel kyoDataTipsModel: KyoDataTipsModel!, with kyoDataTipsViewType: KyoDataTipsViewType) -> KyoDataTipsModel! {
        kyoDataTipsModel.img = UIImage(named: "无信息")
        kyoDataTipsModel.tip = NSAttributedString(string: "暂无汇总记录数据", attributes: [.foregroundColor: UIColor(hexString: "#999999")!, .font: Font.pingFangRegular(14)])
        return kyoDataTipsModel
    }
}

