import UIKit

protocol DirectoriesDataSource: UITableViewDataSource {
    var filteredSections: [DirectorySection] { get set }

    func showDirectories(matching text: String)
}

protocol Navigator: class {
    func navigateToContentsOf(directory: Directory)
}
