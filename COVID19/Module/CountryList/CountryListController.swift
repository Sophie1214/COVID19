//
//  ContryListController.swift
//  COVID19
//
//  Created by Fei Su on 2020-04-06.
//  Copyright © 2020 Fei Su. All rights reserved.
//

import UIKit
import SwiftyJSON
import EasyPeasy
import SVProgressHUD

enum SortOptions: String, CaseIterable {
    case totalCase = "Total Case"
    case newCase = "New Case"
    case totalDeath = "Total Death"
    case totalRecovered = "Total Recovered"
}

class CountryListController: UITableViewController {
      
    @IBOutlet weak var searchBar: UISearchBar!
    var list: [Country] = []
    var countryList: [Country] {
        return Array(DBManager.shared.getTodayCountryList())
    }
    let customRefresh = UIRefreshControl()
    
    var currentSort: (String, String) = ("", "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Cases by Country"
        
        SVProgressHUD.show(withStatus: "loading")
        SVProgressHUD.dismiss(withDelay: 5)
        
        customRefresh.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = customRefresh
        
        self.list = self.countryList
        refresh()
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(showMenu(_:)))
    }
    
    @objc private func refresh(){
        WebManager.getCountryList { [weak self] (countryList) in
            guard let self = self else { return }
            self.list = self.countryList
            SVProgressHUD.dismiss()
            self.customRefresh.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    @objc private func showMenu(_ barButtonItem: UIBarButtonItem){
        
        var actions: [PopMenuAction] = []
        
        for option in SortOptions.allCases {
            var imageName: String = "down"
            var image: UIImage = UIImage(named: imageName)!
            if option.rawValue == currentSort.0 && currentSort.1 == "down"{
                imageName = "up"
                image = UIImage(named: imageName)!
            }
            let action = PopMenuDefaultAction(title: option.rawValue, image: image, color: UIColor.darkText) { [weak self] (action) in
                guard let self = self else { return }
                self.currentSort = (action.title!, imageName)
                self.sortList(title: self.currentSort.0, ascending: imageName == "up")
            }
            actions.append(action)
        }
        
        let controller = PopMenuViewController(sourceView: barButtonItem, actions: actions)
        
        // Customize appearance
        controller.appearance.popMenuFont = UIFont(name: "HelveticaNeue", size: 16)!
        controller.appearance.popMenuColor.backgroundColor = .solid(fill: .white)
        controller.appearance.popMenuBackgroundStyle = .none()
        controller.appearance.popMenuActionHeight = 35
        controller.appearance.popMenuCornerRadius = 10
        // Configure options
        controller.shouldDismissOnSelection = true
        controller.delegate = self
        
        controller.didDismiss = { selected in
            print("Menu dismissed: \(selected ? "selected item" : "no selection")")
        }
        
        // Present menu controller
        present(controller, animated: true, completion: nil)
    }
    
    private func sortList(title: String, ascending: Bool){
        switch title {
        case SortOptions.totalCase.rawValue:
            self.list.sort(by: { ascending ? $0.totalCases < $1.totalCases : $0.totalCases > $1.totalCases})
        case SortOptions.newCase.rawValue:
            self.list.sort(by: { ascending ? $0.gainedCases < $1.gainedCases : $0.gainedCases > $1.gainedCases})
        case SortOptions.totalDeath.rawValue:
            self.list.sort(by: { ascending ? $0.totalDeaths < $1.totalDeaths : $0.totalDeaths > $1.totalDeaths})
        case SortOptions.totalRecovered.rawValue:
            self.list.sort(by: { ascending ? $0.totalRecovered < $1.totalRecovered : $0.totalRecovered > $1.totalRecovered})
        default:
            break
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! CountryListCell2
        let country = list[indexPath.section]
        var number = 0
        var title = ""
        switch indexPath.row {
        case 0:
            title = "Total Cases"
            number = country.totalCases
        case 1:
            title = "New Cases"
            number = country.gainedCases
        case 2:
            title = "Total Deaths"
            number = country.totalDeaths
        case 3:
            title = "Total Recovered"
            number = country.totalRecovered
        default:
            break
        }
        cell.populateContent(row: indexPath.row, number: number, title: title)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.967497238, green: 0.967497238, blue: 0.967497238, alpha: 1)
        
        let label = UILabel()
        label.text = "\(section + 1). \(list[section].name)"
        label.textColor = UIColor.darkText
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 16)!
        view.addSubview(label)
        label.easy.layout(Left(8), Top(8), Bottom(8), Right(8))
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
}

extension CountryListController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            list = list.filter { (country) -> Bool in
                return country.name.contains(searchText)
            }
        } else {
            list = countryList
        }
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

extension CountryListController: PopMenuViewControllerDelegate {
    func popMenuDidSelectItem(_ popMenuViewController: PopMenuViewController, at index: Int) {
        
    }
}
