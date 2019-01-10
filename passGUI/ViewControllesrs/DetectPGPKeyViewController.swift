import UIKit

extension UIStoryboard {
    static var detectPGPKeyVC: DetectPGPKeyViewController {
        return UIStoryboard(name: "Onboarding", bundle: nil).instantiateInitialViewController() as! DetectPGPKeyViewController
    }
}

class DetectPGPKeyViewController: UIViewController {
    @IBOutlet var copiedToKeychainLabel: UILabel!
    @IBOutlet var removedFromDiskLabel: UILabel!

    var fileWatcher: FileWatcher!

    override func viewDidLoad() {
        fileWatcher = FileWatcher(handler: self.handleSuccessfulKeyWrite)
    }

    func handleSuccessfulKeyWrite() {
        DispatchQueue.main.async {
            Timer.scheduledTimer(withTimeInterval: TimeInterval(1), repeats: false) { (_) in
                print("Moving key to keychain, then deleting... ")
                print(moveKeyToKeychainThenDelete())
            }
        }
    }
}
