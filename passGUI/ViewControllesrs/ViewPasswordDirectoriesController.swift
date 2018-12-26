import Perform
import UIKit

extension Segue {
    static var showPasswordDirectories: Segue<ViewPasswordDirectoriesViewController> {
        return .init(identifier: "showPasswordDirectories")
    }
}

class ViewPasswordDirectoriesViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!

    let dataSource = DirectoriesTableViewDataSource()

    override func viewDidLoad() {
        self.searchBar.delegate = self
        self.tableView.dataSource = dataSource
        self.tableView.delegate = self
    }
}

extension ViewPasswordDirectoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = self.dataSource.filteredSections[indexPath.section]
        let directory = section.constituents[indexPath.row]

        perform(.showContentsOfDirectory) { viewPasswordsVC in
            viewPasswordsVC.directory = directory
        }
    }
}

extension ViewPasswordDirectoriesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.dataSource.showDirectories(matching: searchText)
        self.tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dataSource.showDirectories(matching: "")
        self.tableView.reloadData()
    }
}
