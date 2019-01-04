import KeychainSwift

let accessGroup = "DEV_GROUP_HERE.com.sidraval.passGUI"

func getPrivateKeyFromKeychain() -> Data? {
    let keychain = KeychainSwift()
    keychain.accessGroup = accessGroup
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
    keychain.accessGroup = accessGroup
    try addDataToKeychain(from: privateKeyUrl)
}

fileprivate func addDataToKeychain(from url: URL) throws {
    let data = try Data(contentsOf: url)

    let keychain = KeychainSwift()
    keychain.accessGroup = accessGroup
    keychain.set(data, forKey: "pgp_private_key")
}
