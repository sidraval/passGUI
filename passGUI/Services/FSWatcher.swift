import Foundation

class FileWatcher {
    let fsSource: DispatchSourceFileSystemObject
    let handler: () -> Void

    init(handler: @escaping () -> Void) {
        self.handler = handler

        let queue = DispatchQueue.init(label: "FileMonitorQueue")
        let path = documentsDirectory.path.cString(using: .ascii)
        let fileDescriptor = open(path!, O_EVTONLY)
        fsSource = DispatchSource.makeFileSystemObjectSource(fileDescriptor: fileDescriptor, eventMask: .write, queue: queue)

        fsSource.setEventHandler { [weak self] in
            self?.handler()
        }

        fsSource.setCancelHandler {
            close(fileDescriptor)
        }

        fsSource.resume()
    }
}
