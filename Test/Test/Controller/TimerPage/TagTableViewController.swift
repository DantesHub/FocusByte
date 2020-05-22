//
//  TagTableViewTableViewController.swift
//  Test
//
//  Created by Dante Kim on 5/21/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit
import TinyConstraints
import RealmSwift

var tagDictionary = [Tag]()
class TagTableView: UIView{
    //MARK: - Views + Properties
    var results: Results<User>!
    var isSearchBarEmpty: Bool {
      return searchBar.text?.isEmpty ?? true
    }
     var filteredTags = [Tag]()
     let tableView = UITableView()
    var searchBar: UISearchBar! = UISearchBar()
    var isFiltering: Bool = false
    
     //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        overrideUserInterfaceStyle = .light
        setUpTagDictionary()
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
        tableView.layer.cornerRadius = 25
        tableView.edgesToSuperview(insets: TinyEdgeInsets(top: -150, left: 50, bottom: 550
            , right: 50))
//        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.tableView.transform = CGAffineTransform(translationX: 0, y: 325)
                }) { (_) in }
        tableView.rowHeight = 50
        searchBar.placeholder = "Search For Tag"
        searchBar.sizeToFit()
        searchBar.delegate = self
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.font = UIFont(name: "Menlo", size: 12)
        //SearchBar Placeholder
        let textFieldInsideUISearchBarLabel = textFieldInsideUISearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideUISearchBarLabel?.font = UIFont(name: "Menlo", size: 12)
        tableView.tableHeaderView = searchBar
    }
    func setUpTagDictionary() {
        tagDictionary = [Tag]()
        results = uiRealm.objects(User.self)
        for result  in results {
            if result.isLoggedIn == true {
                tagDictionary = result.tagDictionary.map{ $0 }
            }
        }
        setUpViews()
    }
    
    
    func filterContentForSearchText(_ searchText: String) {
      filteredTags = tagDictionary.filter { (tag: Tag) -> Bool in
        return tag.name.lowercased().contains(searchText.lowercased())
      }
      tableView.reloadData()
    }
}

extension TagTableView: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          if isFiltering {
          return filteredTags.count
        }
        return tagDictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tagCell: Tag
        if isFiltering {
            tagCell = filteredTags[indexPath.row]
        } else {
            tagCell = tagDictionary[indexPath.row]
        }
        let cell = TagViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: K.tagCell, color: tagCell.color, title: tagCell.name)
       
        cell.accessoryType = tagCell.selected ? .checkmark : .none
        return cell
    }
}

extension TagTableView: UISearchBarDelegate {

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       filterContentForSearchText(searchBar.text!)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isFiltering = !isSearchBarEmpty
        if isFiltering == false {
            tableView.reloadData()
        } else {
            filterContentForSearchText(searchBar.text!)
            tableView.reloadData()
        }
    }
    

}

