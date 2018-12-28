import Perform
import Result
import SwiftGit2
import UIKit

extension Segue {
    static var startOnboarding: Segue<FetchPasswordRepoViewController> {
        return .init(identifier: "startOnboarding")
    }
}

class FetchPasswordRepoViewController: UIViewController {
    @IBOutlet var repoURL: UITextField!
    @IBOutlet var repoURLView: UIView!

    @IBOutlet var username: UITextField!
    @IBOutlet var usernameView: UIView!

    @IBOutlet var password: UITextField!
    @IBOutlet var passwordView: UIView!

    override func viewDidLoad() {
        let repoTapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(focusRepoURLField)
        )
        repoURLView.addGestureRecognizer(repoTapRecognizer)

        let usernameTapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(focusUsernameField)
        )
        usernameView.addGestureRecognizer(usernameTapRecognizer)

        let passwordTapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(focusPasswordField)
        )
        passwordView.addGestureRecognizer(passwordTapRecognizer)
    }

    @objc func focusRepoURLField(_: UITapGestureRecognizer) {
        repoURL.becomeFirstResponder()
    }

    @objc func focusUsernameField(_: UITapGestureRecognizer) {
        username.becomeFirstResponder()
    }

    @objc func focusPasswordField(_: UITapGestureRecognizer) {
        password.becomeFirstResponder()
    }

    func attemptCloneRepo() -> Result<Repository, NSError> {
        let mUsername = username.text
        let mPassword = password.text
        let mFromURL = repoURL.text.flatMap { URL(string: $0) }
        guard let fromURL = mFromURL,
            let uname = mUsername,
            let pword = mPassword else {
            return .failure(NSError())
        }

        return fetchAndPersistRepository(from: fromURL, to: archiveURL, username: uname, password: pword)
    }

    func showPasswordDirectories() {
        perform(.endOnboarding)
    }
}

extension FetchPasswordRepoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case repoURL:
            username.becomeFirstResponder()
        case username:
            password.becomeFirstResponder()
        case password:
            switch attemptCloneRepo() {
            case .success:
                showPasswordDirectories()
            case let .failure(e):
                print("Failed to clone repository", e)
            }
        default:
            break
        }

        return true
    }
}
