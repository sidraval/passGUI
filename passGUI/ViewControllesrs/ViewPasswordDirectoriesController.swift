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

extension ViewPasswordDirectoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = self.dataSource.sections[indexPath.section]
        let directory = section.constituents[indexPath.row]

        perform(.showContentsOfDirectory) { viewPasswordsVC in
            viewPasswordsVC.directory = directory
        }
    }
}
