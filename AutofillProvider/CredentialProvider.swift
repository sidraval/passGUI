import AuthenticationServices

class CredentialProvider {
    var identifier: ASCredentialServiceIdentifier?
    weak var extensionContext: ASCredentialProviderExtensionContext?

    init(extensionContext: ASCredentialProviderExtensionContext) {
        self.extensionContext = extensionContext
    }

    func persistAndProvideCredentials(for identity: ASPasswordCredentialIdentity) {
        guard let recordIdentifier = identity.recordIdentifier else { return }
        let directory = Directory(name: recordIdentifier)
        let username = Username(value: identity.user)

        guard let pwCredentials = provideCredentials(in: directory, with: username) else { return }

        extensionContext?.completeRequest(withSelectedCredential: pwCredentials)
    }

    func persistAndProvideCredentials(in directory: Directory, with username: Username) {
        guard let credentialIdentity = provideCredentialIdentity(for: identifier, in: directory, with: username) else { return }
        guard let pwCredentials = provideCredentials(in: directory, with: username) else { return }

        ASCredentialIdentityStore.shared.saveCredentialIdentities([credentialIdentity])
        extensionContext?.completeRequest(withSelectedCredential: pwCredentials)
    }
}

fileprivate func provideCredentialIdentity(for identifier: ASCredentialServiceIdentifier?,
                                           in directory: Directory,
                                           with username: Username) -> ASPasswordCredentialIdentity? {
    guard let serviceIdentifier = identifier else { return nil }

    return ASPasswordCredentialIdentity(serviceIdentifier: serviceIdentifier, user: username.value, recordIdentifier: directory.name)
}

fileprivate func provideCredentials(in directory: Directory,
                                    with username: Username) -> ASPasswordCredential? {
    guard let password = decryptPassword(for: directory, with: username) else { return nil }

    return ASPasswordCredential(user: username.withoutFileExtension, password: password)
}
