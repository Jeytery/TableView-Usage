//
//  ActionButtonTableViewCell.swift
//  collection-view-understanding
//
//  Created by Dmytro Ostapchenko on 18.09.2023.
//

import Foundation
import UIKit

class ActionbuttonTableViewCell: UITableViewCell {
    private let button = UIButton()
    private var actionHandler: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        button.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        button.setTitleColor(.systemBlue, for: .normal)
        self.isUserInteractionEnabled = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapButton() {
        actionHandler?()
    }
    
    func configure(title: String, action: @escaping () -> Void) {
        button.setTitle(title, for: .normal)
        self.actionHandler = action
    }
}
