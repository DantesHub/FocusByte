//
//  InventoryController.swift
//  Test
//
//  Created by Dante Kim on 5/13/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit
import RealmSwift
import TinyConstraints

var shirt = ""
var shoe = ""
var backpack = ""
var pants = ""
var glasses = ""

class InventoryController: UIViewController {
    //MARK: - properties
    var results: Results<User>!
    var delegate: ContainerControllerDelegate!
    var displayArray = [DisplayItem]()
    lazy var collectionView: UICollectionView = {
        let columnLayout = ColumnFlowLayout(
            cellsPerRow: 3,
            minimumInteritemSpacing: 25,
            minimumLineSpacing: 20,
            sectionInset: UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        )
      
        columnLayout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: columnLayout)
        cv.backgroundColor = backgroundColor
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false

        return cv
    }()

     var menuBar: MenuBar!
    var whichTab = ""
    struct Section {
        var sectionName: String
        var rowData: [DisplayItem]
    }
    var sections = [Section]()
    
    //MARK: - init
    init(whichTab: String = "") {
        super.init(nibName: nil, bundle: nil)
        self.whichTab = whichTab
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    override func viewWillAppear(_ animated: Bool) {
        getRealmData()
        if shoes {
            addObservers()
            setUpTabBar()
        } else if pets {
           addObservers()
            setUpTabBar()
        } else {
            setUpTabBar()
            getItems()
            addObservers()
        }
 
    }
    
    
    //MARK: - Helper Functions
    private final func getRealmData() {
        results = uiRealm.objects(User.self)
            for result  in results {
                if result.isLoggedIn == true {
                    shirt = result.shirt ?? "none"
                    shoe = result.shoes ?? "none"
                    pants = result.pants ?? "none"
                    backpack = result.backpack ?? "none"
                    glasses = result.glasses ?? "none"
                }
            }
    }
    @objc final func updateToCloset(notificaton: NSNotification) {
        var topArray = [DisplayItem]()
        var pantsArray = [DisplayItem]()
        var backpackArray = [DisplayItem(count: -1, name: "none", rarity: "None")]
        var shoeArray = [DisplayItem]()
        var glassesArray = [DisplayItem(count: -1, name: "none", rarity: "None")]
        for item in allClothes {
            var count = -1
            if inventoryArray.contains(item.key) {
                if topBook.contains(where: {$0.key == item.key}) {
                    if shirt == item.key {
                        count = -2
                    }
                    topArray.append(DisplayItem(count: count, name: item.key, rarity: "None"))
                } else if pantsBook.contains(where: {$0.key == item.key}) {
                    if pants == item.key {
                        count = -2
                    }
                      pantsArray.append(DisplayItem(count: count, name: item.key, rarity: "None"))
                } else if shoeBook.contains(where: {$0.key == item.key}) {
                    print(shoe)
                    if shoe == item.key {
                        count = -2
                    }
                shoeArray.append(DisplayItem(count: count, name: item.key, rarity: "None"))
                } else if backpackBook.contains(where: {$0.key == item.key}) {
                    if backpack == item.key {
                        count = -2
                    }
                backpackArray.append(DisplayItem(count: count, name: item.key, rarity: "None"))
                } else if frameBook.contains(where: {$0.key == item.key}) {
                    if glasses == item.key {
                        count = -2
                    }
                    glassesArray.append(DisplayItem(count: count, name: item.key, rarity: "None"))
                }
            }
            sections = [ Section(sectionName: "Glasses", rowData: glassesArray),Section(sectionName: "Shirts/Sweaters", rowData: topArray), Section(sectionName: "Pants", rowData: pantsArray), Section(sectionName: "Hats", rowData: pantsArray) ,Section(sectionName: "Shoes", rowData: shoeArray),
               Section(sectionName: "Backpacks", rowData: backpackArray)]
        }
     configureUI()
     collectionView.reloadData()
    }
    private final func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(InventoryController.updateToCommon(notificaton:)), name: NSNotification.Name(rawValue: commonKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(InventoryController.updateToRare(notificaton:)), name: NSNotification.Name(rawValue: rareKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(InventoryController.updateToSuper(notificaton:)), name: NSNotification.Name(rawValue: superKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(InventoryController.updateToEpic(notificaton:)), name: NSNotification.Name(rawValue: epicKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(InventoryController.updateToPets(notificaton:)), name: NSNotification.Name(rawValue: petsKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(InventoryController.updateToCloset(notificaton:)), name: NSNotification.Name(rawValue: closetKey), object: nil)
     


    }

    @objc final func updateToCommon(notificaton: NSNotification) {
        getItems()
    }
    @objc final func updateToRare(notificaton: NSNotification) {
        displayArray = [DisplayItem]()
        if menuLabel == "Rare" {
            for item in inventoryArray {
                if itemBook[item] == "Rare" {
                    if let i = displayArray.firstIndex(where: {$0.name == item}) {
                        displayArray[i].count += 1
                    } else {
                        let displayItem = DisplayItem(count: 1, name: item, rarity: "Rare")
                        displayArray.append(displayItem)
                    }
                }
            }
        }
        collectionView.reloadData()
    }
    @objc final func updateToSuper(notificaton: NSNotification) {
        displayArray = [DisplayItem]()
        if menuLabel == "Super R" {
            for item in inventoryArray {
                if itemBook[item] == "Super Rare" {
                    if let i = displayArray.firstIndex(where: {$0.name == item}) {
                        displayArray[i].count += 1
                    } else {
                        let displayItem = DisplayItem(count: 1, name: item, rarity: "Super Rare")
                        displayArray.append(displayItem)
                    }
                }
            }
        }
        collectionView.reloadData()
    }
    @objc final func updateToEpic(notificaton: NSNotification) {
        displayArray = [DisplayItem]()
        if menuLabel == "Epic" {
               for item in inventoryArray {
                   if itemBook[item] == "Epic" {
                       if let i = displayArray.firstIndex(where: {$0.name == item}) {
                           displayArray[i].count += 1
                       } else {
                           let displayItem = DisplayItem(count: 1, name: item, rarity: "Epic")
                           displayArray.append(displayItem)
                       }
                   }
               }
           }
           collectionView.reloadData()
    }
    @objc final func updateToPets(notificaton: NSNotification) {
        displayArray = [DisplayItem]()
        if menuLabel == "Pets" {
            for item in inventoryArray {
                if petBook.contains(item) {
                    if let i = displayArray.firstIndex(where: {$0.name == item}) {
                        displayArray[i].count += 1
                    } else {
                        displayArray.append(DisplayItem(count: 1, name: item, rarity: itemBook[item]!))
                    }
                    
                }
            }
        }
        configureUI()
        collectionView.reloadData()
    }

    func getItems() {
        displayArray = [DisplayItem]()
        if menuLabel == "Common" {
            for item in inventoryArray {
                if itemBook[item] == "Common" {
                    if let i = displayArray.firstIndex(where: {$0.name == item}) {
                        displayArray[i].count += 1
                    } else {
                        let displayItem = DisplayItem(count: 1, name: item, rarity: "Common")
                        displayArray.append(displayItem)
                    }
                }
            }
        }
        configureUI()
        collectionView.reloadData()
    }
    
    func configureUI() {
        configureNavigationBar(color: backgroundColor, isTrans: false)
        navigationItem.title = "Inventory"
         navigationItem.leftBarButtonItem =  UIBarButtonItem(image: resizedMenuImage?.withTintColor(.white), style: .plain, target: self, action: #selector(handleMenuToggle))
        view.backgroundColor = backgroundColor
        parent?.title = "Inventory"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.register(InventoryCell.self, forCellWithReuseIdentifier: K.inventoryCell)
        collectionView.register(SectionHeaderViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderViewCell.reuseId)
        collectionView.topToBottom(of: menuBar, offset: 20)
        collectionView.leadingToSuperview(offset: 20)
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        collectionView.bottomToSuperview(offset: -15)
    }
    
    private func setUpTabBar() {
             menuBar = MenuBar(tab: self.whichTab)
            menuBar.categoryNames = ["Common", "Rare", "Super R", "Epic", "Pets", "Closet"]
            menuLabel = "Common"
            menuBar.createCollectionView()
            menuBar.tab = whichTab
          view.addSubview(menuBar)
          menuBar.translatesAutoresizingMaskIntoConstraints = false
          menuBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
          menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
          menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
          menuBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        var selectedIndexPath = NSIndexPath(item: 0, section: 0)

        if pets {
            selectedIndexPath = NSIndexPath(item: 4, section: 0)
            pets = false
            menuLabel = "Pets"
            NotificationCenter.default.post(name: Notification.Name(rawValue: petsKey), object: nil)
        } else if shoes {
            selectedIndexPath = NSIndexPath(item: 5, section: 0)
            shoes = false
            menuLabel = "Closet"
                NotificationCenter.default.post(name: Notification.Name(rawValue: closetKey), object: nil)
        }
        menuBar.collectionView.reloadData()
        menuBar.collectionView.layoutIfNeeded()
        menuBar.collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
        menuBar.collectionView.scrollToItem(at: selectedIndexPath as IndexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
      }
    
    //MARK: - Handlers
      @objc func handleMenuToggle() {
          delegate?.handleMenuToggle(forMenuOption: nil)
      }
}

extension InventoryController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if menuLabel != "Closet" {
            switch menuLabel {
            case "Pets":
            return petBook.count
            case "Common":
                return 112
            case "Rare":
                return 54
            case "Epic":
                return 15
            case "Super R":
                return 30
            default:
                return 100
            }
        } else {
            if sections[section].rowData.count > 12 {
                return sections[section].rowData.count
            } else {
                return 12
            }
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if menuLabel == "Closet" {
            return 5
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                     layout collectionViewLayout: UICollectionViewLayout,
                     referenceSizeForHeaderInSection section: Int) -> CGSize{
        return menuLabel == "Closet" ? CGSize(width: CGFloat(signOf: collectionView.frame.size.width, magnitudeOf: CGFloat(30)), height: 30):CGSize(width: 0, height: 0) // you can change here
    }
    
  // MARK: Header
       func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

           switch kind {
           case UICollectionView.elementKindSectionHeader:

               let cell = self.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderViewCell.reuseId, for: indexPath) as! SectionHeaderViewCell
               cell.initializeUI()
               cell.createConstraints()
               cell.setTitle(title: self.sections[indexPath.section].sectionName)
               return cell
           default:  fatalError("Unexpected element kind")
           }
       }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.inventoryCell, for: indexPath) as! InventoryCell
        if menuLabel != "Closet" {
            if displayArray.indices.contains(indexPath.row){
                cell.setImage(image: UIImage(named: displayArray[indexPath.row].name) ?? UIImage(named: "hot dog")!)
                 cell.imgName = displayArray[indexPath.row].name
                 cell.count = displayArray[indexPath.row].count
                 cell.rarity = displayArray[indexPath.row].rarity
                 return cell
             } else {
                 cell.setImage(image: UIImage())
                 cell.imgName = "blank"
                 return cell
             }
        } else {
            if sections[indexPath.section].rowData.indices.contains(indexPath.row) {
                cell.setImage(image: UIImage(named: sections[indexPath.section].rowData[indexPath.row].name)!)
                cell.imgName = sections[indexPath.section].rowData[indexPath.row].name
                cell.count = sections[indexPath.section].rowData[indexPath.row].count
                cell.rarity = "None"
                return cell
            } else {
                cell.setImage(image: UIImage())
                cell.imgName = "blank"
                return cell
            }
           
        }
    }
    
}


