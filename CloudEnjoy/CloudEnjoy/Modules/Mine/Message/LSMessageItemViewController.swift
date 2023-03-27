//
//  LSMessageItemViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/27.
//

import UIKit
import JXSegmentedView
import RxSwift
import RxDataSources
import SwifterSwift

class LSMessageItemViewController: LSBaseViewController {
    var tableView: UITableView!
    var refreshControl: KyoRefreshControl!
    
    var items = PublishSubject<[SectionModel<String, LSMessageModel>]>()
    var models = [LSMessageModel]()
    
    var isEdit = false {
        didSet {
            self.refreshUI()
        }
    }
    
    var msgType = LSMsgType.all
    
    convenience init(_ msgType: LSMsgType) {
        self.init()
        self.msgType = msgType
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
            tableView.rowHeight = 96
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
            tableView.register(nibWithCellClass: LSMessageTableViewCell.self)
            view.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
            }
            
            let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, LSMessageModel>> {[weak self] dataSource, tableView, indexPath, element in
                let cell: LSMessageTableViewCell = tableView.dequeueReusableCell(withClass: LSMessageTableViewCell.self)
                guard let self = self else {return cell}
                cell.isEdit = self.isEdit
                cell.selectedView.isHidden = !self.isEdit
                cell.selectedBtn.isSelected = element.isSelected
                cell.titleLab.text = element.title
                cell.statusView.backgroundColor = element.see == "1" ? Color(hexString: "#B8B8B8") : Color(hexString: "#FF0000")
                cell.timeLab.text = element.createtime
                cell.contentLab.text = element.content
                cell.refreshUI()
                cell.selectedBtn.rx.tap.subscribe { _ in
                    var messageModel = element
                    messageModel.isSelected = !element.isSelected
                    self.models[indexPath.section] = messageModel
                }.disposed(by: cell.rx.reuseBag)
                return cell
            }
            items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
            tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
                guard let self = self,
                      self.isEdit == false else {return}
                var messageModel = self.models[indexPath.section]
                messageModel.see = "1"
                self.models[indexPath.section] = messageModel
                let sectionModels = self.models.map{SectionModel.init(model: "", items: [$0])}
                self.items.onNext(sectionModels)
                let alertVC = UIAlertController.init(title: messageModel.title, message: messageModel.content, defaultActionButtonTitle: "我知道了", tintColor: Color(hexString: "#2BB8C2"))
                alertVC.show()
                LSMessageServer.msgUpdate(msgids: messageModel.msgid, mtype: "1").subscribe { _ in
                    
                } onFailure: { error in
                    Toast.show(error.localizedDescription)
                } onDisposed: {
                    
                }.disposed(by: self.rx.disposeBag)
            }).disposed(by: self.rx.disposeBag)
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
        LSMessageServer.getMessageList(ispage: "1", see: "", msgtype: self.msgType.rawValue, page: page.string).subscribe(onSuccess: { listModels in
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
        self.models = self.models.map{ model in
            var resultModel = model
            resultModel.isSelected = false
            return resultModel
        }
        
        let sectionModels = self.models.map{SectionModel.init(model: "", items: [$0])}
        self.items.onNext(sectionModels)
    }
    
    func selectAllMessage(_ isSelect: Bool) {
        self.models = self.models.map{ model in
            var resultModel = model
            resultModel.isSelected = isSelect
            return resultModel
        }
        let sectionModels = self.models.map{SectionModel.init(model: "", items: [$0])}
        self.items.onNext(sectionModels)
    }
    
    func readMessage() {
        Toast.showHUD()
        let readStr = self.models.filter{$0.isSelected == true}.map{$0.msgid}.joined(separator: ",")
        LSMessageServer.msgUpdate(msgids: readStr, mtype: "1").subscribe { _ in
            self.models = self.models.map{model in
                guard model.isSelected == true else {
                    return model
                }
                var messageModel = model
                messageModel.see = "1"
                return messageModel
            }
            let sectionModels = self.models.map{SectionModel.init(model: "", items: [$0])}
            self.items.onNext(sectionModels)
            NotificationCenter.default.post(name: Notification.Name("cancelMessageEdit"), object: nil)
            Toast.show("已设置为已读")
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }
    
    func deletMessage() {
        Toast.showHUD()
        let deletStr = self.models.filter{$0.isSelected == true}.map{$0.msgid}.joined(separator: ",")
        LSMessageServer.msgUpdate(msgids: deletStr, mtype: "2").subscribe { _ in
            self.refreshControl.kyoRefreshOperation(withDelay: 1, with: .default)
            NotificationCenter.default.post(name: Notification.Name("cancelMessageEdit"), object: nil)
            Toast.show("已删除")
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }
}

extension LSMessageItemViewController: KyoRefreshControlDelegate{
    func kyoRefreshDidTriggerRefresh(_ refreshControl: KyoRefreshControl!) {
        netwrokData(page: 1)
    }
    
    func kyoRefreshLoadMore(_ refreshControl: KyoRefreshControl!, loadPage index: Int) {
        netwrokData(page: index + 1)
    }
    func kyoRefresh(_ refreshControl: KyoRefreshControl!, withNoDataShow kyoDataTipsView: KyoDataTipsView!, withCurrentKyoDataTipsModel kyoDataTipsModel: KyoDataTipsModel!, with kyoDataTipsViewType: KyoDataTipsViewType) -> KyoDataTipsModel! {
        kyoDataTipsModel.img = UIImage(named: "无信息")
        kyoDataTipsModel.tip = NSAttributedString(string: "暂无消息数据", attributes: [.foregroundColor: UIColor(hexString: "#999999")!, .font: Font.pingFangRegular(14)])
        return kyoDataTipsModel
    }
}

extension LSMessageItemViewController: JXSegmentedListContainerViewListDelegate{
    func listView() -> UIView {
        return self.view
    }
}

