import LocalAuthentication

func verifyFace(_ then: @escaping () -> ()) {
    let context = LAContext()
    context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                           localizedReason: "Scan your face to decrypt your passwords...") { success, error in
        if success {
            then()
        } else {
            print("Error!", error)
        }
    }
}
