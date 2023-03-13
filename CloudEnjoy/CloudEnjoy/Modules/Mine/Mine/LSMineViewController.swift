//
//  LSMineViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/2.
//

import UIKit
import RxDataSources
import SwifterSwift
import RxSwift

class LSMineViewController: LSBaseViewController {
    var headView: LSMineHeadView!
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人中心"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.vhl_navBarBackgroundAlpha = 0
        self.vhl_navBarTitleColor = Color(hexString: "#FFFFFF")!
        
        self.headView.refreshUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.vhl_navBarBackgroundAlpha = 1
        self.vhl_navBarTitleColor = Color(hexString: "#000000")!
    }
    
    override func setupNavigation() {
        let rightBarBtn = UIBarButtonItem(image: UIImage(named: "消息通知")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(jumpMessage))
        self.navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    override func setupViews() {
        self.headView = {
            let headView = LSMineHeadView.createFromXib()
            view.addSubview(headView)
            headView.snp.makeConstraints { make in
                make.left.top.right.equalToSuperview()
                make.height.equalTo(UI.STATUS_NAV_BAR_HEIGHT + 120)
            }
            return headView
        }()
        
        self.tableView = {
            let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
            tableView.tableFooterView = UIView()
            tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UI.SCREEN_WIDTH, height: 0.01))
            tableView.isScrollEnabled = false
            tableView.rowHeight = 50
            
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
            tableView.register(nibWithCellClass: LSMineSettingCell.self)
            view.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(self.headView.snp.bottom).offset(10)
            }
            
            let items = Observable.just([SectionModel(model: "", items: [["icon": "商家信息", "title": "商家信息"],
                                                                         ["icon": "相册管理", "title": "相册管理"],
                                                                         ["icon": "账户安全", "title": "账号安全"],
                                                                         ["icon": "设置", "title": "系统设置"]])])
            let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Dictionary<String, String>>> { dataSource, tableView, indexPath, element in
                let cell: LSMineSettingCell = tableView.dequeueReusableCell(withClass: LSMineSettingCell.self)
                cell.refreshUI(element["icon"]!, element["title"]!)
                return cell
            }
            items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
            
            tableView.rx.itemSelected.subscribe { [weak self] indexPath in
                guard let self = self else {return}
                switch indexPath.row {
                case 0:
                    self.navigationController?.pushViewController(LSStoreInfoViewController(), animated: true)
                case 1:
                    self.navigationController?.pushViewController(LSPhotosViewController(), animated: true)
                case 2:
                    self.navigationController?.pushViewController(LSAccountSecureController.creaeFromStoryboard(), animated: true)
                case 3:
                    self.navigationController?.pushViewController(LSSystemViewController(), animated: true)
                default:
                    break
                }
            }.disposed(by: self.rx.disposeBag)
            
            return tableView
        }()
        
        
    }
    
    @objc func jumpMessage() {
        self.navigationController?.pushViewController(LSMessageViewController(), animated: true)
    }
}
