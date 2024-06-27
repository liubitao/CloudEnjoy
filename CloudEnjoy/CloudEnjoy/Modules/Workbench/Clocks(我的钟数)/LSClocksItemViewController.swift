//
//  LSClocksItemViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/13.
//

import UIKit
import JXSegmentedView
import SwifterSwift
import RxDataSources
import RxSwift

class LSClocksItemViewController: LSBaseViewController {
    @IBOutlet weak var timeLab: UILabel!
    
    @IBOutlet weak var mainClocTitleLab: UILabel!
    @IBOutlet weak var mainClockLab: UILabel!
    @IBOutlet weak var mainBGImageView: UIImageView!
    
    @IBOutlet weak var smallClocTitleLab: UILabel!
    @IBOutlet weak var smallClockLab: UILabel!
    @IBOutlet weak var smallBGImageView: UIImageView!
    
    @IBOutlet weak var wheelClockLab: UILabel!
    @IBOutlet weak var oClockLab: UILabel!
    @IBOutlet weak var callClockLab: UILabel!
    @IBOutlet weak var optionClockLab: UILabel!
    @IBOutlet weak var addClockLab: UILabel!
    
    

    
    var isShowMain = true
    
    var tableView: UITableView!
    
    var timeSection: LSTimeSectionType!
    var startdate: String!
    var endDate: String!
    
    var items = PublishSubject<[SectionModel<String, LSFindMeClockNumItemModel>]>()
    var clockNumModel: LSFindMeClockNumModel = LSFindMeClockNumModel()
    
    convenience init(timeSectionType: LSTimeSectionType) {
        self.init()
        
        self.timeSection = timeSectionType
        self.startdate = timeSectionType.startdate
        self.endDate = timeSectionType.endDate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupViews() {
        self.tableView = {
            let tableView = UITableView(frame: CGRect.zero, style: .plain)
            tableView.backgroundColor = Color.clear
            tableView.tableFooterView = UIView()
            tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UI.SCREEN_WIDTH, height: 0.01))
            tableView.sectionHeaderHeight = 33
            tableView.sectionFooterHeight = 0
            tableView.rowHeight = 52
            tableView.separatorStyle = .none
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
            tableView.register(nibWithCellClass: LSClockTableViewCell.self)
            view.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: 137 + 42 + 6, left: 10, bottom: 0, right: 10))
            }
            
            let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, LSFindMeClockNumItemModel>> { dataSource, tableView, indexPath, element in
                let cell: LSClockTableViewCell = tableView.dequeueReusableCell(withClass: LSClockTableViewCell.self)
                cell.clockTitleLab.text = element.name
                cell.wheelClockLab.text = element.sumlqty.stringValue(retain: 1)
                cell.oClockLab.text = element.sumdqty.stringValue(retain: 1)
                cell.callClockLab.text = element.sumcqty.stringValue(retain: 1)
                cell.optionClockLab.text = element.sumxqty.stringValue(retain: 1)
                cell.addClockLab.text = element.sumjqty.stringValue(retain: 1)
                cell.contentView.backgroundColor = indexPath.row%2 == 0 ? Color(hexString: "#FFFFFF") : Color(hexString: "#F7FAFF")
                return cell
            }
            tableView.rx.setDelegate(self).disposed(by: self.rx.disposeBag)
            items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
            return tableView
        }()
        
    }
    override func setupData() {
        self.timeLab.text = self.startdate + "至" + self.endDate

        self.netwerkData()
    }
    
    func netwerkData() {
        Toast.showHUD()
        LSWorkbenchServer.findMeClockNum(startdate: self.startdate, enddate: self.endDate).subscribe { royaltiesTotalModel in
            guard let totalModel = royaltiesTotalModel else { return }
            self.clockNumModel = totalModel
            let sectionModels = [SectionModel.init(model: "", items: self.clockNumModel.list.filter{$0.ptype == 0})]
            self.items.onNext(sectionModels)
            self.refreshUI()
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }
    
    func refreshUI() {
        let mainTotalModel = self.clockNumModel.ptypelist.first{$0.ptype == 0}
        self.mainClockLab.text = mainTotalModel?.sumqty.stringValue(retain: 1) ?? "0.0"
        let smallTotalModel = self.clockNumModel.ptypelist.first{$0.ptype == 1}
        self.smallClockLab.text = smallTotalModel?.sumqty.stringValue(retain: 1) ?? "0.0"
        if isShowMain {
            self.mainBGImageView.isHidden = false
            self.smallBGImageView.isHidden = true
            self.mainClocTitleLab.textColor = Color.white
            self.mainClockLab.textColor = Color.white
            self.smallClocTitleLab.textColor = Color(hexString: "#757575")
            self.smallClockLab.textColor = Color(hexString: "#00A4AF")
            self.wheelClockLab.text = mainTotalModel?.sumlqty.stringValue(retain: 1) ?? "0.0"
            self.oClockLab.text = mainTotalModel?.sumdqty.stringValue(retain: 1) ?? "0.0"
            self.callClockLab.text = mainTotalModel?.sumcqty.stringValue(retain: 1) ?? "0.0"
            self.optionClockLab.text = mainTotalModel?.sumxqty.stringValue(retain: 1) ?? "0.0"
            self.addClockLab.text = mainTotalModel?.sumjqty.stringValue(retain: 1) ?? "0.0"
        }else {
            self.mainBGImageView.isHidden = true
            self.smallBGImageView.isHidden = false
            self.smallClocTitleLab.textColor = Color.white
            self.smallClockLab.textColor = Color.white
            self.mainClocTitleLab.textColor = Color(hexString: "#757575")
            self.mainClockLab.textColor = Color(hexString: "#00A4AF")
            self.wheelClockLab.text = smallTotalModel?.sumlqty.stringValue(retain: 1) ?? "0.0"
            self.oClockLab.text = smallTotalModel?.sumdqty.stringValue(retain: 1) ?? "0.0"
            self.callClockLab.text = smallTotalModel?.sumcqty.stringValue(retain: 1) ?? "0.0"
            self.optionClockLab.text = smallTotalModel?.sumxqty.stringValue(retain: 1) ?? "0.0"
            self.addClockLab.text = smallTotalModel?.sumjqty.stringValue(retain: 1) ?? "0.0"
        }
    }
    
    @IBAction func mainClockAction(_ sender: Any) {
        self.isShowMain = true
        let sectionModels = [SectionModel.init(model: "", items: self.clockNumModel.list.filter{$0.ptype == 0})]
        self.items.onNext(sectionModels)
        self.refreshUI()
    }
    
    
    @IBAction func smallClockAction(_ sender: Any) {
        self.isShowMain = false
        let sectionModels = [SectionModel.init(model: "", items: self.clockNumModel.list.filter{$0.ptype == 1})]
        self.items.onNext(sectionModels)
        self.refreshUI()
    }
    
    

}

extension LSClocksItemViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = LSClockHeaderView.createFromXib()
        return headerView
    }
    
    
}


extension LSClocksItemViewController: JXSegmentedListContainerViewListDelegate{
    func listView() -> UIView {
        return self.view
    }
}

