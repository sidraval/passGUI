import KeychainSwift

let accessGroup = "DEV_GROUP_HERE.com.sidraval.passGUI"
let privateKeyUrl = documentsDirectory.appendingPathComponent("gpg_private_key.asc", isDirectory: false)

let keychain: KeychainSwift = {
    let keychain = KeychainSwift()
    keychain.accessGroup = accessGroup

    return keychain
}()

func getPrivateKeyFromKeychain() -> Data? {
    return keychain.getData("pgp_private_key")
}

func moveKeyToKeychainThenDelete() -> KeychainResult {
    guard getPrivateKeyFromKeychain() == nil else { return .keyExistsInKeychain }

    let addResult = addDataToKeychain(from: privateKeyUrl)
    let removeResult = removeKeyFromDocumentsDirectory()

    switch (addResult, removeResult) {
    case (.success, .success):
        return .success
    case (let x, .success):
        return x
    case (.success, let x):
        return x
    default:
        return .totalFailure
    }
}

fileprivate func removeKeyFromDocumentsDirectory() -> KeychainResult {
    do {
        try FileManager.default.removeItem(at: privateKeyUrl)
        return .success
    } catch {
        return .removeKeyFromFilesystemFailure
    }
}

fileprivate func addDataToKeychain(from url: URL) -> KeychainResult {
    do {
        let data = try Data(contentsOf: url)

        if (keychain.set(data, forKey: "pgp_private_key")) {
            return .success
        } else {
            return .keychainSetFailure
        }
    } catch {
        return .privateKeyReadError
    }
}

enum KeychainResult: String {
    case success
    case keyExistsInKeychain
    case keychainSetFailure
    case privateKeyReadError
    case removeKeyFromFilesystemFailure
    case totalFailure
}
