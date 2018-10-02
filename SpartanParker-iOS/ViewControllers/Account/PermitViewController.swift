//
//  PermitViewController.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 10/2/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

// MARK: -
class PermitViewController: ViewController {
    static let cellReuseIdentifier: String  = "PermitViewControllerCellReuseIdentifier"
    static let defaultCellHeight:   CGFloat = 180.0
    static let defaultCellPadding:  CGFloat = 10.0

    private let tableView: UITableView = create(UITableView(frame: .zero, style: .plain)) {
        $0.register(TableViewCell<ParkingPermitCardView>.self,
                    forCellReuseIdentifier: TableViewCell.cellReuseIdentifier)
        $0.backgroundColor        = .spartanLightGray
        $0.isScrollEnabled        = true
        $0.bounces                = true
        $0.alwaysBounceHorizontal = false
        $0.alwaysBounceVertical   = true
        $0.separatorStyle         = .none
        $0.allowsSelection        = false
    }

    private var permits: [ParkingPermit]?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .spartanLightGray
        tableView.dataSource = self
        tableView.delegate   = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.title = "Permits"
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate Implementation
extension PermitViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard permits != nil else { return 0 }
        return permits!.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PermitViewController.defaultCellHeight + (PermitViewController.defaultCellPadding * 2.0)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PermitViewController.cellReuseIdentifier,
            for: indexPath) as? TableViewCell<ParkingPermitCardView> else {
                fatalError("Invalid cell reuse identifier or reuse cell was not registered")
        }
        cell.customContentView.permit = permits![indexPath.row]
        return cell
    }
}
