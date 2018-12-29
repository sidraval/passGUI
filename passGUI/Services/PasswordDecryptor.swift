import ObjectivePGP

func decryptPassword(for domain: Directory, with username: Username) -> String? {
    return decryptPassword(using: getPrivateKeyFromKeychain(), for: domain, with: username)
}

func decryptPassword(using key: Data?, for domain: Directory, with username: Username) -> String? {
    guard let privateKeyData = key else { return nil }

    do {
        let keys = try ObjectivePGP.readKeys(from: privateKeyData)
        let pwUrl = sharedDocumentsDirectory
            .appendingPathComponent("repositories")
            .appendingPathComponent(domain.name)
            .appendingPathComponent(username.value, isDirectory: false)
        let pwData = try Data(contentsOf: pwUrl)

        let decrypted = try ObjectivePGP.decrypt(pwData,
                                                 andVerifySignature: false,
                                                 using: keys,
                                                 passphraseForKey: { _ in "PW_HERE" })

        return String(data: decrypted, encoding: .utf8)?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    } catch {
        return nil
    }
}
