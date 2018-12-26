import UIKit

class UsernamesDataSource: NSObject, UITableViewDataSource {
    let directory: Directory
    var usernames: [String]

    init(directory: Directory) {
        self.directory = directory
        self.usernames = getUsernamesFor(directory: directory)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usernames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "username", for: indexPath) as! UsernameCell
        let username = usernames[indexPath.row]
        cell.configure(with: username)

        return cell
    }
}

func getUsernamesFor(directory: Directory) -> [String] {
    let usernames = try? listDocumentSubdirectories(for: ["repositories", directory.name])

    return usernames ?? []
}
