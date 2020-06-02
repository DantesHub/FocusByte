import UIKit
var menuLabel = "Week"

class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
   lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = backgroundColor
    
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        return cv
    }()
    var categoryNames: [String] = [""]
    let cellId = "cellId"
    var tab = ""
    init(tab: String) {
        super.init(frame: UIScreen.main.bounds)
        self.tab = tab
    }
    
    func createCollectionView() {
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40).isActive = true
        //        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        collectionView.layer.cornerRadius = 25
        

    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.label.text = categoryNames[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tappedLabel(categoryName: categoryNames[indexPath.row])
    }
    func tappedLabel(categoryName: String) {
        switch categoryName {
        case "Week":
            menuLabel = "Week"
            NotificationCenter.default.post(name: Notification.Name(rawValue: weekKey), object: nil)
        case "Month":
            menuLabel = "Month"
            NotificationCenter.default.post(name: Notification.Name(rawValue: monthKey), object: nil)
        case "Year":
            menuLabel = "Year"
            NotificationCenter.default.post(name: Notification.Name(rawValue: yearKey), object: nil)
        case "Common":
            menuLabel = "Common"
            NotificationCenter.default.post(name: Notification.Name(rawValue: commonKey), object: nil)
        case "Rare":
            menuLabel = "Rare"
            NotificationCenter.default.post(name: Notification.Name(rawValue: rareKey), object: nil)
        case "Super R":
            menuLabel = "Super R"
            NotificationCenter.default.post(name: Notification.Name(rawValue: superKey), object: nil)
        case "Epic":
            menuLabel = "Epic"
            NotificationCenter.default.post(name: Notification.Name(rawValue: epicKey), object: nil)
        case "Pets":
            menuLabel = "Pets"
            NotificationCenter.default.post(name: Notification.Name(rawValue: petsKey), object: nil)
        case "Closet":
            menuLabel = "Closet"
            NotificationCenter.default.post(name: Notification.Name(rawValue: closetKey), object: nil)
        default:
            print("Default")
            return
        }
      }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if categoryNames.count == 3 {
            return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.height/1.5)
        } else {
            return CGSize(width: collectionView.frame.width/2.6, height: collectionView.frame.height/1.3)
        }
    }
    
    
}

class MenuCell: UICollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Menlo-Bold", size: 20)
        return label
    }()
        override var isSelected: Bool {
            didSet {
                self.backgroundColor = isSelected ? superLightLavender : darkPurple
                label.textColor = isSelected ?  .black : .white
    //            self.isUserInteractionEnabled = isSelected ? false : true
            }
        }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    
    func setupViews() {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        self.isUserInteractionEnabled = true
        self.backgroundColor = darkPurple
    }
}
