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

func listDocumentsSubdirectories(for path: String) throws -> [String] {
    let path = documentsDirectory.appendingPathComponent(path).path

    return try FileManager.default.contentsOfDirectory(atPath: path)
}

func listDocumentSubdirectories(for paths: [String]) throws -> [String] {
    let url = paths.reduce(documentsDirectory) { $0.appendingPathComponent($1) }

    return try FileManager.default.contentsOfDirectory(atPath: url.path)
}

func getUsernamesFor(directory: Directory) -> Result<[Username], PassError> {
    do {
        let subdirs = try listDocumentSubdirectories(for: ["repositories", directory.name])
        return .success(subdirs.map(Username.init))
    } catch {
        return .failure(PassError(kind: .noUsernamesFound))
    }
}
