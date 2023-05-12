import Foundation
import SwiftUI

enum CopyableData: Identifiable, Hashable {
    var id: Self { self }
    
    case string(String)
    case image(NSImage)
}
