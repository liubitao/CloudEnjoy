//
//  LSLeaveViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/3.
//

import UIKit
import SwifterSwift
import RxDataSources
import RxSwift

class LSLeaveViewController: LSBaseViewController {
    var tableView: UITableView!
    var refreshControl: KyoRefreshControl!

    var items = PublishSubject<[SectionModel<String, LSLeaveModel>]>()
    var models = [LSLeaveModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "请假记录"
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
            tableView.sectionHeaderHeight = 10
            tableView.sectionFooterHeight = 0
            tableView.rowHeight = 131
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
            tableView.register(nibWithCellClass: LSLeaveTableViewCell.self)
            view.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().offset(UI.STATUS_NAV_BAR_HEIGHT + 10)
                make.bottom.equalToSuperview().offset(-UI.BOTTOM_HEIGHT - 10 - 43 - 10)
            }
            
            let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, LSLeaveModel>> { dataSource, tableView, indexPath, element in
                let cell: LSLeaveTableViewCell = tableView.dequeueReusableCell(withClass: LSLeaveTableViewCell.self)
                cell.leaveTypeLab.text = "请假类型：" + element.leavetypename
                cell.startTimeLab.text = "开始时间：" + element.starttime
                cell.endTimeLab.text = "结束时间：" + element.endtime
                cell.statusLab.text = "请假状态：" + element.statusname
                return cell
            }
            items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
            tableView.rx.modelSelected(LSLeaveModel.self).subscribe(onNext: {[weak self] model in
                guard let self = self else {return}
                self.navigationController?.pushViewController(LSLeaveDetailsViewController(leaveModel: model), animated: true)
            }).disposed(by: self.rx.disposeBag)
            return tableView
        }()
        
        self.refreshControl = {
            let refreshControl = KyoRefreshControl(scrollView: self.tableView, with: self)
            refreshControl?.kyoRefreshOperation(withDelay: 0, with: KyoManualRefreshType.center)
            return refreshControl
        }()
    }
    
    override func setupNotifications() {
        NotificationCenter.default.rx.notification(NSNotification.Name("LeaveListRefresh")).subscribe { [weak self] _ in
            self?.refreshControl?.kyoRefreshOperation(withDelay: 0, with: .default)
        }.disposed(by: self.rx.disposeBag)
    }
    
    func netwrokData(page: Int) {
        var networkError: Error? = nil
        LSWorkbenchServer.getLeaveList(page: page).subscribe(onSuccess: { listModels in
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

    @IBAction func leaveAction(_ sender: Any) {
        self.navigationController?.pushViewController(LSAddLeaveViewController(), animated: true)
    }
}


extension LSLeaveViewController: KyoRefreshControlDelegate{
    func kyoRefreshDidTriggerRefresh(_ refreshControl: KyoRefreshControl!) {
        netwrokData(page: 1)
    }
    
    func kyoRefreshLoadMore(_ refreshControl: KyoRefreshControl!, loadPage index: Int) {
        netwrokData(page: index + 1)
    }
    func kyoRefresh(_ refreshControl: KyoRefreshControl!, withNoDataShow kyoDataTipsView: KyoDataTipsView!, withCurrentKyoDataTipsModel kyoDataTipsModel: KyoDataTipsModel!, with kyoDataTipsViewType: KyoDataTipsViewType) -> KyoDataTipsModel! {
        kyoDataTipsModel.img = UIImage(named: "无信息")
        kyoDataTipsModel.tip = NSAttributedString(string: "暂无请假数据", attributes: [.foregroundColor: UIColor(hexString: "#999999")!, .font: Font.pingFangRegular(14)])
        return kyoDataTipsModel
    }
}
