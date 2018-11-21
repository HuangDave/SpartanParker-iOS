//
//  AccountViewController.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 9/22/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

// MARK: -
private class AccountOptionCell: UITableViewCell {
    required init?(coder aDecoder: NSCoder) {
        fatalError("This should not be used.")
    }

    init(content: UIView) {
        super.init(style: .default, reuseIdentifier: "")
        backgroundColor             = .clear
        selectionStyle              = .none
        contentView.backgroundColor = .clear
        contentView.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.topAnchor.constraint(equalTo: topAnchor, constant: 5.0).isActive = true
        content.leftAnchor.constraint(equalTo: leftAnchor, constant: 10.0).isActive = true
        content.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5.0).isActive = true
        content.rightAnchor.constraint(equalTo: rightAnchor, constant: -10.0).isActive = true
    }
}

// MARK: -
class AccountViewController: ViewController {
    private enum AccountOption: Int, CaseIterable {
        case basicInformation = 0
        case passwordChange
        case vehicleInformation
        case permitInformation

        var description: String {
            switch self {
            case .basicInformation:   return "Basic Information"
            case .passwordChange:     return "Password Change"
            case .vehicleInformation: return "Vehicle Information"
            case .permitInformation:  return "Permit Information"
            }
        }
    }

    private let tableView: UITableView = create(UITableView(frame: .zero, style: .grouped)) {
        $0.backgroundColor              = .spartanLightGray
        $0.isScrollEnabled              = true
        $0.bounces                      = true
        $0.alwaysBounceHorizontal       = false
        $0.alwaysBounceVertical         = true
        $0.separatorStyle               = .none
        $0.showsVerticalScrollIndicator = false
        $0.layer.backgroundColor        = UIColor.spartanLightGray.cgColor
    }

    private var optionCells: [AccountOptionCell] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate   = self
        // generate the table cells to display the Account Options
        AccountOption.allCases.forEach { option in
            let optionButton = create(OptionButton(), setup: {
                $0.tag = option.rawValue
                $0.isUserInteractionEnabled = false
                $0.setTitle(option.description, for: .normal)
            })
            optionCells.append(AccountOptionCell(content: optionButton))
        }
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.title = "Account"
        tabBarController?.tabBar.isTranslucent = false
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate Implemenation
extension AccountViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionCells.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return optionCells[indexPath.row]
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let option = AccountOption(rawValue: indexPath.row) else { return }
        var destinationViewController: UIViewController?
        switch option {
        case .basicInformation:   return
        case .passwordChange:     destinationViewController = PasswordChangeViewController()
        case .vehicleInformation: destinationViewController = VehicleInformationViewController()
        case .permitInformation:  destinationViewController = PermitViewController()
        }
        navigationController?.pushViewController(destinationViewController!, animated: true)
    }
}
