import UIKit

class DirectoriesTableViewDataSource: NSObject, UITableViewDataSource {
    var sections: [DirectorySection]

    override init() {
        let directoryNames = try? listDocumentsSubdirectories(for: "repositories")
        let directories = (directoryNames ?? []).map { Directory(name: $0) }

        self.sections = buildAlphanumericSections(from: directories)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "directory", for: indexPath) as! DirectoryCell

        let section = sections[indexPath.section]
        let directory = section.constituents[indexPath.row]
        cell.configure(with: directory)

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].constituents.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].letter
    }
}

fileprivate func buildAlphanumericSections(from directories: [Directory]) -> [DirectorySection] {
    let filteredDirectories = directories.filter { $0.name.prefix(1) != "." }
    let groupedDictionary = Dictionary(grouping: filteredDirectories, by: { $0.name.prefix(1) })
    let sortedKeys = groupedDictionary.keys.sorted()

    return sortedKeys.map {
        DirectorySection(letter: String($0), constituents: groupedDictionary[$0]!)
    }
}
