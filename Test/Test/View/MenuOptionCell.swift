//
//  MenuOptionCell.swift
//  Test
//
//  Created by Dante Kim on 4/8/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit

class MenuOptionCell: UITableViewCell {
    //MARK: - Properties
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = false
        iv.backgroundColor = .clear
        return iv
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor =  .white
        label.font = UIFont(name: "Menlo-Bold", size: 18)
        label.text = "Sample text"
        return label
    }()
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = superLightLavender
        selectionStyle = .none
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 12).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Handlers

}
