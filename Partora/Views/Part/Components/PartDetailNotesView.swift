import SwiftUI

@available(iOS 14.0, *)
struct PartDetailNotesView: View {
    let notes: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "quote.bubble.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.orange)
                
                Text("Notes")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            
            Text(notes)
                .font(.body)
                .foregroundColor(.primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
        }
    }
}
