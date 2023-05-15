import SwiftUI

@main
struct glApp: App {
    @Environment(\.openWindow) var openWindow
    
    private let clipboard = Clipboard(
        maxJournalLength: UserDefaults.standard.integer(forKey: "maxJournalLength")
    )
    
    public static let menuWindowId = NSUserInterfaceItemIdentifier("menu")
    private let title = LocalizedStringKey("Title")
    
    public static func findWindowBy(id: NSUserInterfaceItemIdentifier) -> NSWindow? {
        return NSApplication.shared.windows.first { window in window.identifier == id }
    }
    
    private func open() -> Void {
        if let oldWindow = glApp.findWindowBy(id: glApp.menuWindowId) {
            oldWindow.close()
        }
        
        openWindow(id: glApp.menuWindowId.rawValue)
        
        if let window = glApp.findWindowBy(id: glApp.menuWindowId) {
            window.makeKeyAndOrderFront(nil)
            window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .transient, .stationary]
            window.level = .floating
        }
    }
    
    var body: some Scene {
        MenuBarExtra(title, systemImage: "list.clipboard.fill") {
            Button(LocalizedStringKey("Open menu"), action: open).keyboardShortcut("v", modifiers: [.control])
            
            Button(LocalizedStringKey("Options"), action: { openWindow(id: "options") })
                .keyboardShortcut(",", modifiers: [.command])
        }
        
        Window(title, id: glApp.menuWindowId.rawValue) {
            ContentView(clipboard: clipboard) { selection in
                guard selection != nil else { return }
                
                clipboard.write(selection!)
                
                if let this = glApp.findWindowBy(id: glApp.menuWindowId) {
                    this.close()
                }
            }
        }
        .windowResizability(.contentSize)
        
        Window(LocalizedStringKey("Options"), id: "options") {
            SettingsView()
                .frame(minWidth: 300, minHeight: 200)
        }
    }
}
