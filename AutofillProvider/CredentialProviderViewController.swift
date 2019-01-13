import AuthenticationServices
import ObjectivePGP

class CredentialProviderViewController: ASCredentialProviderViewController {
    var embeddedNavigationController: UINavigationController {
        return children.first as! UINavigationController
    }

    var directoriesViewController: ViewPasswordDirectoriesViewController {
        return embeddedNavigationController.viewControllers.first as! ViewPasswordDirectoriesViewController
    }

    lazy var credentialProvider = CredentialProvider(extensionContext: self.extensionContext)

    override func prepareCredentialList(for serviceIdentifiers: [ASCredentialServiceIdentifier]) {
        credentialProvider.identifier = serviceIdentifiers.first

        let url = serviceIdentifiers.first.flatMap { URL(string: $0.identifier) }
        directoriesViewController.showResultsMatching(url?.host?.sanitizedDomain)
    }

    override func viewDidLoad() {
        directoriesViewController.dataSource = DirectoriesTableViewDataSource(directories: fetchPasswordDirectories())
        directoriesViewController.navigator = self
    }

    override func provideCredentialWithoutUserInteraction(for credentialIdentity: ASPasswordCredentialIdentity) {
        credentialProvider.credentials(for: credentialIdentity)
    }
}

extension CredentialProviderViewController: PasswordSelectionDelegate {
    func selectedPassword(for directory: Directory, with uname: Username) {
        verifyFace { [weak self] in
            DispatchQueue.main.async {
                self?.credentialProvider.persistAndProvideCredentials(in: directory, with: uname)
            }
        }
    }
}

extension CredentialProviderViewController: Navigator {
    func navigateToContentsOf(directory: Directory) {
        let vc = UIStoryboard.viewPasswordsVC

        vc.directory = directory
        vc.unameDataSource = UsernamesDataSource(directory: directory, usernames: getUsernamesFor(directory: directory))
        vc.selectionDelegate = self

        embeddedNavigationController.pushViewController(vc, animated: true)
    }

    func navigateToPasswordsDirectory() { /* noop */ }
    func navigateToFetchRepository() {
        /* noop */
    }
}

private extension String {
    var sanitizedDomain: String? {
        return replacingOccurrences(of: ".com", with: "")
            .replacingOccurrences(of: ".org", with: "")
            .replacingOccurrences(of: ".edu", with: "")
            .replacingOccurrences(of: ".net", with: "")
            .replacingOccurrences(of: ".gov", with: "")
            .replacingOccurrences(of: "www.", with: "")
    }
}
