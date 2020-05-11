//
//  GifController.swift
//  Test
//
//  Created by Dante Kim on 5/10/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit

class GifController: UIViewController {
    let gifView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .white
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        gifView.loadGif(name: "diamondBox")
        view.addSubview(gifView)
        gifView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gifView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        print(lastFrame)
    }
}
