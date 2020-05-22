//
//  TagViewCell.swift
//  Test
//
//  Created by Dante Kim on 5/21/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit
import TinyConstraints

class TagViewCell: UITableViewCell {
    //MARK: - Properties
    var color: UIColor = .gray
    var title: String = ""
    var titleLabel = UILabel()
     //MARK: - Init
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, color: UIColor, title: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.color = color
        self.title = title
        configureCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Functinos
    func configureCellUI() {
        let circleLayer = CAShapeLayer();
        circleLayer.path = UIBezierPath(ovalIn: CGRect(x: contentView.center.x - 140, y: contentView.center.y - 15, width: 25, height: 25)).cgPath;
        circleLayer.fillColor = color.cgColor
        contentView.layer.addSublayer(circleLayer)
        titleLabel.font = UIFont(name: "Menlo", size: 15)
        titleLabel.text = title
        titleLabel.sizeToFit()
        contentView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60).isActive = true
        titleLabel.centerY(to: contentView)
    }
}
