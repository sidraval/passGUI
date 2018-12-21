import Perform
import UIKit

extension Segue {
    static var showPasswordDirectories: Segue<ViewPasswordDirectoriesViewController> {
        return .init(identifier: "showPasswordDirectories")
    }
}

class ViewPasswordDirectoriesViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    let dataSource = DirectoriesTableViewDataSource()

    override func viewDidLoad() {
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
}

extension ViewPasswordDirectoriesViewController: UITableViewDelegate {}
