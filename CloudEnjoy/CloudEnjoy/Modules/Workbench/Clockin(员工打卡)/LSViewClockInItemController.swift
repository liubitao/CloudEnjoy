//
//  LSViewClockInItemController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/30.
//

import UIKit
import JXSegmentedView
import SwifterSwift
import RxSwift
import LSNetwork
import LSBaseModules
import MapKit

class LSViewClockInItemController: LSBaseViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var currentAddressLab: UILabel!
    @IBOutlet weak var storeAddressLab: UILabel!
    @IBOutlet weak var clockView: UIView!
    @IBOutlet weak var clockBtn: UIButton!
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var clockStatusLab: UILabel!
    @IBOutlet weak var clockTipLab: UILabel!
    @IBOutlet weak var clockDetailsView: UIView!
    @IBOutlet weak var upClockView: UIView!
    @IBOutlet weak var upTimeLab: UILabel!
    @IBOutlet weak var upAddressLab: UILabel!
    @IBOutlet weak var downClockView: UIView!
    @IBOutlet weak var downClockLab: UILabel!
    
    
    private var locationManager: CLLocationManager!
    private var geocoder: CLGeocoder = CLGeocoder()
    private var lastLocation: CLLocation?
    private var lastAddress: String?
    
    private var punchinModels: [LSPlaceModel] = []
    private var placePunchinModel: LSPlacePunchinModel?
    
    private var timer = Observable<Int>.timer(.seconds(1), period: .seconds(0), scheduler: MainScheduler.asyncInstance)
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupViews() {
        self.contentView.cornerRadius = 5
        
        self.clockView.cornerRadius = 35
        self.storeAddressLab.text = storeModel().name
        self.clockBtn.setBackgroundImage(UIImage.createGradientImage(startColor: Color(hexString: "#00AAB7")!, endColor: Color(hexString: "#00C294")!, width: 200, height: 70), for: .normal)
        self.clockBtn.setBackgroundImage(UIImage.createGradientImage(startColor: Color(hexString: "#00AAB7")!, endColor: Color(hexString: "#00C294")!, width: 200, height: 70), for: .highlighted)
        
        self.upClockView.cornerRadius = 4
        self.upClockView.borderWidth = 1
        self.upClockView.borderColor = Color(hexString: "#EF9C00")
        self.downClockView.cornerRadius = 4
        self.downClockView.borderWidth = 1
        self.downClockView.borderColor = Color(hexString: "#EF9C00")
        
        self.timeLab.text = Date().string(withFormat: "hh:mm:ss")
        self.timer.subscribe(onNext: { _ in
            self.timeLab.text = Date().string(withFormat: "hh:mm:ss")
            self.clockStatusLab.text = "上班打卡"
        }).disposed(by: self.rx.disposeBag)
        
    }

    override func setupData() {
        networkData()
    }
    func networkData() {
        Toast.showHUD()
        let placeListSingle = LSWorkbenchServer.getPlaceList()
        let dayPlaceSingle = LSWorkbenchServer.getPlacePunchin(datetime: Date().string(withFormat: "yyyy-MM-dd"))
        Observable.zip(placeListSingle.asObservable(), dayPlaceSingle.asObservable()).subscribe { listModel, model in
            self.punchinModels = listModel?.list ?? []
            self.placePunchinModel = model
            self.refreshUI()
        } onError: { error in
            Toast.show(error.localizedDescription)
        } onCompleted: {
            
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
        
        self.locationManager = {
            let locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            if #available(iOS 14.0, *) {
                guard locationManager.authorizationStatus == .authorizedAlways ||
                        locationManager.authorizationStatus == .authorizedWhenInUse else {
                    locationManager.requestWhenInUseAuthorization()
                    return locationManager
                }
            } else {
                guard CLLocationManager.authorizationStatus() == .authorizedAlways ||
                        CLLocationManager.authorizationStatus() == .authorizedWhenInUse else {
                    locationManager.requestWhenInUseAuthorization()
                    return locationManager
                }
            }
            return locationManager
        }()
    }
    
    func refreshUI() {
        
    }
    
    @IBAction func clockAction(_ sender: Any) {
        guard let lastLocation = self.lastLocation else {
            Toast.show("gps定位信号弱，请稍后再试")
            return
        }
        let firstModel = self.punchinModels.first { placeModel in
            let distance = CLLocation.init(latitude: placeModel.lat, longitude: placeModel.lng).distance(from: lastLocation)
            return Int(distance) < placeModel.range
        }
        guard let punchinModel = firstModel else {
            Toast.show("不在打卡范围内，请靠近再打卡")
            return
        }
        Toast.showHUD()
        LSWorkbenchServer.placePunchin(adr: punchinModel.name).subscribe { _ in
            Toast.show("打卡成功")
            self.networkData()
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }
}

// MARK: -CLLocationManagerDelegate
extension LSViewClockInItemController : CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14, *) {
            if manager.authorizationStatus == .authorizedAlways ||
                manager.authorizationStatus == .authorizedWhenInUse {
                manager.startUpdatingLocation()
            }
        } else {
            if CLLocationManager.authorizationStatus() == .authorizedAlways ||
                CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                manager.startUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else{return}
        defer { self.lastLocation = currentLocation }
        
        guard let lastLocation = lastLocation else {
            geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
                self.lastAddress = placemarks?.first?.name
                self.currentAddressLab.text = self.lastAddress
            }
            return
        }
        
        let distanceSinceLastPoint = currentLocation.distance(from: lastLocation)
        guard distanceSinceLastPoint > 10 else {
            return
        }
        
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            self.lastAddress = placemarks?.first?.name
            self.currentAddressLab.text = self.lastAddress
        }
    }
}




extension LSViewClockInItemController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
}

