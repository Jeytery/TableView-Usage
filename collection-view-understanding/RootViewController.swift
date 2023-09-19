//
//  RootViewController.swift
//  collection-view-understanding
//
//  Created by Dmytro Ostapchenko on 18.09.2023.
//

import Foundation
import UIKit

class RootViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private let dataArray = [
        "standard realization",
        "custom tableView",
        "many state cells"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = self.view.frame
    }
}

extension RootViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(Method1ViewController(), animated: true)
        case 1:
            navigationController?.pushViewController(Method3ViewController(), animated: true)
        case 2:
            navigationController?.pushViewController(ManyStateCellsViewController(), animated: true)
        default: break
        }
    }
}
