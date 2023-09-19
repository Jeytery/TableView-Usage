//
//  ManyStateCellsViewController.swift
//  collection-view-understanding
//
//  Created by Dmytro Ostapchenko on 18.09.2023.
//

import Foundation
import UIKit


class ManyStateCellsViewController: UIViewController {
    private let tableView = _TableView(frame: .zero, style: .insetGrouped)
    
    private var dataSourceArray: [Bool] = [
        true,
        false,
        false,
        true,
        true,
        true,
        true
    ]
    
    private var dataSourceArray2: [String] = [
        "dima",
        "vanya",
        "andrey"
    ]

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
        
        let handler = _TableCellHandler { tableView, indexPath in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "toggleCell",
                for: indexPath
            ) as! TogglableTableViewCell
            cell.configure(
                title: "title1",
                isOn: self.dataSourceArray[indexPath.row] ?? false,
                changeToggle: {
                    [weak self] value in
                    self?.dataSourceArray[indexPath.row].toggle()
                })
           return cell
        }
        
        let handler2 = _TableCellHandler { tableView, indexPath in
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as! ActionbuttonTableViewCell
            cell.configure(title: self.dataSourceArray2[indexPath.row - self.dataSourceArray.count], action: {
                print(indexPath)
                self.tableView._appendSections([
                    .init(content: [
                        handler
                    ])
                ])
            })
            return cell
        }
        
        tableView._appendSections(
            [
                _TableSection(handlers: [
                    .init(handler: handler, count: dataSourceArray.count),
                    .init(handler: handler2, count: dataSourceArray2.count),
                ])
            ],
            animation: .none
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.frame
    }
}

