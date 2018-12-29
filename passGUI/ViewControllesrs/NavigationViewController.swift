import Perform
import UIKit

class NavigationController: UIViewController, Navigator {
    override func viewDidLoad() {
        navigateToInitialDestination()
    }

    func navigateToContentsOf(directory: Directory) {
        let vc = UIStoryboard(name: "FindPasswordFlow", bundle: nil).instantiateViewController(withIdentifier: "viewPasswords") as! ViewPasswordsViewController
        vc.directory = directory

        navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToInitialDestination() {
        let hasCloned = try? listDocumentsSubdirectories(for: "repositories")

        switch hasCloned {
        case .some:
            skipOnboarding()
        case .none:
            perform(.startOnboarding)
        }
    }

    private func skipOnboarding() {
        var dataSource: DirectoriesTableViewDataSource

        switch fetchPasswordDirectories() {
        case let .success(ds):
            dataSource = DirectoriesTableViewDataSource(directories: ds)
        case .failure:
            dataSource = DirectoriesTableViewDataSource()
        }

        perform(.skipOnboarding) { vc in
            vc.navigator = self
            vc.dataSource = dataSource
        }
    }
}
