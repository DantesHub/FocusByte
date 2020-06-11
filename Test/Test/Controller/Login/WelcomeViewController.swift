import UIKit
import RealmSwift
import TinyConstraints

var xPadding: CGFloat = 0
var buttonWidth: CGFloat = 0
var middleTextSize = 0
var titlePadding = 0
var iphone8Padding = 0
var registerPadding:CGFloat = 300
var backgroundType = "proBackground"
var lessThanConstant:CGFloat = 840
var onPad = false

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
                registerPadding = 250
                backgroundType = "8background"
                 lessThanConstant = 350
            //("iphone 8plus")
            case 1334:
                //Iphone 8
                size = 50
                iphone8Padding = 50
                titlePadding = 9
                middleTextSize = 35
                buttonWidth = 300
                xPadding = -145
                registerPadding = 250
                backgroundType = "8background"
                lessThanConstant = 350
            case 2436:
                size = 50
                titlePadding = 9
                middleTextSize = 35
                buttonWidth = 300
                xPadding = -145
                lessThanConstant = 350
            //print("IPHONE X, IPHONE XS, IPHONE 11 PRO")
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
        results = uiRealm.objects(User.self)
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
        
        
        view.addSubview(loginView)
        loginView.translatesAutoresizingMaskIntoConstraints = false
        loginView.applyDesign(color: brightPurple)
        loginView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 140).isActive = true
        loginView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        loginView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        loginView.widthAnchor.constraint(lessThanOrEqualToConstant: lessThanConstant).isActive = true

        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tappedLogin))
        loginView.addGestureRecognizer(tap2)
        
        view.addSubview(registerView)
           registerView.translatesAutoresizingMaskIntoConstraints = false
           registerView.applyDesign(color: lightLavender)
           registerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
           registerView.topAnchor.constraint(equalTo: loginView.bottomAnchor, constant: 20).isActive = true
           registerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
                   registerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
           registerView.widthAnchor.constraint(lessThanOrEqualToConstant: lessThanConstant).isActive = true

           let tap = UITapGestureRecognizer(target: self, action: #selector(tappedRegister))
           registerView.addGestureRecognizer(tap)
        
        
        view.addSubview(registerLabel)
        registerLabel.applyDesign(text: "Sign Up")
        registerLabel.sizeToFit()
        registerLabel.center(in: registerView)
        
        view.addSubview(loginLabel)
        loginLabel.applyDesign(text: "Login")
        loginLabel.sizeToFit()
        loginLabel.center(in: loginView)
    }

    
    //MARK: - Handlers
    @objc func tappedLogin() {
        let loginVC = LoginViewController()
        self.navigationController?.pushViewController(loginVC, animated: false)
    }
    
    @objc func tappedRegister() {
        let registerVC = RegisterViewController()
        self.navigationController?.pushViewController(registerVC, animated: false)
    }
}
