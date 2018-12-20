//
//  ViewController.swift
//  passGUI
//
//  Created by Sid Raval on 12/19/18.
//  Copyright © 2018 Sid Raval. All rights reserved.
//

import UIKit
import SwiftGit2

class ViewController: UIViewController {
    @IBOutlet weak var repoURL: UITextField!
    @IBOutlet weak var repoURLView: UIView!

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var usernameView: UIView!

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordView: UIView!

    override func viewDidLoad() {
        let repoTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(focusRepoURLField))
        repoURLView.addGestureRecognizer(repoTapRecognizer)

        let usernameTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(focusUsernameField))
        usernameView.addGestureRecognizer(usernameTapRecognizer)

        let passwordTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(focusPasswordField))
        passwordView.addGestureRecognizer(passwordTapRecognizer)
    }

    @objc func focusRepoURLField(_: UITapGestureRecognizer) {
        repoURL.becomeFirstResponder()
    }

    @objc func focusUsernameField(_: UITapGestureRecognizer) {
        username.becomeFirstResponder()
    }

    @objc func focusPasswordField(_: UITapGestureRecognizer) {
        password.becomeFirstResponder()
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case repoURL:
            username.becomeFirstResponder();
        case username:
            password.becomeFirstResponder()
        case password:
            break;
        default:
            break;
        }

        return true
    }
}
