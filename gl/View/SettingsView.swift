import SwiftUI

struct SettingsView: View {
    @AppStorage("maxJournalLength")
    private var maxJournalLength = 15
    
    var body: some View {
        Spacer()
        HStack {
            Spacer()
            Form {
                Stepper(value: $maxJournalLength, in: 1...100, step: 1) {
                    Text("\(NSLocalizedString("Max journal length", comment: "")): \(maxJournalLength)")
                }
            }
            Spacer()
        }
        Spacer()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
