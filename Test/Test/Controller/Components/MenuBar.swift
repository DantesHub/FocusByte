import UIKit

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
    var categoryNames: [String] = ["Week", "Month", "Year"]
    let cellId = "cellId"
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        collectionView.layer.cornerRadius = 25
        
        let selectedIndexPath = NSIndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: [])
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
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
            NotificationCenter.default.post(name: Notification.Name(rawValue: weekKey), object: nil)
        case "Month":
            NotificationCenter.default.post(name: Notification.Name(rawValue: monthKey), object: nil)
        case "Year":
            NotificationCenter.default.post(name: Notification.Name(rawValue: yearKey), object: nil)
        default:
            print("Default")
            return
        }
      }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.height/1.5)
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
