import Perform
import UIKit

extension Segue {
    static var showContentsOfDirectory: Segue<ViewPasswordsViewController> {
        return .init(identifier: "showContentsOfDirectory")
    }
}

class ViewPasswordsViewController: UIViewController {
    @IBOutlet weak var directoryName: UILabel!
    @IBOutlet weak var usernamesTable: UITableView!
    @IBOutlet weak var passwordField: UITextField!

    var directory: Directory!
    lazy var unameDataSource = UsernamesDataSource(directory: self.directory)

    override func viewDidLoad() {
        usernamesTable.dataSource = unameDataSource
        usernamesTable.delegate = self

        directoryName.text = directory.name
    }
}

extension ViewPasswordsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let directory = self.unameDataSource.directory
        let uname = self.unameDataSource.usernames[indexPath.row]

        passwordField.text = decryptPassword(for: directory, with: uname)
    }
}
