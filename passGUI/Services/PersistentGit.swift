import Foundation
import Result
import SwiftGit2

let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let archiveURL = documentsDirectory.appendingPathComponent("repositories")

func fetchAndPersistRepository(
    from fromURL: URL,
    to toURL: URL,
    username: String,
    password: String
) -> Result<Repository, NSError> {
    let creds = Credentials.plaintext(username: username, password: password)

    // TODO: This shouldn't happen on the main thread
    return Repository.clone(
        from: fromURL,
        to: toURL,
        localClone: false,
        bare: false,
        credentials: creds,
        checkoutStrategy: CheckoutStrategy.Force,
        checkoutProgress: nil
    )
}

func listDocumentsSubdirectories(for path: String) throws -> [Directory] {
    return try listDocumentSubdirectories(for: [path])
}

fileprivate func listDocumentSubdirectories(for paths: [String]) throws -> [Directory] {
    let url = paths.reduce(documentsDirectory) { $0.appendingPathComponent($1) }
    let dirNames = try FileManager.default.contentsOfDirectory(atPath: url.path)

    return dirNames.map { Directory(name: $0) }
}

func getUsernamesFor(directory: Directory) -> Result<[Username], PassError> {
    do {
        let subdirs = try listDocumentSubdirectories(for: ["repositories", directory.name])
        return .success(subdirs.map { Username(value: $0.name) })
    } catch {
        return .failure(PassError(kind: .noUsernamesFound))
    }
}

func fetchPasswordDirectories() -> Result<[Directory], PassError> {
    do {
        return .success(try listDocumentsSubdirectories(for: "repositories"))
    } catch {
        return .failure(PassError(kind: .noPasswordsFound))
    }
}
