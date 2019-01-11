import UIKit

extension UIStoryboard {
    static var detectPGPKeyVC: DetectPGPKeyViewController {
        return UIStoryboard(name: "Onboarding", bundle: nil).instantiateInitialViewController() as! DetectPGPKeyViewController
    }
}

fileprivate let copiedToKeychainSuccess = "✅ Key copied to keychain"
fileprivate let removedFromDiskSuccess = "✅ Key removed from disk"

class DetectPGPKeyViewController: UIViewController {
    @IBOutlet var copiedToKeychainLabel: UILabel!
    @IBOutlet var removedFromDiskLabel: UILabel!

    var fileWatcher: FileWatcher!
    var navigator: Navigator!

    override func viewDidLoad() {
        fileWatcher = FileWatcher()
        NotificationCenter.default.addObserver(self, selector: #selector(handleSuccessfulKeyWrite), name: .NSFileHandleReadToEndOfFileCompletion, object: nil)
    }

    @objc func handleSuccessfulKeyWrite() {
        switch moveKeyToKeychainThenDelete() {
        case .success:
            self.copiedToKeychainLabel.text = copiedToKeychainSuccess
            self.removedFromDiskLabel.text = removedFromDiskSuccess
            let alert = pgpKeyPasswordAlert(textFieldDelegate: self, completion: self.pgpPasswordAlertDismissed)
            self.present(alert, animated: true, completion: nil)
        case(let x):
            print(x)
        }
    }

    func pgpPasswordAlertDismissed() {
        performSegue(withIdentifier: "proceedToCloneRepository", sender: self)
    }
}

extension DetectPGPKeyViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let pw = textField.text else { return }

        _ = addPgpKeyPasswordToKeychain(pw)
    }
}
