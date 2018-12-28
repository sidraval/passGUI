import UIKit

class DirectoriesTableViewDataSource: NSObject, UITableViewDataSource {
    var sections: [DirectorySection]
    var filteredSections: [DirectorySection]

    override init() {
        let directoryNames = try? listDocumentsSubdirectories(for: "repositories")
        let directories = (directoryNames ?? []).map { Directory(name: $0) }

        sections = buildAlphanumericSections(from: directories)
        filteredSections = sections
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "directory", for: indexPath) as! DirectoryCell

        let section = filteredSections[indexPath.section]
        let directory = section.constituents[indexPath.row]
        cell.configure(with: directory)

        return cell
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSections[section].constituents.count
    }

    func numberOfSections(in _: UITableView) -> Int {
        return filteredSections.count
    }

    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filteredSections[section].letter
    }

    func showDirectories(matching text: String) {
        guard !text.isEmpty else {
            filteredSections = sections
            return
        }

        filteredSections = sections.map { section in
            let directories = section.constituents.filter { directory in
                return directory.name.lowercased().contains(text.lowercased())
            }

            return DirectorySection(letter: section.letter, constituents: directories)
        }.filter { !$0.constituents.isEmpty }
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
