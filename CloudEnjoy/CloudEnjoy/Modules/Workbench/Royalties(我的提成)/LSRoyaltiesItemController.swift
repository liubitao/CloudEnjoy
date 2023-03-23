//
//  LSRoyaltiesItemController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/10.
//

import UIKit
import JXSegmentedView
import SwifterSwift
import RxDataSources
import RxSwift


class LSRoyaltiesItemController: LSBaseViewController {

    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var totalLab: UILabel!
    var tableView: UITableView!
    
    var timeSection: LSTimeSectionType!
    var startdate: String!
    var endDate: String!
    
    var items = PublishSubject<[SectionModel<String, LSRoyaltiesItemModel>]>()
    var royaltiesTotalModel: LSRoyaltiesTotalModel = LSRoyaltiesTotalModel()
    
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
            tableView.register(nibWithCellClass: LSRoyaltiesItemTableCell.self)
            view.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: 135 + 6, left: 0, bottom: 0, right: 0))
            }
            
            let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, LSRoyaltiesItemModel>> { dataSource, tableView, indexPath, element in
                let cell: LSRoyaltiesItemTableCell = tableView.dequeueReusableCell(withClass: LSRoyaltiesItemTableCell.self)
                cell.iconImageView.image = UIImage(named: element.name)
                cell.titleLab.text = element.name
                cell.moneyLab.text = "￥\(element.commission)"
                cell.countLab.text = "\(element.count)条记录"
                return cell
            }
            items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
            tableView.rx.itemSelected.subscribe {[weak self] indexPath in
                guard let self = self else {return}
                let model = self.royaltiesTotalModel.list[indexPath.section]
                self.navigationController?.pushViewController(LSRoyaltiesDetailsController(selecttype: model.selecttype, startdate: self.startdate, enddate: self.endDate, count: model.count, commission: model.commission), animated: true)
            } onError: { _ in
            }.disposed(by: self.rx.disposeBag)
            return tableView
        }()
        
    }
    override func setupData() {
        self.netwerkData()
    }
    
    func netwerkData() {
        self.timeLab.text = "\(self.startdate.components(separatedBy: " ").first.unwrapped(or: "")) 至 \(self.endDate.components(separatedBy: " ").first.unwrapped(or: ""))"
        Toast.showHUD()
        LSWorkbenchServer.findMeByCommission(startdate: self.startdate, enddate: self.endDate).subscribe { royaltiesTotalModel in
            guard let totalModel = royaltiesTotalModel else { return }
            self.royaltiesTotalModel = totalModel
            self.refreshUI()
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }
    
    func refreshUI() {
        self.totalLab.text = "￥\(self.royaltiesTotalModel.commissionsum)"
        let sectionModels = self.royaltiesTotalModel.list.map{SectionModel.init(model: "", items: [$0])}
        self.items.onNext(sectionModels)
    }
}

extension LSRoyaltiesItemController: JXSegmentedListContainerViewListDelegate{
    func listView() -> UIView {
        return self.view
    }
    
}
