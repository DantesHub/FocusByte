

import UIKit
import TinyConstraints

class ThreeItemViewController: TwoItemViewController {
    var epicImageView: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    var epicItemLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Menlo-Bold", size: 24)
        return label
    }()
       var epicRareLabel: UILabel = {
        let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = brightPurple
         label.font = UIFont(name: "Menlo-Bold", size: 22)
         return label
     }()
    var diamondItemArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        diamondItemArray = MysteryItemLogic.getDiamondItems()
        inventoryArray.append(diamondItemArray[0])
        inventoryArray.append(diamondItemArray[1])
        inventoryArray.append(diamondItemArray[2])
        saveToFirebaseAndRealm()
        configureUI()
    }
    
    override func configureUI() {
        super.configureUI()
        commonItemImageView.image = UIImage(named: diamondItemArray[0])
        super.commonItemImageView.topAnchor.constraint(equalTo: youGotLabel.bottomAnchor, constant: 25).isActive = true
        commonItemImageView.updateConstraints()
        commonItemLabel.text = "\(diamondItemArray[0])"
        
        rareItemImageView.image = UIImage(named: diamondItemArray[1])
        rareItemLabel.text = "\(diamondItemArray[1])"
        rarityLabel.text = (itemBook[diamondItemArray[1]]!) == "Rare" ? "\(itemBook[diamondItemArray[1]]!)!" : "\(itemBook[diamondItemArray[1]]!)!!"
        rarityLabel.textColor = itemBook[diamondItemArray[1]]! == "Rare" ?  darkRed : diamond
        
        view.addSubview(epicImageView)
        epicImageView.image = UIImage(named: diamondItemArray[2])
        epicImageView.width(itemImageSize)
        epicImageView.height(itemImageSize)
        epicImageView.topToBottom(of: rareItemImageView, offset: 10)
        epicImageView.leadingToSuperview(offset: 10)
        
        view.addSubview(epicItemLabel)
        epicItemLabel.text = diamondItemArray[2]
        epicItemLabel.leftToRight(of: epicImageView, offset: 25)
        epicItemLabel.centerYAnchor.constraint(equalTo: epicImageView.centerYAnchor).isActive = true
        epicItemLabel.adjustsFontSizeToFitWidth = true
        epicItemLabel.numberOfLines = 2
        epicItemLabel.width(UIScreen.main.bounds.width * 0.5)
        epicItemLabel.minimumScaleFactor = 0.1
        
        view.addSubview(epicRareLabel)
        print(itemBook[diamondItemArray[2]]!)
        epicRareLabel.text = itemBook[diamondItemArray[2]]! == "Epic" ? "\(itemBook[diamondItemArray[2]]!)!!!" : "\(itemBook[diamondItemArray[2]]!)!!"
        epicRareLabel.textColor = itemBook[diamondItemArray[2]]! == "Epic" ? brightPurple : diamond
        epicRareLabel.topToBottom(of: epicItemLabel, offset: 5)
        epicRareLabel.leftToRight(of: epicImageView, offset: 25)
    }

}
