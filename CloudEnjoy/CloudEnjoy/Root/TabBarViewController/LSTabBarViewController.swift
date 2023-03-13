//
//  LSTabBarViewController.swift
//  Haylou_Fun
//
//  Created by liubitao on 2021/11/18.
//

import UIKit
import SwifterSwift


class LSTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBar()
        self.setupChildsViewControllers()
    }
    
    private func setupTabBar(){
        
        if #available(iOS 13.0, *) {
            let appearance: UITabBarAppearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundImage = UIImage(color: Color(hexString: "#FFFFFF")!, size: CGSize(width: UI.SCREEN_WIDTH, height: UI.TABBAR_HEIGHT))
            appearance.backgroundImageContentMode = .scaleToFill
            appearance.shadowImage =  UIImage(color: UIColor(hexString: "#F3F3F3")!, size: CGSize(width: UI.SCREEN_WIDTH, height: 1))
            appearance.backgroundColor = .white
            let itemAppearance = UITabBarItemAppearance();
            itemAppearance.normal.titleTextAttributes = [.foregroundColor : Color(hexString: "#000000")!]
            itemAppearance.selected.titleTextAttributes = [.foregroundColor : Color(hexString: "#00AAB7")!]
            appearance.stackedLayoutAppearance = itemAppearance
            tabBar.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = appearance;
            }
        } else {
            tabBar.backgroundImage = UIImage(color: Color(hexString: "#FFFFFF")!, size: CGSize(width: UI.SCREEN_WIDTH, height: UI.TABBAR_HEIGHT))
            tabBar.contentMode = .scaleToFill
            tabBar.backgroundColor = .white
            tabBar.shadowImage = UIImage(color: UIColor(hexString: "#F3F3F3") ?? UIColor.white, size: CGSize(width: UI.SCREEN_WIDTH, height: 1))
            tabBar.tintColor = Color(hexString: "#00AAB7")
            tabBar.unselectedItemTintColor = Color(hexString: "#000000")
            tabBar.barTintColor = Color(hexString: "#FFFFFF")
            
        }
    }
    //HomeViewController,LSHealthHomeViewController
    private func setupChildsViewControllers(){
        self.add(childVC: LSHomeViewController(), title: "首页", imageName: "首页", selectedImageName: "首页-down")
        self.add(childVC: LSWorkbenchViewController(), title: "工作台", imageName: "工作台", selectedImageName: "工作台-down")
        self.add(childVC: LSMineViewController(), title: "我的", imageName: "我的", selectedImageName: "我的-down")

    }
    
    func add(childVC: UIViewController, title: String, imageName: String, selectedImageName: String){
        childVC.title = title
        childVC.tabBarItem.image = UIImage(named: imageName)
        var selectedImage: UIImage? = UIImage(named: selectedImageName)
        selectedImage = selectedImage?.withRenderingMode(.alwaysOriginal)
        childVC.tabBarItem.selectedImage = selectedImage
        
        var textAttrs: Dictionary<NSAttributedString.Key, Any> = Dictionary<NSAttributedString.Key, Any>()
        textAttrs[NSAttributedString.Key.font] = Font.pingFangMedium(14)
        childVC.tabBarItem.setTitleTextAttributes(textAttrs, for: .normal)
        

        //设置tabBarItem选中状态下文字的颜色
        var selectedtextAttrs: Dictionary<NSAttributedString.Key, Any> = Dictionary<NSAttributedString.Key, Any>()
        selectedtextAttrs[NSAttributedString.Key.font] = Font.pingFangMedium(14)
        childVC.tabBarItem.setTitleTextAttributes(textAttrs, for: .selected)
        
        let navi: LSNavigationController = LSNavigationController.init(rootViewController: childVC)
        
        self.addChild(navi)
    }
    
}


extension LSTabBarViewController{
    
    override var shouldAutorotate: Bool {
        return self.selectedViewController?.shouldAutorotate ?? false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.selectedViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.selectedViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return selectedViewController?.preferredStatusBarStyle ?? .default
    }
    
}
