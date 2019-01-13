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
        fileWatcher = FileWatcher(in: documentsDirectory, filename: "gpg_private_key.asc")
        NotificationCenter.default.addObserver(self, selector: #selector(handleSuccessfulKeyWrite), name: .NSFileHandleReadToEndOfFileCompletion, object: nil)
    }

    override func viewDidAppear(_: Bool) {
        if getPrivateKeyFromKeychain() != nil {
            pgpPasswordAlertDismissed()
        }
    }

    @objc func handleSuccessfulKeyWrite() {
        switch moveKeyToKeychainThenDelete() {
        case .success:
            copiedToKeychainLabel.text = copiedToKeychainSuccess
            removedFromDiskLabel.text = removedFromDiskSuccess
            let alert = pgpKeyPasswordAlert(textFieldDelegate: self, completion: pgpPasswordAlertDismissed)
            present(alert, animated: true, completion: nil)
        case let x:
            print(x)
        }
    }

    func pgpPasswordAlertDismissed() {
        navigator.navigateToFetchRepository()
    }
}

extension DetectPGPKeyViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let pw = textField.text else { return }

        _ = addPgpKeyPasswordToKeychain(pw)
    }
}
