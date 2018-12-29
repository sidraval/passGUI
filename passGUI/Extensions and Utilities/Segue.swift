import Perform

extension Segue {
    static var startOnboarding: Segue<FetchPasswordRepoViewController> {
        return .init(identifier: "startOnboarding")
    }
}

extension Segue {
    static var skipOnboarding: Segue<ViewPasswordDirectoriesViewController> {
        return .init(identifier: "skipOnboarding")
    }

    static var endOnboarding: Segue<ViewPasswordDirectoriesViewController> {
        return .init(identifier: "endOnboarding")
    }
}

extension Segue {
    static var showContentsOfDirectory: Segue<ViewPasswordsViewController> {
        return .init(identifier: "showContentsOfDirectory")
    }
}
