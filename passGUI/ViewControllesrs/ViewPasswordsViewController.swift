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

    var directory: Directory!
    lazy var unameDataSource = UsernamesDataSource(directory: self.directory)

    override func viewDidLoad() {
        usernamesTable.dataSource = unameDataSource
        usernamesTable.delegate = self

        directoryName.text = directory.name
    }
}

extension ViewPasswordsViewController: UITableViewDelegate {
}
