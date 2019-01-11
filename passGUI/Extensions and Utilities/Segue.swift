import Perform

extension Segue {
    static var startOnboarding: Segue<DetectPGPKeyViewController> {
        return .init(identifier: "startOnboarding")
    }
}

extension Segue {
    static var skipOnboarding: Segue<ViewPasswordDirectoriesViewController> {
        return .init(identifier: "skipOnboarding")
    }
}

extension Segue {
    static var showContentsOfDirectory: Segue<ViewPasswordsViewController> {
        return .init(identifier: "showContentsOfDirectory")
    }
}
