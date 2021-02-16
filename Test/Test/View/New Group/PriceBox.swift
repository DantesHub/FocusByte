


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

    override init(frame: CGRect) {
       super.init(frame: frame)
       setupView()
     }
     
     //initWithCode to init view from xib or storyboard
     required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
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
        priceLabel.font = UIFont(name: "Menlo-Bold", size: 35)
        smallLabel.bottom(to:self, offset: UIDevice.current.hasNotch ? -35 : isIpod ? -15 :-20)
        smallLabel.font = UIFont(name: "Menlo", size: 12)
        smallLabel.centerX(to: self)
        priceLabel.centerX(to: self)
        priceLabel.bottomToTop(of: smallLabel, offset: 5)
        
        title.bottomToTop(of: priceLabel, offset: 0)
        title.font = UIFont(name: "Menlo", size: 15)
        title.centerX(to:self)

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
        if yearly {
            self.addSubview(view)
            view.height(height)
            view.width(width)
            view.top(to: self, offset: 7)
            view.trailing(to: self, offset: -7)
            view.layer.cornerRadius = 5
            label.font = UIFont(name: "Menlo-Bold", size: 12)
            label.text = "45% Off"
            view.addSubview(label)
            label.center(in: view)
        }
    }
}
