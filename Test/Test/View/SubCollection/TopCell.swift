import UIKit

class TopCell: BaseCell {
    var imageView = UIImageView()
    var title = UILabel()
    var desc = UILabel()
    var imgName = ""

    override func setUpViews() {
        super.setUpViews()
        self.addSubview(imageView)
        self.addSubview(title)
        self.addSubview(desc)
    }
    func configureUI() {
        self.backgroundColor = lightGray
        imageView.centerX(to: self)
        imageView.top(to: self, offset: 0)
        imageView.width(self.frame.width * 0.80)
        imageView.height(self.frame.height * 0.70)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: imgName)
        
        title.topToBottom(of: imageView, offset: -20)
        title.centerX(to: self)
        title.font = UIFont(name: "Menlo-Bold", size: 24)
        
        desc.topToBottom(of: title)
        desc.leading(to: self,offset: 50)
        desc.trailing(to: self, offset: -50)
        desc.textAlignment = .center
        desc.numberOfLines = 2
        desc.textColor = .darkGray
        desc.font = UIFont(name: "Menlo", size: 12)
    }
}
