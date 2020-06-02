//
//  StoreController.swift
//  Test
//
//  Created by Dante Kim on 4/11/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit
import TinyConstraints
class StoreController: UIViewController {
    //MARK: - Properties & Views
    var mysteryBox: UIView!
    let mysteryBoxImage = UIImage(named: "commonmysterybox")
    var mysteryBoxImageView: UIImageView!
    var mysteryBoxLabel = UILabel()
    var chestBoxLabel = UILabel()
    var clothesBoxLabel = UILabel()
    var chestBox: UIView!
    var clothes: UIView!
    var delegate: ContainerController!
    var purseImageView: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "greenpurse")
        iv.sizeToFit()
        return iv
    }()
    var sneakerImageView: UIImageView = {
        let iv = UIImageView()
         iv.translatesAutoresizingMaskIntoConstraints = false
         iv.image = #imageLiteral(resourceName: "sneakers")
         iv.sizeToFit()
         return iv
     }()
    var beanieImageView: UIImageView = {
          let iv = UIImageView()
           iv.translatesAutoresizingMaskIntoConstraints = false
           iv.image = #imageLiteral(resourceName: "bluebeanie")
           iv.sizeToFit()
           return iv
       }()
    var contentViewSize: CGSize {
        get {
            var height: CGFloat = 0.0
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1920, 2208:
                    height = 50
                    //("iphone 8plus")
                case 2436:
                    height = -50
                    //print("IPHONE X, IPHONE XS, IPHONE 11 PRO")
                case 2688:
                    height = -50
                    //print("IPHONE XS MAX, IPHONE 11 PRO MAX")
                case 1792:
                     height = 0
                    //print("IPHONE XR, IPHONE 11")
                default:
                    height = 110
                }
            }
            return CGSize(width: self.view.frame.width, height: self.view.frame.height + height)
        }
    }
    
    //MARK: -Views
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.backgroundColor = backgroundColor
        view.frame = self.view.bounds
        view.contentSize = contentViewSize
        return view
    }()
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.frame.size = contentViewSize
        return view
    }()
    
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = backgroundColor
    }
    
    //MARK: - Helper Functions
    func createBox(color: UIColor, handler: Selector?) -> UIView {
        let inputView = UIView()
        inputView.backgroundColor = color
        inputView.layer.cornerRadius = 25
        scrollView.addSubview(inputView)
        inputView.translatesAutoresizingMaskIntoConstraints = false
        inputView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        inputView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        inputView.layer.shadowColor = UIColor.black.cgColor
        inputView.layer.shadowOffset = CGSize(width: 10, height: 10)
        inputView.layer.shadowRadius = 6
        inputView.layer.shadowOpacity = 0.7
        return inputView
    }
    
    func configureUI() {
        configureNavigationBar(color: backgroundColor, isTrans: false)
        view.backgroundColor = backgroundColor
        navigationItem.title = "Shop"
        navigationItem.leftBarButtonItem =  UIBarButtonItem(image: resizedMenuImage?.withTintColor(.white), style: .plain, target: self, action: #selector(handleMenuToggle))
        mysteryBox = createBox(color: darkPurple, handler: #selector(mysteryTapped))
        mysteryBox.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        let mysteryTap = UITapGestureRecognizer(target: self, action: #selector(mysteryTapped))
        mysteryBox.addGestureRecognizer(mysteryTap)
        mysteryBoxImageView = UIImageView(image: mysteryBoxImage)
        
        mysteryBox.addSubview(mysteryBoxImageView)
        mysteryBoxImageView.translatesAutoresizingMaskIntoConstraints = false
        mysteryBoxImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        mysteryBoxImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        mysteryBoxImageView.centerXAnchor.constraint(lessThanOrEqualTo: mysteryBox.centerXAnchor, constant: 80).isActive = true
        mysteryBoxImageView.topAnchor.constraint(equalTo: mysteryBox.topAnchor, constant: 35).isActive = true
        
        
        mysteryBoxLabel.textColor = .white
        mysteryBoxLabel.text = "Mystery\nBoxes"
        mysteryBoxLabel.applyDesign()
        mysteryBox.addSubview(mysteryBoxLabel)
        mysteryBoxLabel.topAnchor.constraint(equalTo: mysteryBox.topAnchor, constant: 15).isActive = true
        mysteryBoxLabel.leftAnchor.constraint(equalTo: mysteryBox.leftAnchor, constant: 30).isActive = true
        
        chestBox = createBox(color: brightPurple, handler: #selector(mysteryTapped))
        chestBox.topAnchor.constraint(equalTo: mysteryBox.bottomAnchor, constant: 30).isActive = true
        
        chestBoxLabel.textColor = .white
        chestBoxLabel.text = "Upgrade\nChests"
        chestBoxLabel.applyDesign()
        chestBox.addSubview(chestBoxLabel)
        chestBoxLabel.topAnchor.constraint(equalTo: chestBox.topAnchor, constant: 15).isActive = true
        chestBoxLabel.leftAnchor.constraint(equalTo: chestBox.leftAnchor, constant: 30).isActive = true
        
        clothes = createBox(color: superLightLavender, handler: #selector(mysteryTapped))
        clothes.topAnchor.constraint(equalTo: chestBox.bottomAnchor, constant: 30).isActive = true
        
        let clothesTapped = UITapGestureRecognizer(target: self, action: #selector(tappedClothes))
        clothes.addGestureRecognizer(clothesTapped)
        clothesBoxLabel.text = "Avatar\nClothes"
        clothesBoxLabel.textColor = brightPurple
        clothesBoxLabel.applyDesign()
        clothes.addSubview(clothesBoxLabel)
        clothesBoxLabel.topAnchor.constraint(equalTo: clothes.topAnchor, constant: 15).isActive = true
        clothesBoxLabel.leftAnchor.constraint(equalTo: clothes.leftAnchor, constant: 30).isActive = true
        clothesBoxLabel.addSubview(purseImageView)
        purseImageView.trailingAnchor.constraint(equalTo: clothes.trailingAnchor, constant: -15).isActive = true
        purseImageView.topAnchor.constraint(equalTo: clothes.topAnchor, constant: 0).isActive = true
        
        clothes.addSubview(sneakerImageView)
        sneakerImageView.topToBottom(of: clothesBoxLabel, offset: 25)
        sneakerImageView.leadingAnchor.constraint(equalTo: clothes.leadingAnchor,constant: 40).isActive = true
        
        clothes.addSubview(beanieImageView)
        beanieImageView.topToBottom(of: purseImageView, offset: 0)
        beanieImageView.trailingAnchor.constraint(equalTo: clothes.trailingAnchor, constant: -45).isActive = true
        
    }
    
    //MARK: - Handlers
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func mysteryTapped() {
        self.navigationController?.pushViewController(MysteryViewController(), animated: true)
    }
    
    @objc func tappedClothes() {
          self.navigationController?.pushViewController(AvatarStoreController(), animated: true)
    }
    
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    
}

