import UIKit

class TransactionViewController: ViewController {
    private let tableView = create(UITableView()) {
        $0.backgroundColor              = .spartanLightGray
        $0.isScrollEnabled              = true
        $0.bounces                      = true
        $0.alwaysBounceHorizontal       = false
        $0.alwaysBounceVertical         = true
        $0.showsVerticalScrollIndicator = false
        $0.layer.backgroundColor        = UIColor.spartanLightGray.cgColor
    }
    private var transactions: [Transaction]?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .spartanLightGray
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reload()
    }
    /// Queries the user's transaction records and reloads the table view to display the results.
    /// TODO: should use pagination for displaying Tranasaction records
    private func reload() {
        _ = Transaction.getAll(userId: User.currentUser!.username!)
            .done { [weak self] transactions in
                self?.transactions = transactions
                self?.tableView.reloadData()
            }
            .catch { [weak self] error in
                debugPrintMessage(error)
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource Implementation
extension TransactionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = transactions?.count else { return 0 }
        return count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
