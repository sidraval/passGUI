//
//  CredentialProviderViewController.swift
//  AutofillProvider
//
//  Created by Sid Raval on 12/28/18.
//  Copyright © 2018 Sid Raval. All rights reserved.
//

import AuthenticationServices
import ObjectivePGP

class CredentialProviderViewController: ASCredentialProviderViewController, Navigator {
    var currentIdentifiers: [ASCredentialServiceIdentifier] = []

    func navigateToContentsOf(directory: Directory) {
        let vc = UIStoryboard(name: "FindPasswordFlow", bundle: nil).instantiateViewController(withIdentifier: "viewPasswords") as! ViewPasswordsViewController
        vc.directory = directory

        var unameDataSource = UsernamesDataSource(directory: directory, usernames: getUsernamesFor(directory: directory))

        vc.unameDataSource = unameDataSource
        vc.selectionDelegate = self

        embeddedNavigationController.pushViewController(vc, animated: true)
    }

    func navigateToPasswordsDirectory() {}

    var embeddedNavigationController: UINavigationController {
        return children.first as! UINavigationController
    }

    var directoriesViewController: ViewPasswordDirectoriesViewController {
        return embeddedNavigationController.viewControllers.first as! ViewPasswordDirectoriesViewController
    }

    override func prepareCredentialList(for serviceIdentifiers: [ASCredentialServiceIdentifier]) {
        currentIdentifiers = serviceIdentifiers
    }

    override func viewDidLoad() {
        directoriesViewController.dataSource = DirectoriesTableViewDataSource(directories: fetchPasswordDirectories())
        directoriesViewController.navigator = self

        let url = currentIdentifiers.first.flatMap { URL(string: $0.identifier) }
        if let domain = url?.host?.replacingOccurrences(of: "www.", with: "").replacingOccurrences(of: ".com", with: "") {
            directoriesViewController.searchBar.text = domain
            directoriesViewController.searchBar(directoriesViewController.searchBar, textDidChange: domain)
        }
    }

    /*
     Implement this method if your extension supports showing credentials in the QuickType bar.
     When the user selects a credential from your app, this method will be called with the
     ASPasswordCredentialIdentity your app has previously saved to the ASCredentialIdentityStore.
     Provide the password by completing the extension request with the associated ASPasswordCredential.
     If using the credential would require showing custom UI for authenticating the user, cancel
     the request with error code ASExtensionError.userInteractionRequired.
     */

    override func provideCredentialWithoutUserInteraction(for credentialIdentity: ASPasswordCredentialIdentity) {
        guard let identifier = credentialIdentity.recordIdentifier else { return }
        let directory = Directory(name: identifier)
        let uname = Username(value: credentialIdentity.user)
        guard let password = decryptPassword(for: directory, with: uname) else { return }
        let username = String(uname.value.dropLast(4))

        let passwordCredential = ASPasswordCredential(user: username, password: password)
        extensionContext.completeRequest(withSelectedCredential: passwordCredential, completionHandler: nil)
    }

    /*
     Implement this method if provideCredentialWithoutUserInteraction(for:) can fail with
     ASExtensionError.userInteractionRequired. In this case, the system may present your extension's
     UI and call this method. Show appropriate UI for authenticating the user then provide the password
     by completing the extension request with the associated ASPasswordCredential.

     override func prepareInterfaceToProvideCredential(for credentialIdentity: ASPasswordCredentialIdentity) {
     }
     */
}

extension CredentialProviderViewController: PasswordSelectionDelegate {
    func selectedPassword(for directory: Directory, with uname: Username) {
        guard let password = decryptPassword(for: directory, with: uname) else { return }
        let username = String(uname.value.dropLast(4))

        let passwordCredential = ASPasswordCredential(user: username, password: password)

        if let identifier = currentIdentifiers.first {
            let credentialIdentity = ASPasswordCredentialIdentity(serviceIdentifier: identifier, user: uname.value, recordIdentifier: directory.name)
            ASCredentialIdentityStore.shared.saveCredentialIdentities([credentialIdentity], completion: nil)
        }

        extensionContext.completeRequest(withSelectedCredential: passwordCredential, completionHandler: nil)
    }
}
