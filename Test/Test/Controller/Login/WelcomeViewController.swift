import UIKit
import RealmSwift


var xPadding: CGFloat = 0
var buttonWidth: CGFloat = 0
var middleTextSize = 0
var titlePadding = 0
var iphone8Padding = 0
var titleSize: Int {
    get {
        var size = 0
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1920, 2208:
                size = 55
                middleTextSize = 40
                buttonWidth = 350
                xPadding = -175
            //("iphone 8plus")
            case 1334:
                //Iphone 8
                size = 50
                iphone8Padding = 50
                titlePadding = 9
                middleTextSize = 35
                buttonWidth = 300
                xPadding = -145
            case 2436:
                size = 50
                titlePadding = 9
                middleTextSize = 35
                buttonWidth = 300
                xPadding = -145
            //print("IPHONE X, IPHONE XS, IPHONE 11 PRO")
            case 2688:
                size = 55
                middleTextSize = 40
                buttonWidth = 350
                xPadding = -175
            //print("IPHONE XS MAX, IPHONE 11 PRO MAX")
            case 1792:
                size = 55
                middleTextSize = 40
                buttonWidth = 350
                xPadding = -175
            //print("IPHONE XR, IPHONE 11")
            default:
                size = 50
                titlePadding = 9
                middleTextSize = 35
                buttonWidth = 300
                xPadding = -145
            }
        }
        return size
    }
}
class WelcomeViewController: UIViewController {
    //MARK: - properties
    var results: Results<User>!
    var loginView = UIView()
    var registerView = UIView()
    var loginLabel = UILabel()
    var registerLabel = UILabel()
    let titleLabel1 = UILabel()
    let titleLabel2 = UILabel()
    let middleText = UILabel()

    
    
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        loadComponents()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        print("welcome screen")
        results = uiRealm.objects(User.self)
        for result in results {
            if result.isLoggedIn == true {
                navigationController?.pushViewController(ContainerController(center: TimerController()), animated: false)
            }
        }
    }
    
    // MARK: - helper functions
    func loadComponents() {
        view.backgroundColor = .white
        configureNavigationBar(color: .white, isTrans: true)
        titleLabel1.frame.size.width = 300
        titleLabel1.frame.size.height = 100
        titleLabel1.center.y = view.center.y - 200
        titleLabel1.text = "FOCUS"
        titleLabel1.font = UIFont(name: "Menlo", size: CGFloat(titleSize))
        titleLabel1.center.x = view.center.x + CGFloat(titlePadding)
        titleLabel1.textColor = brightPurple
        
        titleLabel2.frame.size.width = 300
        titleLabel2.frame.size.height = 100
        titleLabel2.center.y = view.center.y - 200
        titleLabel2.text = "BYTE"
        titleLabel2.font = UIFont(name: "Menlo", size: CGFloat(titleSize))
        titleLabel2.center.x = view.center.x + 165 - CGFloat(titlePadding)
        titleLabel2.textColor = .black
        
 
        middleText.frame.size.width = 300
        middleText.frame.size.height = 400
        middleText.center.x = view.center.x + CGFloat(titlePadding * 2)
        middleText.center.y = view.center.y - 50
        middleText.text = "Level up and have fun while you study and do work. "
        middleText.textColor = .black
        middleText.numberOfLines = 0;
        middleText.font = UIFont(name: "Hiragino Sans", size: CGFloat(middleTextSize))
        
        registerView =  UIView(frame: CGRect(x: 100, y: 400, width: buttonWidth, height: 80))
        registerView.applyDesign(color: lightLavender)
        registerView.center.x = view.center.x
        registerView.center.y = view.center.y + 250
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedRegister))
        registerView.addGestureRecognizer(tap)
        
        loginView =  UIView(frame: CGRect(x: 100, y: 400, width: buttonWidth, height: 80))
        loginView.applyDesign(color: brightPurple)
        loginView.center.x = view.center.x
        loginView.center.y = view.center.y + 140
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tappedLogin))
        loginView.addGestureRecognizer(tap2)
        
        registerLabel.applyDesign(text: "Register")
        registerLabel.sizeToFit()
        registerLabel.center.x = view.center.x
        registerLabel.center.y = view.center.y + 250
        
        
        loginLabel.applyDesign(text: "Login")
        loginLabel.sizeToFit()
        loginLabel.center.x = view.center.x
        loginLabel.center.y = view.center.y + 140
       

        view.addSubview(titleLabel1)
        view.addSubview(titleLabel2)
        view.addSubview(loginView)
        view.addSubview(registerView)
        view.addSubview(loginLabel)
        view.addSubview(registerLabel)
        view.addSubview(middleText)
    }

    
    //MARK: - Handlers
    @objc func tappedLogin() {
        let loginVC = LoginViewController()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @objc func tappedRegister() {
        let registerVC = RegisterViewController()
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
}
