import UIKit
import Firebase

var chosenGender: String = ""
class GenderViewController: UIViewController {
    let boyImage = UIImage(named: "babyBoy")
    let girlImage = UIImage(named: "babyGirl")
    var boyImageView = UIImageView()
    var girlImageView = UIImageView()
    let selectLabel = UILabel()
    var ref: DatabaseReference!
    let db = Firestore.firestore()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = lightLavender
        configureNavigationBar()
        self.navigationItem.setHidesBackButton(true, animated: false)
        UINavigationBar.appearance().barTintColor = lightLavender
        boyImageView.center.x = view.center.x - 150
        boyImageView.center.y = view.center.y - 100
        boyImageView.image = boyImage
        boyImageView.layer.cornerRadius = 25
        boyImageView.sizeToFit()
        boyImageView.frame.size.width = 135
        boyImageView.frame.size.height = 135
        boyImageView.backgroundColor = superLightLavender
        boyImageView.layer.masksToBounds = false
        boyImageView.layer.shadowColor = UIColor.black.cgColor
        boyImageView.layer.shadowOffset = CGSize(width: 5, height: 5)
        boyImageView.layer.shadowOpacity = 0.4
        boyImageView.layer.shadowRadius = 10
        boyImageView.isUserInteractionEnabled = true
        let tappedBoy = UITapGestureRecognizer(target: self, action: #selector(boyTapped))
        boyImageView.addGestureRecognizer(tappedBoy)
        view.addSubview(boyImageView)
        
        girlImageView.center.x = view.center.x + 30
        girlImageView.center.y = view.center.y - 100
        girlImageView.image = girlImage
        girlImageView.layer.cornerRadius = 25
        girlImageView.sizeToFit()
        girlImageView.layer.masksToBounds = false
        girlImageView.layer.shadowColor = UIColor.black.cgColor
        girlImageView.layer.shadowOffset = CGSize(width: 5, height: 5)
        girlImageView.layer.shadowOpacity = 0.4
        girlImageView.layer.shadowRadius = 10
        girlImageView.frame.size.width = 135
        girlImageView.frame.size.height = 135
        girlImageView.isUserInteractionEnabled = true
        girlImageView.backgroundColor = superLightLavender
        let tappedGirl = UITapGestureRecognizer(target: self, action: #selector(girlTapped))
        girlImageView.addGestureRecognizer(tappedGirl)
        view.addSubview(girlImageView)
        
        
        selectLabel.text = "CHOOSE"
        selectLabel.font = UIFont(name: "Menlo", size: 55)
        selectLabel.textAlignment = .center
        selectLabel.frame.size.width = 300
        selectLabel.frame.size.height = 100
        selectLabel.center.x = view.center.x
        selectLabel.textColor = .white
        selectLabel.center.y = view.center.y - 170
        view.addSubview(selectLabel)
    }

    
    @objc func boyTapped() {
        chosenGender = "male"
        let nameVC = NameViewController()
        nameVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(nameVC, animated: true)
    }
    
    @objc func girlTapped() {
        chosenGender = "female"
        let nameVC = NameViewController()
        nameVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(nameVC, animated: true)
    }


}
