import Foundation

class FileWatcher {
    let fsSource: DispatchSourceFileSystemObject

    init() {
        let queue = DispatchQueue(label: "FileMonitorQueue", target: .main)
        let path = documentsDirectory.path.cString(using: .ascii)

        let fileDescriptor = open(path!, O_EVTONLY)
        fsSource = DispatchSource.makeFileSystemObjectSource(fileDescriptor: fileDescriptor, eventMask: .write, queue: queue)

        fsSource.setEventHandler {
            do {
                let fileHandle = try FileHandle(forReadingFrom: documentsDirectory.appendingPathComponent("gpg_private_key.asc"))
                fileHandle.readToEndOfFileInBackgroundAndNotify()
            } catch let e {
                print(e)
            }
        }

        fsSource.setCancelHandler {
            close(fileDescriptor)
        }

        fsSource.resume()
    }

    deinit {
        fsSource.cancel()
    }
}
