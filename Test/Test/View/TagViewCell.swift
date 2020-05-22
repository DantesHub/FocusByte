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
    var color = "gray"
    var title: String = ""
    var titleLabel = UILabel()
     //MARK: - Init
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, color: String, title: String) {
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
       
        self.selectionStyle = .none
        titleLabel.font = UIFont(name: "Menlo", size: 15)
        titleLabel.text = title
        titleLabel.sizeToFit()
        contentView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60).isActive = true
        titleLabel.centerY(to: contentView)
    let circleLayer = CAShapeLayer();
    circleLayer.path = UIBezierPath(ovalIn: CGRect(x: contentView.center.x - 140, y: titleLabel.center.y + 7, width: 20, height: 20)).cgPath;
        circleLayer.fillColor = K.getColor(color: color).cgColor
    if color != "white" {
    contentView.layer.addSublayer(circleLayer)
    }
    }
}
