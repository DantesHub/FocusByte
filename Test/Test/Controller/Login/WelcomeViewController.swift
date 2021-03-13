import UIKit
import RealmSwift
import TinyConstraints
import AppsFlyerLib

var xPadding: CGFloat = 0
var buttonWidth: CGFloat = 0
var middleTextSize = 0
var titlePadding = 0
var iphone8Padding = 0
var registerPadding:CGFloat = 275
var backgroundType = "proBackground"
var lessThanConstant:CGFloat = 840
var onPad = false
var isIpod = false
var startTapped = false
var signUpTapped = false
var titleSize: Int {
    get {
        var size = 0
        if UIDevice().userInterfaceIdiom == .phone || UIDevice().userInterfaceIdiom == .pad {
            switch UIScreen.main.nativeBounds.height {
            case 1920, 2208:
                size = 55
                middleTextSize = 40
                buttonWidth = 350
                xPadding = -175
                registerPadding = 265
                backgroundType = "8background"
                 lessThanConstant = 350
            //("iphone 8plus")
            case 1136:
                size = 40
                isIpod = true
                iphone8Padding = 50
                titlePadding = 5
                middleTextSize = 30
                buttonWidth = 300
                xPadding = -145
                registerPadding = 265
                backgroundType = "8background"
                lessThanConstant = 350
                //iphone 5
            case 1334:
                //Iphone 8
                size = 50
                iphone8Padding = 50
                titlePadding = 9
                middleTextSize = 35
                buttonWidth = 300
                xPadding = -145
                registerPadding = 265
                backgroundType = "8background"
                lessThanConstant = 350
            case 2436:
                size = 50
                titlePadding = 9
                middleTextSize = 35
                buttonWidth = 300
                xPadding = -145
                lessThanConstant = 350
            //print("IPHONE X, IPHONE XS, IPHONE 11 PRO, iphone 12 mini ")
            case 2688:
                size = 55
                middleTextSize = 40
                buttonWidth = 350
                xPadding = -175
                lessThanConstant = 350
            //print("IPHONE XS MAX, IPHONE 11 PRO MAX")
            case 1792:
                size = 55
                middleTextSize = 40
                buttonWidth = 350
                xPadding = -175
            //print("IPHONE XR, IPHONE 11")
            case 2532:
                size = 55
                middleTextSize = 40
                buttonWidth = 325
                xPadding = -175
                lessThanConstant = 350
            //iphone 12, iphone 12 pro
            case 2778:
            //iphone 12 pro max
                size = 55
                middleTextSize = 40
                buttonWidth = 350
                xPadding = -175
                lessThanConstant = 350
            default:
                onPad = true
                size = 50
                titlePadding = 9
                lessThanConstant = 840
                middleTextSize = 35
                buttonWidth = 300
                xPadding = -145
            }
        }
        return size
    }
}
var background: UIImageView = {
    let imageView = UIImageView(frame: .zero)
    imageView.image = UIImage(named: backgroundType)
    imageView.contentMode = .scaleToFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
}()
class WelcomeViewController: UIViewController {
    //MARK: - properties
    var results: Results<User>!
    var startView = UIView()
    var loginView = UIView()
    var startLabel = UILabel()
    var loginLabel = UILabel()
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
        results = uiRealm.objects(User.self)
        configureNavigationBar(color: .white, isTrans: true)
        startTapped = false
        UINavigationBar.appearance().barTintColor = .white
        for result in results {
            if result.isLoggedIn == true {
                navigationController?.pushViewController(ContainerController(center: TimerController()), animated: false)
            }
        }
        view.insertSubview(background, at: 0)
             NSLayoutConstraint.activate([
                 background.topAnchor.constraint(equalTo: view.topAnchor),
                 background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                 background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                 background.bottomAnchor.constraint(equalTo: view.bottomAnchor)
             ])
    }
    
    // MARK: - helper functions
    func loadComponents() {
        view.addSubview(titleLabel1)
        view.addSubview(titleLabel2)
        view.addSubview(middleText)
     
        configureNavigationBar(color: .white, isTrans: true)
        titleLabel1.frame.size.width = 300
        titleLabel1.frame.size.height = 100
        titleLabel1.center.y = view.center.y - 200
        titleLabel1.text = "FOCUS"
        titleLabel1.font = UIFont(name: "Menlo", size: CGFloat(titleSize))
        titleLabel1.center.x = view.center.x + (isIpod ?  CGFloat(titlePadding * 7)  : CGFloat(titlePadding))
        titleLabel1.textColor = brightPurple
        
        titleLabel2.frame.size.width = 300
        titleLabel2.frame.size.height = 100
        titleLabel2.center.y = view.center.y - 200
        titleLabel2.text = "BYTE"
        titleLabel2.font = UIFont(name: "Menlo", size: CGFloat(titleSize))
        titleLabel2.center.x = view.center.x + 165 - CGFloat(titlePadding)
        titleLabel2.textColor = .black
        
        middleText.frame.size.width = view.frame.width * 0.725
        middleText.frame.size.height = view.frame.height * 0.45
        middleText.center.x = view.center.x + CGFloat(titlePadding * 2)
        middleText.center.y = view.center.y - 50
        middleText.text = "Level up and have fun while you study and do work. "
        middleText.textColor = .black
        middleText.numberOfLines = 0;
        middleText.font = UIFont(name: "Hiragino Sans", size: CGFloat(middleTextSize))
        
        
        view.addSubview(startView)
        startView.translatesAutoresizingMaskIntoConstraints = false
        startView.applyDesign(color: brightPurple)
        startView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 120).isActive = true
        startView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        startView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        startView.widthAnchor.constraint(lessThanOrEqualToConstant: lessThanConstant).isActive = true

        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tappedStart))
        startView.addGestureRecognizer(tap2)
        
        view.addSubview(loginView)
        loginView.translatesAutoresizingMaskIntoConstraints = false
        loginView.applyDesign(color: lightLavender)
        loginView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginView.topAnchor.constraint(equalTo: startView.bottomAnchor, constant: 20).isActive = true
        loginView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        loginView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        loginView.widthAnchor.constraint(lessThanOrEqualToConstant: lessThanConstant).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedLogin))
        loginView.addGestureRecognizer(tap)
        
        
        view.addSubview(loginLabel)
        loginLabel.applyDesign(text: "Login")
        loginLabel.sizeToFit()
        loginLabel.center(in: loginView)
        
        view.addSubview(startLabel)
        startLabel.applyDesign(text: "Start")
        startLabel.sizeToFit()
        startLabel.center(in: startView)
    }

    
    //MARK: - Handlers
    @objc func tappedLogin() {
        AppsFlyerLib.shared().logEvent("tapped_login_onboarding", withValues: [AFEventParamContent: "true"])
        let loginVC = LoginViewController()
        startTapped = false
        self.navigationController?.pushViewController(loginVC, animated: false)
    }
    
    @objc func tappedStart() {
        AppsFlyerLib.shared().logEvent("tapped_start_onboarding", withValues: [AFEventParamContent: "true"])
        startTapped = true
        self.navigationController?.pushViewController(GenderViewController(), animated: true)
    }
    
}
