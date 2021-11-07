import UIKit
import AppsFlyerLib

class EnableNotificationsController: UIViewController {
    //MARK: - instance variables
    var focusNotification: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "focusNotification")
        iv.layer.shadowColor = UIColor.black.cgColor
        iv.layer.shadowOpacity = 0.5
        iv.layer.shadowOffset = .zero
        iv.layer.shadowRadius = 10
        return iv
    }()
    var focusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Menlo", size: 18)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Get Warning Notifications to Stay on Course"
        return label
    }()
    
    var focusCompleteNotification: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "focusCompleteNotification")
        iv.layer.shadowColor = UIColor.black.cgColor
        iv.layer.shadowOpacity = 0.3
        iv.layer.shadowOffset = .zero
        iv.layer.shadowRadius = 10
        return iv
    }()
    var focusCompleteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Menlo", size: 18)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Know When It's Time to Take a Break!"
        return label
    }()
    var maybeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Menlo", size: 16)
        label.textColor = .gray
        label.textAlignment = .center
        label.text = "Maybe Later"
        return label
    }()
    var enableButton = UIButton()
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Menlo-Bold", size: 20)
        label.textColor = .white
        let stringValue = "Focusbyte Notifications Increase User Productivity by Over 88%!"
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
        attributedString.setColor(color: brightPurple, forText: "Focusbyte Notifications")
        label.attributedText = attributedString
        return label
    }()
    var astronaut: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Space Suit")
        return iv
    }()
    
    //MARK: - init
    override func viewDidLoad() {
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar(color: backgroundColor, isTrans: true)
    }
    
    //MARK: - helper functions
    func configureUI() {
        self.navigationItem.hidesBackButton = true
        view.backgroundColor = backgroundColor
        view.addSubview(astronaut)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        astronaut.contentMode = .scaleAspectFit
        astronaut.topToSuperview(offset: view.frame.height * 0.10)
        astronaut.leading(to: view, offset: 0)
        astronaut.height(view.frame.height * 0.20)
        astronaut.width(view.frame.width * 0.40)
        
        view.addSubview(descriptionLabel)
        descriptionLabel.leadingToTrailing(of: astronaut, offset: -15)
        descriptionLabel.topToSuperview(offset: view.frame.height * 0.12)
        descriptionLabel.width(view.frame.width * 0.60)
        descriptionLabel.height(view.frame.height * 0.15)
        descriptionLabel.numberOfLines = 0

        view.addSubview(focusNotification)
        focusNotification.centerXToSuperview()
        focusNotification.topToBottom(of: descriptionLabel, offset: 25)
        focusNotification.width(view.frame.width * 0.90)
        focusNotification.height(view.frame.height * 0.13)
        
        view.addSubview(focusLabel)
        focusLabel.centerXToSuperview()
        focusLabel.topToBottom(of: focusNotification, offset: -10)
        focusLabel.numberOfLines = 0
        focusLabel.width(view.frame.width * 0.85)
        
        view.addSubview(focusCompleteNotification)
        focusCompleteNotification.centerXToSuperview()
        focusCompleteNotification.topToBottom(of: focusLabel, offset: 15)
        focusCompleteNotification.width(view.frame.width)
        focusCompleteNotification.height(view.frame.height * 0.15)
        
        view.addSubview(focusCompleteLabel)
        focusCompleteLabel.centerXToSuperview()
        focusCompleteLabel.topToBottom(of: focusCompleteNotification, offset: -10)
        focusCompleteLabel.numberOfLines = 0
        focusCompleteLabel.width(view.frame.width * 0.85)
        
        view.addSubview(enableButton)
        enableButton.bottomToSuperview(offset: -view.frame.height * 0.125)
        enableButton.centerXToSuperview()
        enableButton.width(view.frame.width * 0.85)
        enableButton.height(view.frame.height * 0.08)
        enableButton.setTitle("Enable Notifications", for: .normal)
        enableButton.titleLabel?.font = UIFont(name: "Menlo-Bold", size: 18)
        enableButton.setTitleColor(.white, for: .normal)
        enableButton.backgroundColor = brightPurple
        enableButton.layer.cornerRadius = 25
        enableButton.layer.shadowColor = UIColor.black.cgColor
        enableButton.layer.shadowOpacity = 0.5
        enableButton.layer.shadowOffset = .zero
        enableButton.layer.shadowRadius = 10
        enableButton.addTarget(self, action: #selector(tappedEnable), for: .touchUpInside)
        
        view.addSubview(maybeLabel)
        maybeLabel.centerXToSuperview()
        maybeLabel.topToBottom(of: enableButton, offset: 15)
        maybeLabel.isUserInteractionEnabled = true
        let maybeGest = UITapGestureRecognizer(target: self, action: #selector(tappedMaybe))
        maybeLabel.addGestureRecognizer(maybeGest)
    }
    
    @objc func tappedMaybe() {
        AppsFlyerLib.shared().logEvent("tapped_maybe_later_onboarding", withValues: [AFEventParamContent: "true"])
        pushController()
    }
    
    @objc func tappedEnable() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { permission in
            switch permission.authorizationStatus  {
            case .authorized:
                AppsFlyerLib.shared().logEvent("notification_enabled", withValues: [AFEventParamContent: "true"])
                //came back from settings add these reminders
                if UserDefaults.standard.value(forKey: "oneDayNotif") == nil {
                    NotificationHelper.addOneDay()
                }
                if UserDefaults.standard.value(forKey: "threeDayNotif") == nil {
                    NotificationHelper.addThreeDay()
                }
                self.pushController()
            case .denied:
                AppsFlyerLib.shared().logEvent("notification_go_to_settings", withValues: [AFEventParamContent: "true"])
                DispatchQueue.main.async {
                    if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                        UIApplication.shared.open(appSettings)
                    }
                }
            case .notDetermined:
                AppsFlyerLib.shared().logEvent("notification_go_to_settings", withValues: [AFEventParamContent: "true"])
                DispatchQueue.main.async {
                    if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                        UIApplication.shared.open(appSettings)
                    }
                }
            default:
                print("Unknow Status")
            }
        })
        UIApplication.shared.registerForRemoteNotifications()

    }
    func pushController() {
        UserDefaults.standard.setValue(signUpTapped ? false : true, forKey: "noLogin")
        DispatchQueue.main.async {
            let controller = SubscriptionController()
            controller.modalPresentationStyle = .fullScreen
            controller.onboarding = true
            self.presentInFullScreen(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        }
    }
}


