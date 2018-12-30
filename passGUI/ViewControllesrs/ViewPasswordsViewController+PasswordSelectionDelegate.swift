import UIKit

extension ViewPasswordsViewController: PasswordSelectionDelegate {
    func selectedPassword(for directory: Directory, with uname: Username) {
        verifyFace { [weak self] in
            DispatchQueue.main.async {
                let password = decryptPassword(for: directory, with: uname)
                self?.passwordField.text = password
                UIPasteboard.general.string = password
            }
        }
    }
}
