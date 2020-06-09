
import UIKit

class ContainerController: UIViewController {
    //MARK: - Properties
    var menuController: MenuController! //We only want to add our menuController one time
    var centerController: UIViewController!
    var isExpanded = false
    
    
    //MARK: - INIT
    convenience init(center: UIViewController) {
        self.init()
        self.centerController = center
    }
    
  
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        self.navigationController?.isNavigationBarHidden = true
        configureCenterController()
    }
    override func viewWillAppear(_ animated: Bool) {
        if loggedOut {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
    //MARK: - Helper Functions
       func configureCenterController() {
            if centerController is TimerController {
                let timerController = TimerController()
                timerController.delegate = self
                centerController = UINavigationController(rootViewController: timerController)
            }
            if centerController is StoreController {
                let storeController = StoreController()
                storeController.delegate = self
                centerController = UINavigationController(rootViewController: storeController)
            }
            if centerController is AvatarController {
                    let avatarController = AvatarController()
                    avatarController.delegate = self
                    centerController = UINavigationController(rootViewController: avatarController)
            }
            if centerController is InventoryController {
                let inventoryController = InventoryController()
                inventoryController.delegate = self
                centerController = UINavigationController(rootViewController: inventoryController)
            }
            if centerController is StatisticsController {
                let statisticsController = StatisticsController()
                statisticsController.delegate = self
                centerController = UINavigationController(rootViewController: statisticsController)
            }
            if centerController is SettingsController {
                let settingsController = SettingsController()
                settingsController.delegate = self
                centerController = UINavigationController(rootViewController: settingsController)
            }
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
    
    //MARK: - Handlers
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
    }
    
    func didSelectMenuOption(menuOption: MenuOption) {
        switch menuOption {
        case .timer:
            let controller = ContainerController(center: TimerController())
            controller.modalPresentationStyle = .fullScreen
             presentInFullScreen(UINavigationController(rootViewController: controller), animated: false, completion: nil)
        case .store:
            let controller = ContainerController(center: StoreController())
            controller.modalPresentationStyle = .fullScreen
            presentInFullScreen(UINavigationController(rootViewController: controller), animated: false, completion: nil)
        case .avatar:
            let controller = ContainerController(center: AvatarController())
            controller.modalPresentationStyle = .fullScreen
            presentInFullScreen(UINavigationController(rootViewController: controller), animated: false, completion: nil)
        case .statistics:
            var controller = UIViewController()
            var animated = false
            if UserDefaults.standard.bool(forKey: "isPro") == true {
                controller = ContainerController(center: StatisticsController())
            } else {
                controller = GoProViewController()
                animated = true
            }
            controller.modalPresentationStyle = .fullScreen
                      presentInFullScreen(UINavigationController(rootViewController: controller), animated:animated, completion: nil)
           
        case .inventory:
            let controller = ContainerController(center: InventoryController())
            controller.modalPresentationStyle = .fullScreen
            presentInFullScreen(UINavigationController(rootViewController: controller), animated: false, completion: nil)
        case .settings:
            let controller = ContainerController(center: SettingsController())
            controller.modalPresentationStyle = .fullScreen
            presentInFullScreen(UINavigationController(rootViewController: controller), animated: false, completion: nil)
        case .goPro:
            let controller = GoProViewController()
            controller.modalPresentationStyle = .fullScreen
            presentInFullScreen(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        }
            
    }
}

extension ContainerController: ContainerControllerDelegate {
    func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        if !isExpanded {
            configureMenuController()
        }
        isExpanded = !isExpanded
        showMenuController(shouldExpand: isExpanded, menuOption: menuOption)
    }
}
