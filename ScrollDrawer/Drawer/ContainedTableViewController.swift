import UIKit
import StiKitTableView

class ContainedTableViewController: ContainedViewController {

    let tableView = TableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        drivingScrollView = tableView
        
        if let cb = closeButton{
            view.addSubview(cb)
        }
    }
    
    private func setupView(){
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.preferredSeparatorColor = .clear
        tableView.preferredSeparatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }
    
}
