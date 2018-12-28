struct PassError: Error {
    enum ErrorKind {
        case noUsernamesFound
        case noPasswordsFound
    }

    let kind: ErrorKind
}
