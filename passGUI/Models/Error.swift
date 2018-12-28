struct PassError: Error {
    enum ErrorKind {
        case noUsernamesFound
    }

    let kind: ErrorKind
}
