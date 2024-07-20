//
//  LSProjectCartViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2024/7/20.
//

import UIKit
import SwifterSwift
import RxSwift
import RxDataSources
import RxCocoa

class LSProjectCartViewController: LSBaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    
    var items = PublishSubject<[SectionModel<String, ProjectAddItemModel>]>()
    var models = [ProjectAddItemModel]()

    var selectedClosure: (([ProjectAddItemModel]) -> Void)?
    
    class func creaeFromStoryboard(models: [ProjectAddItemModel]) -> Self {
        let sb = UIStoryboard.init(name: "AlertStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LSProjectCartViewController") as! Self
        vc.models = models
        return vc
    }
    
    func presentedWith(_ presentingViewController: LSBaseViewController) {
        let transitionAnimationDelegate = TransitionAnimationDelegate()
        transitionAnimationDelegate.overlayTransitioningType = .blackBackground
        transitionAnimationDelegate.touchInBackgroundType = .close
        transitionAnimationDelegate.viewAnimationType = .transformFromBottom
        transitionAnimationDelegate.enableInteractive = true
        self.transitioningDelegate = transitionAnimationDelegate
        self.modalPresentationStyle = .custom
        presentingViewController.present(self, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupViews() {
        
        self.view.backgroundColor = UIColor.white;
        self.view.frame = CGRectMake(0, 0, UI.SCREEN_WIDTH, 400+UI.BOTTOM_HEIGHT);
        
        tableView.backgroundColor = Color.clear
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UI.SCREEN_WIDTH, height: 0.01))
        tableView.sectionHeaderHeight = 7
        tableView.sectionFooterHeight = 0
        tableView.rowHeight = 50
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.register(nibWithCellClass: LSProjectCartTableViewCell.self)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, ProjectAddItemModel>> { dataSource, tableView, indexPath, element in
            let cell: LSProjectCartTableViewCell = tableView.dequeueReusableCell(withClass: LSProjectCartTableViewCell.self)
            cell.projectNameLab.text = element.projectModel.name
            cell.jsNameLab.text = element.clockSelectModel == .wheelClock ? "轮钟" : element.selectJSModel?.name
            cell.deleteBtn.rx.tap.subscribe { [weak self, weak cell] text in
                guard let self = self else {return}
                self.models.remove(at: indexPath.section)
                let sectionModels = self.models.map{ SectionModel(model: "", items: [$0])}
                self.items.onNext(sectionModels)
            }.disposed(by: cell.rx.reuseBag)
            return cell
        }
        items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
        
        let sectionModels = self.models.map{ SectionModel(model: "", items: [$0])}
        self.items.onNext(sectionModels)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        self.selectedClosure?(self.models)
        self.dismiss(animated: true)
    }
  

}
