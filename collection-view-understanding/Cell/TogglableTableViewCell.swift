//
//  TogglableTableViewCell.swift
//  collection-view-understanding
//
//  Created by Dmytro Ostapchenko on 18.09.2023.
//

import UIKit

class TogglableTableViewCell: UITableViewCell {
    private var didChangeSwitch: ((Bool) -> Void)?

    @IBOutlet weak private var titleLabel: UILabel!
    
    @IBOutlet weak var switchLink: UISwitch!
    
    @IBAction func switchDidChangeValue(_ sender: UISwitch) {
        didChangeSwitch?(sender.isOn)
    }
    
    func configure(title: String, isOn: Bool, changeToggle: @escaping (Bool) -> Void) {
        didChangeSwitch = changeToggle
        titleLabel.text = title
        switchLink.isOn = isOn
    }
}
