//
//  TagTableViewTableViewController.swift
//  Test
//
//  Created by Dante Kim on 5/21/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit
import TinyConstraints

var tagTitles = [TagCell(title: "unset", selected: false, color: .gray), TagCell(title: "Study", selected: false, color: .red),TagCell(title: "Read", selected: true, color: darkGreen),TagCell(title: "Cook", selected: false, color: .yellow)]
class TagTableView: UIView {
   let tableView = UITableView()
     //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       // Here write down you logic to dismiss controller
        self.removeFromSuperview()
    }
    
    func setUpViews() {
        self.backgroundColor = UIColor.rgbColor(r: 0, g: 0, b: 0, a: 0.5)
        self.addSubview(tableView)
        tableView.dataSource = self
        tableView.register(TagViewCell.self, forCellReuseIdentifier: K.tagCell)
        tableView.edgesToSuperview(insets: TinyEdgeInsets(top: -150, left: 60, bottom: 550
            , right: 60))
//        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.tableView.transform = CGAffineTransform(translationX: 0, y: 325)
                }) { (_) in }
        tableView.rowHeight = 50
    }
    
}

extension TagTableView: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tagCell = tagTitles[indexPath.row]
        let cell = TagViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: K.tagCell, color: tagCell.color, title: tagCell.title)
        cell.accessoryType = tagCell.selected ? .checkmark : .none
        return cell
    }
}

extension TagTableView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

