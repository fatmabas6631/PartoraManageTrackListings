import SwiftUI

@available(iOS 14.0, *)
struct PartAddFieldView: View {
    let title: String
    @Binding var text: String
    let icon: String
    var isRequired: Bool = false
    var keyboardType: UIKeyboardType = .default
    
    @State private var isFocused = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isFocused ? .blue : .secondary)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(isFocused ? .blue : .secondary)
                
                if isRequired {
                    Text("*")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                }
                
                Spacer()
            }
            
            TextField("Enter \(title.lowercased())", text: $text, onEditingChanged: { focused in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isFocused = focused
                }
            })
            .keyboardType(keyboardType)
            .textFieldStyle(PlainTextFieldStyle())
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isFocused ? Color.blue : Color.clear, lineWidth: 2)
                    )
            )
        }
    }
}
