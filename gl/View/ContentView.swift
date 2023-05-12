import SwiftUI

struct ContentView: View {
    typealias Callback = (CopyableData?) -> Void
    
    private let callback: Callback
    @ObservedObject
    private var clipboard: Clipboard
    @State
    public var selection: CopyableData?
    
    init(clipboard: Clipboard, afterSelect callback: @escaping Callback) {
        self.clipboard = clipboard
        self.callback = callback
        self.selection = clipboard.journal.first
    }
    
    var body: some View {
        VStack {
            if clipboard.journal.isEmpty {
                Text(LocalizedStringKey("Empty clipboard"))
                    .multilineTextAlignment(.center)
            } else {
                List(clipboard.journal.reversed(), selection: $selection) { item in
                    Copyable(item).tag(item)
                }
                .background(.clear)
                .scrollContentBackground(.hidden)
                Divider()
            }
            
            HStack {
                Button { callback(selection) } label: { Image(systemName: "clipboard") }
                    .disabled(selection == nil)
                    .keyboardShortcut(.return, modifiers: [])
                Button {
                    selection = nil
                    clipboard.clear()
                } label: { Image(systemName: "clear") }
                    .disabled(clipboard.journal.isEmpty)
                    .keyboardShortcut("d", modifiers: [.command])
            }
            .padding(.bottom, 10)
        }
        .frame(minWidth: 200, maxWidth: 300, minHeight: 100, maxHeight: 800)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(clipboard: Clipboard(), afterSelect: { _ in () })
    }
}
