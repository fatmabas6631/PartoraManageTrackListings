import SwiftUI

@available(iOS 14.0, *)
struct PartAddTextAreaView: View {
    let title: String
    @Binding var text: String
    let icon: String
    
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
                
                Spacer()
            }
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isFocused ? Color.blue : Color.clear, lineWidth: 2)
                    )
                    .frame(height: 100)
                
                if text.isEmpty {
                    Text("Enter additional notes or comments...")
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                }
                
                TextEditor(text: $text)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.clear)
                    .onTapGesture {
                        isFocused = true
                    }
            }
        }
    }
}
