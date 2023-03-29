//
//  LSRankViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/27.
//

import UIKit
import SwifterSwift
import RxDataSources
import RxSwift

class LSRankViewController: LSBaseViewController {
    var tableView: UITableView!
    var items = PublishSubject<[SectionModel<String, LSRankModel>]>()
    var models = [LSRankModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "我的排行"
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
            tableView.rowHeight = 63
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
            tableView.register(nibWithCellClass: LSRankTableViewCell.self)
            view.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().offset(UI.STATUS_NAV_BAR_HEIGHT + 10)
                make.bottom.equalToSuperview().offset(-UI.BOTTOM_HEIGHT)
            }
            
            let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, LSRankModel>> { dataSource, tableView, indexPath, element in
                let cell: LSRankTableViewCell = tableView.dequeueReusableCell(withClass: LSRankTableViewCell.self)
                if indexPath.row < 3 {
                    cell.rankImageView.isHidden = false
                    cell.ranLab.isHidden = true
                    cell.rankImageView.image = UIImage(named: "rank" + indexPath.row.string)
                }else {
                    cell.rankImageView.isHidden = true
                    cell.ranLab.isHidden = false
                    cell.ranLab.text = (indexPath.row + 1).string
                }
                cell.rankIconImageView.kf.setImage(with: imgUrl(element.headimg), placeholder: UIImage(named: "placeholder"))
                cell.rankNameLab.text = element.username
                cell.rankCodeLab.text = element.usercode
                cell.rankLevelLab.text = element.tlname
                cell.rankLevelView.isHidden = element.tlname.isEmpty
                cell.rankClockLab.text = element.sumqty
                return cell
            }
            items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
        
            return tableView
        }()
    }
    
    override func setupData() {
        Toast.showHUD()
        LSHomeServer.findProjectRanking().subscribe(onSuccess: { listModels in
            guard let listModels = listModels else{return}
            self.models = listModels.list
            self.refreshUI()
        }, onFailure: { error in
            Toast.show(error.localizedDescription)
        }, onDisposed: {
            Toast.hiddenHUD()
        }).disposed(by: self.rx.disposeBag)
    }
    
    func refreshUI() {
        let sectionModels = [SectionModel.init(model: "", items: self.models)]
        self.items.onNext(sectionModels)
    }
}
