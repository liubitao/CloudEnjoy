//
//  LSOrderSummaryItemViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/5/21.
//

import UIKit
import JXSegmentedView
import SwifterSwift
import RxDataSources
import RxSwift

class LSOrderSummaryItemViewController: LSBaseViewController {

    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var totalLab: UILabel!
    var tableView: UITableView!
    
    var timeSection: LSTimeSectionType!
    var startdate: String!
    var endDate: String!
    
    var items = PublishSubject<[SectionModel<String, LSOrderSummaryItemModel>]>()
    var orderSummaryModels = [LSOrderSummaryItemModel]()
    var sumDataModel = LSOrderSummaryTotalModel()
    
    convenience init(timeSectionType: LSTimeSectionType) {
        self.init()
        self.timeSection = timeSectionType
        self.startdate = timeSectionType.startdate
        self.endDate = timeSectionType.endDate
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
            tableView.sectionHeaderHeight = 6
            tableView.sectionFooterHeight = 0
            tableView.rowHeight = 52
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
            tableView.register(nibWithCellClass: LSOrderSummaryItemCell.self)
            view.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: 135 + 6, left: 0, bottom: 0, right: 0))
            }
            
            let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, LSOrderSummaryItemModel>> { dataSource, tableView, indexPath, element in
                let cell: LSOrderSummaryItemCell = tableView.dequeueReusableCell(withClass: LSOrderSummaryItemCell.self)
                cell.titleLab.text = element.projectname
                cell.moneyLab.text = "￥\(element.amt.roundString(retain: 2))"
                cell.countLab.text = "\(element.qty)条记录"
                return cell
            }
            items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
            tableView.rx.itemSelected.subscribe {[weak self] indexPath in
                guard let self = self else {return}
                let model = self.orderSummaryModels[indexPath.section]
                self.navigationController?.pushViewController(LSOrderSummaryDetailsController(startdate: self.startdate, enddate: self.endDate, projectid: model.projectid), animated: true)
            } onError: { _ in
            }.disposed(by: self.rx.disposeBag)
            return tableView
        }()
        
    }
    override func setupData() {
        self.timeLab.text = self.startdate + "至" + self.endDate
        self.netwerkData()
    }
    
    func netwerkData() {
        Toast.showHUD()
        LSWorkbenchServer.getSaleUserProjectMeSum(startdate: self.startdate, enddate: self.endDate).subscribe { listModel in
            guard let listModel = listModel else { return }
            self.orderSummaryModels = listModel.list
            self.sumDataModel = LSOrderSummaryTotalModel.deserialize(from: listModel.sumdata as? [String: Any]) ?? LSOrderSummaryTotalModel()
            self.refreshUI()
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }
    
    func refreshUI() {
        self.totalLab.text = "￥\(self.sumDataModel.amt.roundString(retain: 2))"
        let sectionModels = self.orderSummaryModels.map{SectionModel.init(model: "", items: [$0])}
        self.items.onNext(sectionModels)
    }
}

extension LSOrderSummaryItemViewController: JXSegmentedListContainerViewListDelegate{
    func listView() -> UIView {
        return self.view
    }
    
}
