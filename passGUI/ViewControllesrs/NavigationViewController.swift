import UIKit
import Perform

class NavigationController: UIViewController {
    override func viewDidLoad() {
        navigateToInitialDestination()
    }

    func navigateToInitialDestination() {
        let hasCloned = try? listDocumentsSubdirectories(for: "repositories")

        switch hasCloned {
        case .some:
            perform(.skipOnboarding)
        case .none:
            perform(.startOnboarding)
        }
    }
}
