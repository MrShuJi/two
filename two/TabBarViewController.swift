//
//  TabBarViewController.swift
//  two
//
//  Created by shuji on 2017/10/12.
//  Copyright © 2017年 shuji. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController,UITabBarControllerDelegate{

    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       
        swipeGestureDemo()
        let nav01 = UINavigationController(rootViewController: OneViewController())
        let nav02 = UINavigationController(rootViewController: TwoViewController())
        let nav03 = UINavigationController(rootViewController: TreeViewController())
        let nav04 = UINavigationController(rootViewController: FourViewController())
        
        
        
        
        let tabBar = UITabBar.appearance()
        tabBar.tintColor = UIColor(red: 245 / 255, green: 90 / 255, blue: 93 / 255, alpha: 1/0)
        
        
        let barItem01 = UITabBarItem(title: "首页", image: UIImage(named: "home_tabbar_32x32_"), selectedImage: UIImage(named: "home_tabbar_press_32x32_"))
        nav01.tabBarItem = barItem01
        let barItem02 = UITabBarItem(title: "视频", image: UIImage(named: "video_tabbar_32x32_"), selectedImage: UIImage(named: "video_tabbar_press_32x32_"))
        nav02.tabBarItem = barItem02
        let barItem03 = UITabBarItem(title: "微头条", image: UIImage(named: "weitoutiao_tabbar_32x32_"), selectedImage: UIImage(named: "weitoutiao_tabbar_press_32x32_"))
        nav03.tabBarItem = barItem03
        
        let barItem04 = UITabBarItem(title: "未登陆", image: UIImage(named: "no_login_tabbar_32x32_"), selectedImage: UIImage(named: "no_login_tabbar_press_32x32_"))
        nav04.tabBarItem = barItem04
        
        
        
        let VCArr = [nav01,nav02,nav03,nav04]
        
        self.viewControllers = VCArr
    
        self.selectedIndex = 0;
        
        self.delegate = self
    }
    
    
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /**滑动手势*/
    func swipeGestureDemo() {
        
        let swip = UISwipeGestureRecognizer(target: self, action: #selector(self.viewSwipe(sender:)))
        swip.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swip)
        
        let swip2 = UISwipeGestureRecognizer(target: self, action: #selector(self.viewSwipe(sender:)))
        swip2.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swip2)
    }
    
    /**滑动事件*/
    var offsetX: Int = 0
    var offsetXx: CGFloat = 0
    var offsetXy: CGFloat = 0
    @objc func viewSwipe(sender: UISwipeGestureRecognizer) {
        
        let direction = sender.direction
        switch direction {
        case UISwipeGestureRecognizerDirection.left:
                if (self.selectedIndex + 1 < 3) {
                    offsetX = offsetX + 1
                    self.selectedIndex = offsetX
                }
            break
        case UISwipeGestureRecognizerDirection.right:
                if (self.selectedIndex - 1 >= 0) {
                    offsetX = offsetX - 1
                    self.selectedIndex = offsetX
                }
            break
        default:
            break
        }  
    }
    
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //获取选中的item
        let tabIndex = tabBar.items?.index(of: item)
        if tabIndex != self.selectedIndex {
            //设置最近一次变更
            _lastSelectedIndex = self.selectedIndex
            
        }
    }
    
    //MARK: -- UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        return true
    }
    
    //MARK: --setter getter
    var _lastSelectedIndex: NSInteger!
    var lastSelectedIndex: NSInteger {
        if _lastSelectedIndex == nil {
            _lastSelectedIndex = NSInteger()
            //判断是否相等,不同才设置
            if (self.selectedIndex != selectedIndex) {
                //设置最近一次
                _lastSelectedIndex = self.selectedIndex;
            }
            //调用父类的setSelectedIndex
            super.selectedIndex = selectedIndex
        }
        return _lastSelectedIndex
    }
    
    
}
