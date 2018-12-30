import UIKit

class ViewPasswordsViewController: UIViewController {
    @IBOutlet var directoryName: UILabel!
    @IBOutlet var usernamesTable: UITableView!
    @IBOutlet var passwordField: UITextField!

    weak var selectionDelegate: PasswordSelectionDelegate?
    var directory: Directory!
    var unameDataSource: UsernamesDataSource!

    override func viewDidLoad() {
        usernamesTable.delegate = self
        usernamesTable.dataSource = unameDataSource

        directoryName.text = directory.name
    }
}

extension ViewPasswordsViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let directory = unameDataSource.directory
        let uname = unameDataSource.usernames[indexPath.row]

        selectionDelegate?.selectedPassword(for: directory, with: uname)
    }
}
