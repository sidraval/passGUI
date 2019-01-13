import Perform
import UIKit

class NavigationController: UIViewController, Navigator {
    override func viewDidLoad() {
        navigateToInitialDestination()
    }

    func navigateToContentsOf(directory: Directory) {
        let vc = UIStoryboard.viewPasswordsVC
        let unameDataSource = UsernamesDataSource(
            directory: directory,
            usernames: getUsernamesFor(directory: directory).recover([])
        )

        vc.directory = directory
        vc.unameDataSource = unameDataSource
        vc.selectionDelegate = vc

        navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToFetchRepository() {
        let vc = UIStoryboard.fetchPasswordRepoVC
        vc.navigator = self

        navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToPasswordsDirectory() {
        skipOnboarding()
    }

    func navigateToInitialDestination() {
        let hasCloned = try? listDocumentsSubdirectories(for: "repositories")

        switch hasCloned {
        case .some:
            skipOnboarding()
        case .none:
            perform(.startOnboarding) { vc in
                vc.navigator = self
            }
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
