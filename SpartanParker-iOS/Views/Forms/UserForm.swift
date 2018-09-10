//
//  UserForm.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/21/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

// MARK: -
protocol UserFormDelegate: class {
    func userFormDidSelectContinue(_ userForm: UserForm)
}

// MARK: -
class UserFormCell: UITableViewCell {

    static let cellReuseIdentifier: String = "UserFormCellReuseIdentifier"

    required init?(coder aDecoder: NSCoder) {
        fatalError("This should not be used.")
    }

    init(content: UIView) {
        super.init(style: .default, reuseIdentifier: UserFormCell.cellReuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(content)

        let horizontalPadding: CGFloat = 25.0
        content.translatesAutoresizingMaskIntoConstraints = false
        content.topAnchor.constraint(equalTo: topAnchor,
                                     constant: (UserForm.verticalSpacing / 2)).isActive = true
        content.bottomAnchor.constraint(equalTo: bottomAnchor,
                                        constant: -(UserForm.verticalSpacing / 2)).isActive = true
        content.leftAnchor.constraint(equalTo: leftAnchor,
                                      constant: horizontalPadding).isActive = true
        content.rightAnchor.constraint(equalTo: rightAnchor,
                                       constant: -(horizontalPadding)).isActive = true
    }
}

// MARK: -
class UserForm: UIControl {
    static let defaultRowHeight:  CGFloat = 44.0
    static let horizontalPadding: CGFloat = 25.0
    static let verticalSpacing:   CGFloat = 32.0

    weak var delegate: UserFormDelegate?
    /// Table view for displaying TextFields.
    private(set) var tableView: UITableView!
    /// References to all input fields displayed in the static cells.
    var inputFields: [TextField]?
    /// Array of static cells to display on the table view form
    var cells: [UserFormCell] = [UserFormCell]()
    /// Continue button is placed at the end of the user form in the last section of the table view.
    let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .spartanBlue
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font    = UIFont.boldSystemFont(ofSize: 16)
        button.layer.masksToBounds = true
        button.layer.cornerRadius  = 14.0
        button.addTarget(self, action: #selector(userDidSelectContinue), for: .touchUpInside)
        return button
    }()

    // MARK: - Initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    private func commonInit() {
        tableView = UITableView(frame: frame, style: .grouped)
        tableView.dataSource             = self
        tableView.delegate               = self
        tableView.backgroundColor        = .spartanLightGray
        tableView.isScrollEnabled        = true
        tableView.bounces                = true
        tableView.alwaysBounceHorizontal = false
        tableView.alwaysBounceVertical   = true
        tableView.separatorStyle         = .none
        tableView.allowsSelection        = false
        tableView.layer.backgroundColor = UIColor.spartanLightGray.cgColor

        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true

        setupForm()
    }

    // MARK: -

    /// should override and add form setup...
    func setupForm() {
        reloadForm()
    }

    func reloadForm() {
        tableView.reloadData()
    }

    /// Override to return all input fields
    /// - Returns:
    ///     - Dictionary containing all verified inputs from input fields.
    ///     - Not nil if an input field was invalid or empty.
    func getAllInputs() throws -> [String: String] {
        return [:]
    }

    @objc func userDidSelectContinue(sender: UIButton) {
        delegate?.userFormDidSelectContinue(self)
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
