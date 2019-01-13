import Foundation
fileprivate let queue = DispatchQueue(label: "FileMonitorQueue", target: .main)

class FileWatcher {
    let fsSource: DispatchSourceFileSystemObject

    init(in directory: URL, filename: String) {
        let path = directory.path.cString(using: .ascii)

        let fileDescriptor = open(path!, O_EVTONLY)
        fsSource = DispatchSource.makeFileSystemObjectSource(fileDescriptor: fileDescriptor, eventMask: .write, queue: queue)

        fsSource.setEventHandler {
            do {
                let fileHandle = try FileHandle(forReadingFrom: documentsDirectory.appendingPathComponent(filename))
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
