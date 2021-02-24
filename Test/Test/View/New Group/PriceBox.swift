


import UIKit
import TinyConstraints
class PriceBox: UIView {
    let priceLabel = UILabel()
    let smallLabel = UILabel()
    var selected = false
    let title = UILabel()
    var yearly = false
    var height: CGFloat = 0
    var width: CGFloat = 0
    let view = UIView()
    let label = UILabel()
    var life = false
    override init(frame: CGRect) {
       super.init(frame: frame)
       setupView()
     }
     
     //initWithCode to init view from xib or storyboard
     required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        self.layoutMargins = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
       setupView()
     }
     
     //common func to init our view
     func setupView() {
        self.addSubview(priceLabel)
        self.addSubview(title)
        self.addSubview(smallLabel)
        self.layer.cornerRadius = 15
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 5
        if !isIpod {
            priceLabel.font = UIFont(name: "Menlo-Bold", size: 25)
            smallLabel.font = UIFont(name: "Menlo", size: 12)
            title.font = UIFont(name: "Menlo", size: 16)
        } else {
            priceLabel.font = UIFont(name: "Menlo-Bold", size: 20)
            smallLabel.font = UIFont(name: "Menlo", size: 12)
            title.font = UIFont(name: "Menlo", size: 14)
        }
 

        priceLabel.top(to: self, offset: 5)
        priceLabel.trailing(to: self, offset: -10)
        smallLabel.topToBottom(of: priceLabel)
        smallLabel.trailing(to: self, offset: -10)
        
        title.numberOfLines = 1;
        title.minimumScaleFactor = 0.5
        title.adjustsFontSizeToFitWidth = true
        title.leading(to: self, offset: 20)
        title.centerY(to: self)
     }
    
    func configure() {
        if selected {
            self.backgroundColor = brightPurple
            priceLabel.textColor = .white
            title.textColor = .white
            smallLabel.textColor = .white
            view.backgroundColor = .white
            label.textColor = .black

        } else {
            self.backgroundColor = .white
            priceLabel.textColor = .black
            title.textColor = .black
            smallLabel.textColor = .black
            view.backgroundColor = brightPurple
            label.textColor = .white
        } 
  
    }
    func configureLife() {
        if life {
            smallLabel.removeFromSuperview()
            priceLabel.removeFromSuperview()
            self.addSubview(priceLabel)
            priceLabel.font = UIFont(name: "Menlo-Bold", size: 25)
            priceLabel.centerY(to: self)
            priceLabel.trailing(to: self, offset: -10)
            
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.trailingToLeading(of: priceLabel, offset: -8)
            view.leadingToTrailing(of: title, offset: 8)
            view.centerY(to: self)
            view.height(self.height * 0.50)
            view.layer.cornerRadius = 10
            label.text = "LIMITED TIME!"
            label.font = UIFont(name: "Menlo-Bold", size: 14)
            label.adjustsFontSizeToFitWidth = true
            view.addSubview(label)
            label.centerY(to: view)
            label.leading(to: view, offset: 5)
            label.trailing(to: view, offset: -5)
        }
    }
}
