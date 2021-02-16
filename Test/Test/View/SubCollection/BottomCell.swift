import UIKit

class BottomCell: BaseCell {
    let one = UIImageView()
    let two = UIImageView()
    let three = UIImageView()
    let four = UIImageView()
    let five = UIImageView()
    let review = UILabel()
    let pic = UIImageView()
    override func setUpViews() {
        let stars = [one, two, three, four,five]
        for star in stars {
            star.image = UIImage(named: "star2filled")?.withTintColor(gold).resize(targetSize: CGSize(width: 30, height: 30))
            self.addSubview(star)
            star.top(to: self, offset: 20)
        }
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.cornerRadius = 15
        
        three.centerX(to: self)
        two.trailingToLeading(of: three, offset: -14)
        one.trailingToLeading(of: two, offset: -14)
        four.leadingToTrailing(of: three, offset: 14)
        five.leadingToTrailing(of: four, offset: 14)
        self.addSubview(pic)
        pic.leading(to: self, offset: 15)
        pic.bottom(to: self, offset: -20)

        pic.height(50)
        pic.width(50)
        pic.clipsToBounds = true
        pic.layer.cornerRadius = 25
        pic.image = UIImage(named: "pic1")
        self.addSubview(review)
      
        review.leadingToTrailing(of: pic, offset: 10)
        review.trailing(to: self, offset: -10)
        review.topToBottom(of: three, offset: UIDevice.current.hasNotch ? 20:  15)
        review.textAlignment = .center
        review.numberOfLines = 3
        review.font = UIFont(name: "Menlo", size: 14)
        review.text = "\"I have always used them because I liked the way they looked. Last job change I used\""
    }
    
}
