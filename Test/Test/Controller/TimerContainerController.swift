//
//  TimerContainerController.swift
//  Test
//
//  Created by Dante Kim on 4/8/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit

class TimerContainerController: UIViewController {
    //MARK: - Properties
    var menuController: MenuController! //We only want to add our menuController one time
    var centerController: UIViewController!
    var isExpanded = false
    //MARK: - Init
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        self.navigationController?.isNavigationBarHidden = true
        configureTimerController()
}
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return isExpanded
    }
    
    //MARK: - Handlers
    func configureTimerController() {
        let timerController = TimerController()
        timerController.delegate = self
        centerController = UINavigationController(rootViewController: timerController)
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
        
    }
    
    func configureMenuController()  {
        if menuController == nil {
            //add our menu controller
            menuController = MenuController()
             menuController.delegate = self
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
        }
    }
    
    func showMenuController(shouldExpand: Bool, menuOption: MenuOption?) {
        if shouldExpand {
            //show menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 190
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = 0
            }) { (_) in
                guard let menuOption = menuOption else { return }
                //when we hide the menu then this func gets called
                self.didSelectMenuOption(menuOption: menuOption)
            }
        }
//        animateStatusBar()
    }
    
    func didSelectMenuOption(menuOption: MenuOption) {
        switch menuOption {
        case .timer:
            print("show timer")
        case .store:
            print("show store")
        case .avatar:
            print("show avatar")
        case .statistics:
            print("show statistics")
        case .inventory:
            print("show inventory")
        case .settings:
            let controller = SettingsController()
            controller.modalPresentationStyle = .fullScreen
            presentInFullScreen(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        }
    }
    
    func animateStatusBar() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
    
}



extension TimerContainerController: TimerControllerDelegate {
    func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        if !isExpanded {
            configureMenuController()
        }
         isExpanded = !isExpanded
        showMenuController(shouldExpand: isExpanded, menuOption: menuOption)
    }
    
    
}
