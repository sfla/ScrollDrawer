import UIKit
import StiKitTableView

class TableViewController: BaseViewController {

    let tableView = TableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.preferredSeparatorColor = .clear
        tableView.preferredSeparatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }
}
