//
//  Method3ViewController.swift
//  collection-view-understanding
//
//  Created by Dmytro Ostapchenko on 18.09.2023.
//

import Foundation
import UIKit

class _TableView: UITableView {
    private var sections: [_TableSection] = []
    private var currecntIndex = 0

    func _removeSection(at index: Int, animation: UITableView.RowAnimation) {
        sections.remove(at: index)
        self.deleteSections(IndexSet(arrayLiteral: index), with: animation)
    }
    
    func _appendSections(
        _ sections: [_TableSection],
        from index: Int? = nil,
        animation: UITableView.RowAnimation = .none
    ) {
        self.sections.insert(contentsOf: sections, at: index ?? self.sections.count)
        self.insertSections(
            IndexSet(arrayLiteral: index ?? sections.count),
            with: animation
        )
    }
    
    func setExtraDelegate(_ delegate: UITableViewDelegate) {
        
    }
    
    func setExtraDataSource(_ dataSource: UITableViewDataSource) {
        
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension _TableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].content.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section]
            .content[indexPath.row]
            .handler(tableView, indexPath)
    }
}

struct _TableSection {
    init(content: [_TableCellHandler]) {
        self.content = content
    }
    
    init(handler: _TableCellHandler, count: Int) {
        self.content = Array(repeating: handler, count: count)
    }
    
    struct CountContent {
        let handler: _TableCellHandler
        let count: Int
    }
    
    init(handlers: [CountContent]) {
        self.content = Array(
            handlers.map {
                return Array(repeating: $0.handler, count: $0.count)
            } .joined()
        )
    }
    
    let content: [_TableCellHandler]

    func header(view: UIView) -> Self {
        return self
    }
}

struct _TableCellHandler {
    let height: CGFloat
    let handler: (UITableView, IndexPath) -> UITableViewCell
    
    init(
        height: CGFloat = .greatestFiniteMagnitude,
        handler: @escaping (UITableView, IndexPath) -> UITableViewCell
    ) {
        self.height = height
        self.handler = handler
    }
}

class Method3ViewController: UIViewController {
    private let tableView = _TableView(frame: .zero, style: .insetGrouped)
    private var cell1References: TogglableTableViewCell!
    
    private var dataSourceArray: [IndexPath: Any] = [
        IndexPath(row: 0, section: 0): ToggleData(title: "test", isOn: true)
    ]
    
    struct ToggleData {
        let title: String
        let isOn: Bool
    }
    
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
        
        tableView._appendSections([
            .init(content: [
                _TableCellHandler { tableView, indexPath in
                    let cell = tableView.dequeueReusableCell(withIdentifier: "toggleCell", for: indexPath) as! TogglableTableViewCell
                    self.cell1References = cell
                    let data = (self.dataSourceArray[indexPath] as? ToggleData)
                    cell.configure(title: data?.title ?? "failure", isOn: data?.isOn ?? false, changeToggle: {
                        [weak self] value in
                        self?.tableView._appendSections([
                            .init(content: [
                                .init(handler: { _,_ in
                                    let cell = tableView.dequeueReusableCell(withIdentifier: "toggleCell", for: indexPath) as! TogglableTableViewCell
                                    cell.configure(title: "title1", isOn: false, changeToggle: {
                                        [weak self] value in
                                        self?.tableView._removeSection(at: 1, animation: .fade)
                                    })
                                    return cell
                                })
                            ])
                        ])
                    })
                    return cell
                }
            ]),
            .init(content: [
                _TableCellHandler { tableView, indexPath in
                    let cell = tableView.dequeueReusableCell(withIdentifier: "toggleCell", for: indexPath) as! TogglableTableViewCell
                    cell.configure(title: "title1", isOn: false, changeToggle: {
                        [weak self] value in
                        self?.tableView._removeSection(at: 1, animation: .fade)
                    })
                    return cell
                }
            ]),
            .init(content: [
                _TableCellHandler { tableView, indexPath in
                    let cell = tableView.dequeueReusableCell(withIdentifier: "toggleCell", for: indexPath) as! TogglableTableViewCell
                    cell.configure(title: "title1", isOn: false, changeToggle: {
                        [weak self] value in
                        print(value)
                        self?.cell1References?.switchLink.setOn(true, animated: true)
                    })
                    return cell
                }
            ])
        ])
        
//        tableView.setExtraDelegate(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.frame
    }
}
