//
//  UserForm.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/21/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

import AWSCognitoIdentityProvider

// MARK: -
class UserForm: UIControl {
    // MARK: - UserForm Static Cell Constants
    static let defaultRowHeight:  CGFloat = 44.0
    static let horizontalPadding: CGFloat = 25.0
    static let verticalSpacing:   CGFloat = 32.0

    // MARK: -
    /// Table view for displaying TextFields.
    let tableView: UITableView = create(UITableView(frame: .zero, style: .grouped)) {
        $0.backgroundColor        = .spartanLightGray
        $0.isScrollEnabled        = true
        $0.bounces                = true
        $0.alwaysBounceHorizontal = false
        $0.alwaysBounceVertical   = true
        $0.separatorStyle         = .none
        $0.allowsSelection        = false
        $0.layer.backgroundColor = UIColor.spartanLightGray.cgColor
    }
    /// References to all input fields displayed in the static cells.
    var inputFields: [TextField]?
    /// Array of static cells to display on the table view form
    var cells: [TableViewCell<UIView>] = [TableViewCell<UIView>]()
    // Default constraint setup for each static table view cell.
    var defaultCellSetup: (_ superView: UIView, _ customView: UIView) -> Void = {
        let horizontalPadding: CGFloat = 25.0
        $1.translatesAutoresizingMaskIntoConstraints = false
        $1.topAnchor.constraint(equalTo: $0.topAnchor,
                                constant: (UserForm.verticalSpacing / 2.0)).isActive = true
        $1.bottomAnchor.constraint(equalTo: $0.bottomAnchor,
                                   constant: -(UserForm.verticalSpacing / 2.0)).isActive = true
        $1.leftAnchor.constraint(equalTo: $0.leftAnchor,
                                 constant: horizontalPadding).isActive = true
        $1.rightAnchor.constraint(equalTo: $0.rightAnchor,
                                  constant: -(horizontalPadding)).isActive = true
    }

    private(set) var tableViewBottomConstraint: NSLayoutConstraint!

    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not Used")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    private func setupView() {
        tableView.dataSource = self
        tableView.delegate   = self
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tableViewBottomConstraint = tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        tableViewBottomConstraint.isActive = true
        setupFields()
    }

    // MARK: - Form Setup
    /// should override and add form setup...
    func setupFields() {

    }

    func reloadForm() {
        tableView.reloadData()
    }
    /// Override to return all input fields
    /// - Returns:
    ///     - Dictionary containing all verified inputs from input fields.
    func getAllInputs() throws -> [String : AWSCognitoIdentityUserAttributeType]  {
        fatalError("Should override to serialize attributes.")
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource Implementation
extension UserForm: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UserForm.defaultRowHeight + UserForm.verticalSpacing
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
}
