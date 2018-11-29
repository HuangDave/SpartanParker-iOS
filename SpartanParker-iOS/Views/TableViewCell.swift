//
//  TableViewCell.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 10/2/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class TableViewCell<CustomContentView: UIView>: UITableViewCell {
    class var cellReuseIdentifier: String { return "TableViewCellReuseIdentifier" }

    private(set) var customContentView: CustomContentView!

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not used")
    }

    init(content: CustomContentView,
         setup: ((_ superView: UIView, _ customView: CustomContentView) -> Void)? = nil) {
        super.init(style: .default, reuseIdentifier: TableViewCell.cellReuseIdentifier)
        customContentView = content
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(customContentView)
        // if no custom setup is specified, set the customContentView to fill the cell's contentView
        if setup == nil {
            customContentView.translatesAutoresizingMaskIntoConstraints = false
            customContentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            customContentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            customContentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            customContentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        } else {
            setup!(contentView, customContentView)
        }
    }
}
