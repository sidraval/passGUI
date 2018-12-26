import Perform
import UIKit

extension Segue {
    static var showContentsOfDirectory: Segue<ViewPasswordsViewController> {
        return .init(identifier: "showContentsOfDirectory")
    }
}

class ViewPasswordsViewController: UIViewController {
    @IBOutlet var directoryName: UILabel!
    @IBOutlet var usernamesTable: UITableView!
    @IBOutlet var passwordField: UITextField!

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
        let directory = unameDataSource.directory
        let uname = unameDataSource.usernames[indexPath.row]

        verifyFace { [weak self] in
            DispatchQueue.main.async {
                self?.passwordField.text = decryptPassword(for: directory, with: uname)
            }
        }
    }
}
