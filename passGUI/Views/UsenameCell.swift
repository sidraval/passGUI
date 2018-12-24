import UIKit

class UsernameCell: UITableViewCell {
    @IBOutlet var username: UILabel!

    func configure(with username: String?) {
        self.username.text = username
    }
}
