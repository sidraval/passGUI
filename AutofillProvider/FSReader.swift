import Foundation

let sharedDocumentsDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.passGUI")!
let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

func listDocumentSubdirectories(for paths: [String]) throws -> [Directory] {
    let url = paths.reduce(sharedDocumentsDirectory) { $0.appendingPathComponent($1) }
    let dirNames = try FileManager.default.contentsOfDirectory(atPath: url.path)

    return dirNames.map { Directory(name: $0) }
}

func getUsernamesFor(directory: Directory) -> [Username] {
    do {
        let subdirs = try listDocumentSubdirectories(for: ["repositories", directory.name])
        return subdirs.map { Username(value: $0.name) }
    } catch {
        return []
    }
}

func fetchPasswordDirectories() -> [Directory] {
    do {
        return try listDocumentSubdirectories(for: ["repositories"])
    } catch {
        return []
    }
}
