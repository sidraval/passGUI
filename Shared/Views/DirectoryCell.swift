import UIKit

class DirectoryCell: UITableViewCell {
    @IBOutlet var directoryName: UILabel!

    func configure(with directory: Directory?) {
        guard let dir = directory else { return }

        directoryName.text = dir.name
    }
}
