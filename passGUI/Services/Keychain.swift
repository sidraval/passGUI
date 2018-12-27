import KeychainSwift


func getPrivateKeyFromKeychain() -> Data? {
    return KeychainSwift().getData("pgp_private_key")
}

func moveKeyToKeychainThenDelete() throws {
    guard getPrivateKeyFromKeychain() == nil else { return }

    try addPrivateKeyToKeychain()
    try removeKeyFromDocumentsDirectory()
}

fileprivate func removeKeyFromDocumentsDirectory() throws {
    let privateKeyUrl = documentsDirectory.appendingPathComponent("gpg_private_key.asc", isDirectory: false)
    try FileManager.default.removeItem(at: privateKeyUrl)
}

fileprivate func addPrivateKeyToKeychain() throws {
    let privateKeyUrl = documentsDirectory.appendingPathComponent("gpg_private_key.asc", isDirectory: false)
    try addDataToKeychain(from: privateKeyUrl)
}

fileprivate func addDataToKeychain(from url: URL) throws {
    let keychain = KeychainSwift()
    let data = try Data(contentsOf: url)

    keychain.set(data, forKey: "pgp_private_key")
}
