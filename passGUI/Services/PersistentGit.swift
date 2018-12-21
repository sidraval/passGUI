import Foundation
import Result
import SwiftGit2

let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
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

func getDocumentsSubdirectories() throws -> [String] {
    return try FileManager().contentsOfDirectory(atPath: documentsDirectory.path)
}

func listDocumentsSubdirectories(for path: String) throws -> [String] {
    let path = documentsDirectory.appendingPathComponent(path).path

    return try FileManager.default.contentsOfDirectory(atPath: path)
}
