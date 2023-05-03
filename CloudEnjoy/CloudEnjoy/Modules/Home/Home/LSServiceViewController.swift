//
//  LSServiceViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/4/8.
//

import UIKit
import RxSwift
import RxDataSources
import SwifterSwift

class LSServiceViewController: LSBaseViewController {
    
    @IBOutlet weak var searchGoodsTextField: UITextField!
    @IBOutlet weak var roomNameLab: UILabel!
    @IBOutlet weak var bedNoLab: UILabel!
    @IBOutlet weak var remarkTrxtField: UITextField!

    
    var tableView: UITableView!
    var items = PublishSubject<[SectionModel<String, LSServiceModel>]>()
    
    var allServiceModels: [LSServiceModel]?
    var selectedServiceModels: [LSServiceModel]?
    
    var projectModel: LSHomeProjectModel!
    
    convenience init(with projectModel: LSHomeProjectModel) {
        self.init()
        self.projectModel = projectModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "呼叫服务"
    }
    
    override func setupViews() {
        self.roomNameLab.text = projectModel.roomname
        self.bedNoLab.text = projectModel.bedname
        
        self.tableView = {
            var tableView = UITableView(frame: CGRect.zero, style: .grouped)
            if #available(iOS 13.0, *) {
                tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
            }
            tableView.backgroundColor = Color.white
            tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UI.SCREEN_WIDTH, height: 0.01))
            tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UI.SCREEN_WIDTH, height: 0.01))
            tableView.sectionHeaderHeight = 0
            tableView.sectionFooterHeight = 0
            tableView.cornerRadius = 5
            tableView.rowHeight = 57
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
            tableView.register(nibWithCellClass: LSServiceTableViewCell.self)
            view.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().offset(UI.STATUS_NAV_BAR_HEIGHT + 48 + 5)
                make.bottom.equalToSuperview().offset(-UI.BOTTOM_HEIGHT - 10 - 43 - 10 - 135 - 10)
            }
            let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, LSServiceModel>> { dataSource, tableView, indexPath, element in
                let cell: LSServiceTableViewCell = tableView.dequeueReusableCell(withClass: LSServiceTableViewCell.self)
                cell.titleLab.text = element.content
                cell.serviceNumberLab.text = element.number.string
                cell.subtractBtn.isHidden = element.number == 0
                cell.serviceNumberLab.isHidden = element.number == 0
                
                cell.subtractBtn.rx.tap.subscribe { [weak self] _ in
                    guard let self = self else {return}
                    element.number -= 1
                    self.tableView.reloadData()
                }.disposed(by: cell.rx.reuseBag)
                
                cell.plusBtn.rx.tap.subscribe { [weak self] _ in
                    guard let self = self else {return}
                    element.number += 1
                    self.tableView.reloadData()
                }.disposed(by: cell.rx.reuseBag)
                return cell
            }
            items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
            return tableView
        }()
    }
    
    override func setupData() {
        Toast.showHUD()
        LSHomeServer.getServiceList().subscribe { listModel in
            self.allServiceModels = listModel?.list
            self.selectedServiceModels = self.allServiceModels
            self.items.onNext([SectionModel(model: "", items: self.selectedServiceModels ?? [])])
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }
    
    @IBAction func searchGoodsAction(_ sender: Any) {
        guard let key = self.searchGoodsTextField.text,
            key.isEmpty == false  else {
            return
        }
        self.selectedServiceModels = self.allServiceModels?.filter{$0.content.contains(key)}
        self.items.onNext([SectionModel(model: "", items: self.selectedServiceModels ?? [])])
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        guard let serviceModels = self.allServiceModels?.filter({$0.number > 0}),
              serviceModels.isEmpty == false else {
            Toast.show("请选择服务后，再下单")
            return
        }
       
        let servicelist = serviceModels.map{["serviceid": $0.serviceid,
                                             "qty": $0.number,
                                             "content": $0.content]}.ls_toJSONString() ?? ""
        Toast.showHUD()
        LSHomeServer.addService(billid: self.projectModel.billid, roomid: self.projectModel.roomid, bedid: self.projectModel.bedid, remark: self.remarkTrxtField.text ?? "", servicelist: servicelist).subscribe { _ in
            Toast.show("服务已呼叫成功")
            self.navigationController?.popViewController(animated: true)
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }

}
