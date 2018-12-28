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

    var dataSource: DirectoriesTableViewDataSource!

    override func viewDidLoad() {
        searchBar.delegate = self
        tableView.delegate = self
        setDataSource()
    }

    func setDataSource() {
        switch fetchPasswordDirectories() {
        case let .success(ds):
            dataSource = DirectoriesTableViewDataSource(directories: ds)
        case .failure:
            dataSource = DirectoriesTableViewDataSource()
        }

        tableView.dataSource = dataSource
    }
}

extension ViewPasswordDirectoriesViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = dataSource.filteredSections[indexPath.section]
        let directory = section.constituents[indexPath.row]

        perform(.showContentsOfDirectory) { viewPasswordsVC in
            viewPasswordsVC.directory = directory
        }
    }
}

extension ViewPasswordDirectoriesViewController: UISearchBarDelegate {
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        dataSource.showDirectories(matching: searchText)
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_: UISearchBar) {
        dataSource.showDirectories(matching: "")
        tableView.reloadData()
    }
}
