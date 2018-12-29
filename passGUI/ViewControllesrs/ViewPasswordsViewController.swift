import UIKit

class ViewPasswordsViewController: UIViewController {
    @IBOutlet var directoryName: UILabel!
    @IBOutlet var usernamesTable: UITableView!
    @IBOutlet var passwordField: UITextField!

    var directory: Directory!
    var unameDataSource: UsernamesDataSource!

    override func viewDidLoad() {
        usernamesTable.delegate = self
        setDataSource()

        directoryName.text = directory.name
    }

    func setDataSource() {
        switch getUsernamesFor(directory: directory) {
        case let .success(unames):
            unameDataSource = UsernamesDataSource(directory: directory, usernames: unames)
        case .failure:
            unameDataSource = UsernamesDataSource(directory: directory)
        }

        usernamesTable.dataSource = unameDataSource
    }
}

extension ViewPasswordsViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let directory = unameDataSource.directory
        let uname = unameDataSource.usernames[indexPath.row]

        verifyFace { [weak self] in
            DispatchQueue.main.async {
                let password = decryptPassword(for: directory, with: uname)
                self?.passwordField.text = password
                UIPasteboard.general.string = password
            }
        }
    }
}
