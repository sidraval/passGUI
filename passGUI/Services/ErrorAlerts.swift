import UIKit

func noPgpKeyFoundAlert(
    cancel: @escaping () -> Void,
    redetect: @escaping () -> Void
) -> UIAlertController {
    let title = "No PGP key detected!"
    let message = """
    Please use iTunes to copy your ASCII armored private key to the passGUI application. The file should be named:
    gpg_private_key.asc
    """

    let redetectAction = UIAlertAction(
        title: "Detect",
        style: .default,
        handler: { _ in redetect() }
    )

    let cancelAction = UIAlertAction(
        title: "Cancel",
        style: .cancel,
        handler: { action in cancel() }
    )

    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: .alert)

    alert.addAction(redetectAction)
    alert.addAction(cancelAction)

    return alert
}
