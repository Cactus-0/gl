import SwiftUI

struct Copyable: View {
    public let data: CopyableData;
    
    public init(_ data: CopyableData) {
        self.data = data
    }
    
    var body: some View {
        HStack {
            Spacer()
            
            switch data {
            case .string(let text):
                Text(text.trimmingCharacters(in: .whitespacesAndNewlines))
                    .padding()
                    .lineLimit(5)
                    .truncationMode(.tail)
            case .image(let image):
                Image(nsImage: image)
                    .resizable()
                    .cornerRadius(5)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 150)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct Copyable_Previews: PreviewProvider {
    static var previews: some View {
        Copyable(.string("")).padding()
    }
}
