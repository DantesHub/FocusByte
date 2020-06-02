import UIKit

class SectionHeaderViewCell: UICollectionViewCell {

    internal let mainView = UIView()
    internal var title = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func initializeUI() {

        self.backgroundColor = UIColor.clear
        self.addSubview(mainView)
        mainView.backgroundColor = UIColor.clear

        mainView.addSubview(title)
        title.text = "Pick nameA"
        title.font = UIFont(name: "Menlo-Bold", size: 25)
        title.textAlignment = .left
        title.textColor = .white
        title.numberOfLines = 1

    }


    internal func createConstraints() {
        mainView.leadingToSuperview()
        mainView.trailingToSuperview()
        mainView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        title.centerY(to: mainView)
        title.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20).isActive = true
    }


    func setTitle(title: String)  {

        self.title.text = title
    }


    static var reuseId: String {
        return NSStringFromClass(self)
    }

}
