//
//  LSPhotosViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/9.
//

import UIKit
import SwifterSwift
import RxDataSources
import RxSwift
import AnyImageKit

class LSPhotosViewController: LSBaseViewController {

    private var isEdit = false
    var collectionView: UICollectionView!
    var tipLab: UILabel!
    var addPhotoBtn: UIButton!
    var setCoverbtn: UIButton!
    var deleBtn: UIButton!
    
    var items = PublishSubject<[SectionModel<String, LSPhotoModel>]>()
    var models = [LSPhotoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "相册管理"
    }
    
    override func setupViews() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UI.SCREEN_WIDTH - 12 * 2 - 19 * 2)/3, height: (UI.SCREEN_WIDTH - 12 * 2 - 19 * 2)/3)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        self.collectionView =  UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.isScrollEnabled = false
        collectionView.register(cellWithClass: LSPhotoCollectionCell.self)
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(19)
            make.right.equalToSuperview().offset(-19)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-150)
        }
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, LSPhotoModel>> { [weak self] dataSource, collectionView, indexPath, model in
            let cell = collectionView.dequeueReusableCell(withClass: LSPhotoCollectionCell.self, for: indexPath)
            cell.photoImg.kf.setImage(with: imgUrl(model.img))
            cell.coverLab.isHidden = !model.detimg
            cell.selectedImg.isHighlighted = model.isSelected
            cell.selectedImg.isHidden = !(self?.isEdit ?? false)
            return cell
        }
        items.bind(to: self.collectionView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
        
        self.collectionView.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
            guard let self = self,
                  self.isEdit == true else {return}
            self.models[indexPath.item].isSelected = !self.models[indexPath.item].isSelected
            self.items.onNext([SectionModel.init(model: "", items: self.models)])
        }).disposed(by: self.rx.disposeBag)
        
        self.addPhotoBtn = {
            let addPhotoBtn = UIButton(type: .custom)
            addPhotoBtn.setTitle("添加照片", for: .normal)
            addPhotoBtn.titleLabel?.font = Font.pingFangRegular(14)
            addPhotoBtn.setTitleColor(Color(hexString: "#FFFFFF"), for: .normal)
            addPhotoBtn.setImage(UIImage(named: "camera"), for: .normal)
            addPhotoBtn.centerTextAndImage(imageAboveText: false, spacing: 5)
            addPhotoBtn.backgroundColor = Color(hexString: "#2BB8C2")
            addPhotoBtn.rx.tap.subscribe { [weak self] _ in
                guard let self = self else {return}
                guard self.models.count < 5 else {
                    Toast.show("最多支持5张照片")
                    return
                }
                var options = PickerOptionsInfo()
                options.selectLimit = 5 - self.models.count
                let controller = ImagePickerController(options: options, delegate: self)
                self.present(controller, animated: true, completion: nil)
            }.disposed(by: self.rx.disposeBag)
            addPhotoBtn.cornerRadius = 5
            self.view.addSubview(addPhotoBtn)
            addPhotoBtn.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-10)
                make.height.equalTo(43)
                make.bottom.equalToSuperview().offset(-10 - UI.BOTTOM_HEIGHT)
            }
           return addPhotoBtn
        }()
        
        self.tipLab = {
           let tipLab = UILabel()
            tipLab.text = "Tip：最多支持5张照片！"
            tipLab.textAlignment = .center
            tipLab.font = Font.pingFangRegular(13)
            tipLab.textColor = Color(hexString: "#B5B5B5")
            self.view.addSubview(tipLab)
            tipLab.snp.makeConstraints { make in
                make.bottom.equalTo(self.addPhotoBtn.snp.top).offset(-10)
                make.height.equalTo(19)
                make.centerX.equalToSuperview()
            }
            return tipLab
        }()
        
        self.setCoverbtn = {
            let setCoverbtn = UIButton(type: .custom)
            setCoverbtn.setTitle("设置封面", for: .normal)
            setCoverbtn.setTitleColor(Color(hexString: "#2BB8C2"), for: .normal)
            setCoverbtn.titleLabel?.font = Font.pingFangRegular(14)
            setCoverbtn.cornerRadius = 5
            setCoverbtn.borderWidth = 1
            setCoverbtn.borderColor = Color(hexString: "#2BB8C2")
            setCoverbtn.isHidden = true
            setCoverbtn.rx.tap.subscribe { [weak self] _ in
                guard let self = self else { return }
                let selectedModels = self.models.filter{$0.isSelected}
                if selectedModels.isEmpty {
                    Toast.show("请选择一张您想设置的封面图")
                    return
                }
                if selectedModels.count > 1 {
                    Toast.show("仅能设置一张封面图")
                    return
                }
                guard var lastCoverModel = self.models.first(where: {$0.detimg}),
                    var currentCoverModel = selectedModels.first,
                        lastCoverModel.imgid != currentCoverModel.imgid else {
                    Toast.show("当前选中图片已是封面图")
                    return
                }
                Toast.showHUD()
                LSUserServer.updateUserImg(imgid: currentCoverModel.imgid).subscribe { _ in
                    lastCoverModel.detimg = false
                    currentCoverModel.detimg = true
                    self.models.removeAll(where: {lastCoverModel.imgid == $0.imgid})
                    self.models.removeAll(where: {currentCoverModel.imgid == $0.imgid})
                    self.models.insert(lastCoverModel, at: 0)
                    self.models.insert(currentCoverModel, at: 0)
                    self.items.onNext([SectionModel.init(model: "", items: self.models)])
                    self.editPhoto()
                    Toast.show("已设置成功")
                } onFailure: { error in
                    Toast.show(error.localizedDescription)
                } onDisposed: {
                    Toast.hiddenHUD()
                }.disposed(by: self.rx.disposeBag)
            }.disposed(by: self.rx.disposeBag)
            self.view.addSubview(setCoverbtn)
            setCoverbtn.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(10)
                make.height.equalTo(43)
                make.width.equalTo((UI.SCREEN_WIDTH - 30)/2)
                make.bottom.equalToSuperview().offset(-10 - UI.BOTTOM_HEIGHT)
            }
            return setCoverbtn
        }()
        
        self.deleBtn = {
            let deleBtn = UIButton(type: .custom)
            deleBtn.setTitle("删除照片", for: .normal)
            deleBtn.setTitleColor(Color(hexString: "#FFFFFF"), for: .normal)
            deleBtn.titleLabel?.font = Font.pingFangRegular(14)
            deleBtn.backgroundColor = Color(hexString: "#2BB8C2")
            deleBtn.cornerRadius = 5
            deleBtn.isHidden = true
            deleBtn.rx.tap.subscribe { [weak self] _ in
                guard let self = self else { return }
                let selectedModels = self.models.filter{$0.isSelected}
                if selectedModels.isEmpty {
                    Toast.show("请选择您想删除的图片")
                    return
                }
                Toast.showHUD()
                LSUserServer.delUserImg(imgids: self.models.filter{$0.isSelected}.map{$0.imgid}).subscribe { _ in
                    self.models = self.models.filter{$0.isSelected == false}
                    self.items.onNext([SectionModel.init(model: "", items: self.models)])
                    self.editPhoto()
                    Toast.show("已删除成功")
                } onFailure: { error in
                    Toast.show(error.localizedDescription)
                } onDisposed: {
                    Toast.hiddenHUD()
                }.disposed(by: self.rx.disposeBag)
            }.disposed(by: self.rx.disposeBag)
            self.view.addSubview(deleBtn)
            deleBtn.snp.makeConstraints { make in
                make.right.equalToSuperview().offset(-10)
                make.height.equalTo(43)
                make.width.equalTo((UI.SCREEN_WIDTH - 30)/2)
                make.bottom.equalToSuperview().offset(-10 - UI.BOTTOM_HEIGHT)
            }
            return deleBtn
        }()
    }
    
    override func setupData() {
        Toast.showHUD()
        LSUserServer.getUserImgList().subscribe { models in
            if let models = models {
                self.models = models
                self.items.onNext([SectionModel.init(model: "", items: models)])
            }
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }
    
    override func setupNavigation() {
        let rightBarBtn = UIBarButtonItem(title: "管理", style: .plain, target: self, action: #selector(editPhoto))
        rightBarBtn.setTitleTextAttributes([.foregroundColor: Color(hexString: "#333333")!], for: .normal)
        self.navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    
    @objc func editPhoto() {
        self.isEdit = !self.isEdit
        self.tipLab.isHidden = self.isEdit
        self.addPhotoBtn.isHidden = self.isEdit
        self.deleBtn.isHidden = !self.isEdit
        self.setCoverbtn.isHidden = !self.isEdit
        let rightBarBtn = UIBarButtonItem(title: self.isEdit ? "取消" : "管理", style: .plain, target: self, action: #selector(editPhoto))
        rightBarBtn.setTitleTextAttributes([.foregroundColor: Color(hexString: "#333333")!], for: .normal)
        self.navigationItem.rightBarButtonItem = rightBarBtn
        
        self.models = self.models.map({ lastModel in
            var model = lastModel
            model.isSelected = false
            return model
        })
        self.items.onNext([SectionModel.init(model: "", items: self.models)])
    }
    
    func updateUserImg() {
        
    }
    
    func updateImgs() {
        
    }
}

extension LSPhotosViewController: ImagePickerControllerDelegate {

    func imagePickerDidCancel(_ picker: ImagePickerController) {
        /*
          你的业务代码，处理用户取消(存在默认实现，如果需要额外行为请自行实现本方法)
        */
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePicker(_ picker: ImagePickerController, didFinishPicking result: PickerResult) {
        let images = result.assets.map { $0.image }
        guard !images.isEmpty else {
            return
        }
        Toast.showHUD()
        let uploadImages = images.map{LSUploadServer.upload(image: $0).asObservable()}
        Observable.concat(uploadImages).subscribe { uploadImageModel in
            guard let uploadImageModel = uploadImageModel else {
                return
            }
            var photoModel = LSPhotoModel()
            photoModel.img = uploadImageModel.imgurl
            photoModel.imgid = uploadImageModel.imgid
            if self.models.isEmpty {
                photoModel.detimg = true
                self.models.append(photoModel)
            }else {
                self.models.insert(photoModel, at: 1)
            }
            self.items.onNext([SectionModel.init(model: "", items: self.models)])
        } onError: { error in
            Toast.show(error.localizedDescription)
        } onCompleted: {
            Toast.show("相册已更新")
        }onDisposed: {
            picker.dismiss(animated: true, completion: nil)
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)

    }
}




class LSPhotoCollectionCell: UICollectionViewCell {
    var photoImg: UIImageView!
    var selectedImg: UIImageView!
    var coverLab: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.photoImg = {
           let photoImg = UIImageView()
            photoImg.contentMode = .scaleAspectFill
            photoImg.cornerRadius = 5
            self.contentView.addSubview(photoImg)
            photoImg.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            return photoImg
        }()
        
        self.selectedImg = {
            let selectedImg = UIImageView()
            selectedImg.image = UIImage(named: "未选中")
            selectedImg.highlightedImage = UIImage(named: "选中")
            self.contentView.addSubview(selectedImg)
            selectedImg.snp.makeConstraints { make in
                make.right.equalToSuperview().offset(-4)
                make.top.equalToSuperview().offset(4)
                make.size.equalTo(CGSize(width: 20, height: 20))
            }
            return selectedImg
        }()
        
        self.coverLab = {
           let coverLab = UILabel()
            coverLab.text = "封面图"
            coverLab.textColor = Color(hexString: "#FFFFFF")
            coverLab.font = Font.pingFangRegular(14)
            self.contentView.addSubview(coverLab)
            coverLab.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-10)
            }
            return coverLab
        }()
        
        
    }
    
}
