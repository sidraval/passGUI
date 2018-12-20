//
//  PersistentGit.swift
//  passGUI
//
//  Created by Sid Raval on 12/19/18.
//  Copyright © 2018 Sid Raval. All rights reserved.
//

import Foundation
import SwiftGit2

let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
let archiveURL = documentsDirectory.appendingPathComponent("repositories")

func fetchAndPersistRepository(from fromURL: URL, to toURL: URL, username: String, password: String) {
    let creds = Credentials.plaintext(username: username, password: password)

    let clonedRepoResult = Repository.clone(from: fromURL, to: toURL, localClone: false, bare: false, credentials: creds, checkoutStrategy: CheckoutStrategy.Force, checkoutProgress: nil)

    switch clonedRepoResult {
    case .success(_):
        print("Successfully cloned repository")
        break
    case let .failure(error):
        print("Error!", error)
        break
    }
}

func getDocumentsSubdirectories() throws -> [String] {
    return try FileManager().contentsOfDirectory(atPath: documentsDirectory.path)
}
