import ObjectivePGP

func decryptPassword(for domain: Directory, with username: String) -> String? {
    do {
        let privateKeyUrl = documentsDirectory.appendingPathComponent("gpg_private_key.asc", isDirectory: false)
        let keys = try ObjectivePGP.readKeys(fromPath: privateKeyUrl.path)
        let pwUrl = documentsDirectory
            .appendingPathComponent("repositories")
            .appendingPathComponent(domain.name)
            .appendingPathComponent(username, isDirectory: false)
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
