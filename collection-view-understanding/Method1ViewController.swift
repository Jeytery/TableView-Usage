//
//  Method1ViewController.swift
//  collection-view-understanding
//
//  Created by Dmytro Ostapchenko on 18.09.2023.
//

import Foundation
import UIKit

// button -> toggle the section 1 first on/off

class Method1ViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    struct ToggleData {
        let title: String
        let isOn: Bool
    }
    
    private var dataSourceArray: [IndexPath: Any] = [
        IndexPath(row: 0, section: 0): ToggleData(title: "test", isOn: true)
    ]
    
    private var cell1References: TogglableTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "titleCell")
        tableView.register(
            UINib(nibName: "TogglableTableViewCell", bundle: nil),
            forCellReuseIdentifier: "toggleCell"
        )
        tableView.register(
            ActionbuttonTableViewCell.self,
            forCellReuseIdentifier: "buttonCell")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = self.view.frame
    }
}

extension Method1ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "toggleCell", for: indexPath) as! TogglableTableViewCell
                self.cell1References = cell
                let data = (self.dataSourceArray[indexPath] as? ToggleData)
                cell.configure(title: data?.title ?? "failure", isOn: data?.isOn ?? false, changeToggle: {
                    [weak self] value in
                    print(value)
                })
                return cell
            }
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "toggleCell", for: indexPath) as! TogglableTableViewCell
                cell.configure(title: "cell1", isOn: true, changeToggle: {
                    [weak self] value in
                    print(value)
                })
                return cell
            }
        }
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as! ActionbuttonTableViewCell
                cell.configure(title: "click me", action: {
                    self.cell1References.switchLink.setOn(false, animated: true)
                    self.dataSourceArray[IndexPath(row: 0, section: 0)] = ToggleData(title: "click me", isOn: false)
                })
                return cell
            }
        }
        return UITableViewCell()
    }
}
