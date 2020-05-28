//
//  GifController.swift
//  Test
//
//  Created by Dante Kim on 5/10/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit
import FLAnimatedImage

 var color: UIColor?
class GifController: UIViewController {
    var imageData: Data?
   
    let gifView: FLAnimatedImageView = {
        let iv = FLAnimatedImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        switch name {
        case "Common Box":
            imageData = try! Data(contentsOf: Bundle.main.url(forResource: "commonBox", withExtension: "gif")!)
            color = backgroundColor
        case "Gold Box":
            imageData = try! Data(contentsOf: Bundle.main.url(forResource: "goldBox", withExtension: "gif")!)
            color = goldBox
        case "Diamond Box":
            imageData = try! Data(contentsOf: Bundle.main.url(forResource: "diamondBox", withExtension: "gif")!)
             color = diamond
        default:
            return
        }
        gifView.animatedImage = FLAnimatedImage(animatedGIFData: imageData)
        
        view.addSubview(gifView)
        gifView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gifView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.gifView.loopCompletionBlock = {_ in
            self.gifView.stopAnimating()
            var controller = NewitemViewController()
            switch name {
            case "Common Box":
                controller = NewitemViewController()
            case "Gold Box":
                controller = TwoItemViewController()
            case "Diamond Box":
                controller = ThreeItemViewController()
            default:
                print("")
            }
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
    }
}
