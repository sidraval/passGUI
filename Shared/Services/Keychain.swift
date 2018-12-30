import KeychainSwift

func getPrivateKeyFromKeychain() -> Data? {
    let keychain = KeychainSwift()
    keychain.accessGroup = "LKF4VLY687.com.sidraval.passGUI"
    return keychain.getData("pgp_private_key")
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

    let keychain = KeychainSwift()
    keychain.accessGroup = "com.sidraval.passGUI"
    try addDataToKeychain(from: privateKeyUrl)
}

fileprivate func addDataToKeychain(from url: URL) throws {
    let data = try Data(contentsOf: url)

    let keychain = KeychainSwift()
    keychain.accessGroup = "com.sidraval.passGUI"
    keychain.set(data, forKey: "pgp_private_key")
}
