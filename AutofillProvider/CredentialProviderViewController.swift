import AuthenticationServices
import ObjectivePGP

class CredentialProviderViewController: ASCredentialProviderViewController {
    var currentIdentifier: ASCredentialServiceIdentifier? = nil

    var embeddedNavigationController: UINavigationController {
        return children.first as! UINavigationController
    }

    var directoriesViewController: ViewPasswordDirectoriesViewController {
        return embeddedNavigationController.viewControllers.first as! ViewPasswordDirectoriesViewController
    }

    override func prepareCredentialList(for serviceIdentifiers: [ASCredentialServiceIdentifier]) {
        currentIdentifier = serviceIdentifiers.first

        let url = serviceIdentifiers.first.flatMap { URL(string: $0.identifier) }
        if let domain = url?.host?.domainWithoutTld {
            directoriesViewController.searchBar.text = domain
            directoriesViewController.searchBar(directoriesViewController.searchBar, textDidChange: domain)
        }
    }

    override func viewDidLoad() {
        directoriesViewController.dataSource = DirectoriesTableViewDataSource(directories: fetchPasswordDirectories())
        directoriesViewController.navigator = self
    }

    override func provideCredentialWithoutUserInteraction(for credentialIdentity: ASPasswordCredentialIdentity) {
        guard let identifier = credentialIdentity.recordIdentifier else { return }
        let directory = Directory(name: identifier)
        let uname = Username(value: credentialIdentity.user)
        guard let password = decryptPassword(for: directory, with: uname) else { return }

        let passwordCredential = ASPasswordCredential(user: uname.withoutFileExtension, password: password)
        extensionContext.completeRequest(withSelectedCredential: passwordCredential)
    }
}

extension CredentialProviderViewController: PasswordSelectionDelegate {
    func selectedPassword(for directory: Directory, with uname: Username) {
        verifyFace { [weak self] in
            DispatchQueue.main.async {
                guard let password = decryptPassword(for: directory, with: uname) else { return }

                let passwordCredential = ASPasswordCredential(user: uname.withoutFileExtension, password: password)

                if let identifier = self?.currentIdentifier {
                    let credentialIdentity = ASPasswordCredentialIdentity(serviceIdentifier: identifier, user: uname.value, recordIdentifier: directory.name)
                    ASCredentialIdentityStore.shared.saveCredentialIdentities([credentialIdentity])
                }

                self?.extensionContext.completeRequest(withSelectedCredential: passwordCredential)
            }
        }

    }
}

extension CredentialProviderViewController: Navigator {
    func navigateToContentsOf(directory: Directory) {
        let vc = UIStoryboard(name: "FindPasswordFlow", bundle: nil).instantiateViewController(withIdentifier: "viewPasswords") as! ViewPasswordsViewController

        vc.directory = directory
        vc.unameDataSource = UsernamesDataSource(directory: directory, usernames: getUsernamesFor(directory: directory))
        vc.selectionDelegate = self

        embeddedNavigationController.pushViewController(vc, animated: true)
    }

    func navigateToPasswordsDirectory() {}
}

private extension String {
    var domainWithoutTld: String? {
        return self.replacingOccurrences(of: ".com", with: "")
            .replacingOccurrences(of: ".org", with: "")
            .replacingOccurrences(of: ".edu", with: "")
            .replacingOccurrences(of: ".net", with: "")
            .replacingOccurrences(of: ".gov", with: "")
    }
}
