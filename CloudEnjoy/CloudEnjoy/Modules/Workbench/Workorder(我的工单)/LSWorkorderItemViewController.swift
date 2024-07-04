//
//  LSWorkorderItemViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/13.
//

import UIKit
import JXSegmentedView
import SwifterSwift
import RxDataSources
import RxSwift
import LSBaseModules

class LSWorkorderItemViewController: LSBaseViewController {
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var listNumberLab: UILabel!
    @IBOutlet weak var totalRoyaltiesLab: UILabel!
    
    var tableView: UITableView!

    var refreshControl: KyoRefreshControl!
    
    var timeSection: LSTimeSectionType!
    var startdate: String!
    var enddate: String!
    var orderServerStatus: LSOrderServerStatus = .none

    var items = PublishSubject<[SectionModel<String, LSOrderServerModel>]>()
    var models = [LSOrderServerModel]()
    var sumDataModel = LSOrderSummaryTotalModel()
    

    
    convenience init(timeSectionType: LSTimeSectionType) {
        self.init()
        self.timeSection = timeSectionType
        self.startdate = timeSectionType.startdate
        self.enddate = timeSectionType.endDate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            tableView.sectionHeaderHeight = 7
            tableView.sectionFooterHeight = 0
            tableView.rowHeight = 100
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
            tableView.register(nibWithCellClass: LSOrderTableViewCell.self)
            view.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: 45, left: 0, bottom: -40, right: 0))
            }
            
            let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, LSOrderServerModel>> { dataSource, tableView, indexPath, element in
                let cell: LSOrderTableViewCell = tableView.dequeueReusableCell(withClass: LSOrderTableViewCell.self)
                cell.sortIndexLab.text = "\(indexPath.row + 1)"
                
                var roomDetailsStr = ""
                switch parametersModel().OperationMode {
                case .room:
                    roomDetailsStr = element.roomname + "(床位：\(element.bedname))"
                case .roomAndHandCard:
                    roomDetailsStr = element.roomname + "(手牌：\(element.handcardno))"
                case .handCard:
                    roomDetailsStr = element.handcardno
                }
                
                
                cell.titleLab.text = "\(roomDetailsStr)--\(element.projectname)/\(element.ctypename)"
                cell.statusLab.text = element.statusname
                cell.statusView.backgroundColor = element.status.backColor
                cell.amtLab.text = "项目金额：￥\(element.amt.stringValue(retain: 2))"
                cell.royaltyLab.text = "项目提成：￥\(element.commission.stringValue(retain: 2))"
                cell.createTimeLab.text = "下单时间：\(element.createtime)"
                return cell
            }
            items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
            tableView.rx.modelSelected(LSOrderServerModel.self).subscribe(onNext: {[weak self] model in
                guard let self = self else {return}
                self.navigationController?.pushViewController(LSWorkOrderDetailsController(billid: model.billid), animated: true)
            }).disposed(by: self.rx.disposeBag)
            return tableView
        }()
        
        self.refreshControl = {
            let refreshControl = KyoRefreshControl(scrollView: self.tableView, with: self)
            refreshControl?.kyoRefreshOperation(withDelay: 0, with: KyoManualRefreshType.center)
            return refreshControl
        }()
    }
    
    override func setupData() {
        self.timeLab.text = self.startdate + "至" + self.enddate
        self.networkSumData()
    }
    
    func changeOrderStatus(_ orderStatus: LSOrderServerStatus) {
        self.orderServerStatus = orderStatus
        self.networkSumData()
        self.refreshControl?.kyoRefreshOperation(withDelay: 0, with: KyoManualRefreshType.center)
        
    }
    
    func networkSumData() {
        LSWorkbenchServer.getSaleUserProjectMeSum(startdate: self.startdate, enddate: self.enddate, status: self.orderServerStatus.rawValue).subscribe { listModel in
            guard let listModel = listModel else { return }
            self.sumDataModel = LSOrderSummaryTotalModel.deserialize(from: listModel.sumdata as? [String: Any]) ?? LSOrderSummaryTotalModel()
            guard let listNumberLab = self.listNumberLab,
                  let totalRoyaltiesLab = self.totalRoyaltiesLab else {
                return
            }
            listNumberLab.text = "共\(self.sumDataModel.qty)条记录"
            totalRoyaltiesLab.text = "提成总和：￥\(self.sumDataModel.commission.stringValue(retain: 2))"
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }
    
    func networkData(page: Int) {
        var networkError: Error? = nil
        LSWorkbenchServer.getSaleUserProjectMe(page: page, startdate: self.startdate, enddate: self.enddate, status: self.orderServerStatus).subscribe(onSuccess: { listModels in
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

extension LSWorkorderItemViewController: KyoRefreshControlDelegate{
    func kyoRefreshDidTriggerRefresh(_ refreshControl: KyoRefreshControl!) {
        networkData(page: 1)
    }
    
    func kyoRefreshLoadMore(_ refreshControl: KyoRefreshControl!, loadPage index: Int) {
        networkData(page: index + 1)
    }
    func kyoRefresh(_ refreshControl: KyoRefreshControl!, withNoDataShow kyoDataTipsView: KyoDataTipsView!, withCurrentKyoDataTipsModel kyoDataTipsModel: KyoDataTipsModel!, with kyoDataTipsViewType: KyoDataTipsViewType) -> KyoDataTipsModel! {
        kyoDataTipsModel.img = UIImage(named: "无信息")
        kyoDataTipsModel.tip = NSAttributedString(string: "暂无工单数据", attributes: [.foregroundColor: UIColor(hexString: "#999999")!, .font: Font.pingFangRegular(14)])
        return kyoDataTipsModel
    }
}


extension LSWorkorderItemViewController: JXSegmentedListContainerViewListDelegate{
    func listView() -> UIView {
        return self.view
    }
    
  
}

