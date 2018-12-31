import UIKit

class ViewPasswordDirectoriesViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!

    var dataSource: DirectoriesTableViewDataSource!
    weak var navigator: Navigator?

    override func viewDidLoad() {
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = dataSource
    }

    func showResultsMatching(_ string: String?) {
        guard let s = string else { return }

        searchBar.text = s
        searchBar(searchBar, textDidChange: s)
    }
}

extension ViewPasswordDirectoriesViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = dataSource.filteredSections[indexPath.section]
        let directory = section.constituents[indexPath.row]

        navigator?.navigateToContentsOf(directory: directory)
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
