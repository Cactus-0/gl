import Foundation
import Cocoa
import SwiftUI

class Clipboard: Event<CopyableData>, ObservableObject {
    private let maxJournalLength: Int
    
    private let pasteboard = NSPasteboard.general
    
    @Published
    public var journal: [CopyableData] = []
    
    private var changeCount: Int
    
    init(maxJournalLength: Int) {
        self.maxJournalLength = maxJournalLength
        
        changeCount = pasteboard.changeCount
        
        super.init()
        
        Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(checkClipboard),
            userInfo: nil,
            repeats: true
        )
    }
    
    public func write(_ data: CopyableData) -> Void {
        pasteboard.clearContents()
        switch data {
        case .string(let str):
            pasteboard.setString(str, forType: .string)
        case .image(let img):
            pasteboard.setData(img.tiffRepresentation, forType: .tiff)
        }
    }
    
    public func clear() -> Void {
        journal = []
    }
    
    @objc
    private func checkClipboard() {
        guard pasteboard.changeCount != changeCount else { return }
        
        changeCount += 1
        
        if let data = pasteboard.data(forType: .tiff) {
            let img = CopyableData.image(NSImage(data: data)!)
            journal.append(img)
            
            if journal.count > maxJournalLength {
                journal.remove(at: 0)
            }
            
            emit(data: img)
            return
        }
        
        guard let string = pasteboard.string(forType: .string) else { return }
        
        journal.append(.string(string))
        
        if journal.count > maxJournalLength {
            journal.remove(at: 0)
        }
        
        emit(data: .string(string))
    }
}
