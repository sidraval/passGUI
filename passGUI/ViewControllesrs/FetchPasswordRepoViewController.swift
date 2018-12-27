import SwiftGit2
import UIKit

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

    func cloneAndProceed() {
        let mUsername = username.text
        let mPassword = password.text
        let mFromURL = repoURL.text.flatMap { URL(string: $0) }
        guard let fromURL = mFromURL,
            let uname = mUsername,
            let pword = mPassword else {
            print("Not a valid repositoryURL...")
            return
        }

        fetchAndPersistRepository(from: fromURL, to: archiveURL, username: uname, password: pword)
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
            cloneAndProceed()
            password.resignFirstResponder()
        default:
            break
        }

        return true
    }
}
