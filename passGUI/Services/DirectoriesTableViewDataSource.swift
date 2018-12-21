import UIKit

class DirectoriesTableViewDataSource: NSObject, UITableViewDataSource {
    var directories: [Directory]

    override init() {
        let directoryNames = try? listDocumentsSubdirectories(for: "repositories")
        let directories = (directoryNames ?? []).map { Directory(name: $0) }

        self.directories = directories
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "directory", for: indexPath) as! DirectoryCell
        cell.configure(with: directories[safe: indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return directories.count
    }
}
