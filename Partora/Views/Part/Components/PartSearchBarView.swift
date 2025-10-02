import SwiftUI

@available(iOS 14.0, *)
struct PartSearchBarView: View {
    @Binding var searchText: String
    @State private var isSearching = false
    
    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isSearching ? .blue : .secondary)
                    .animation(.easeInOut(duration: 0.2), value: isSearching)
                
                TextField("Search parts, suppliers, categories...", text: $searchText, onEditingChanged: { searching in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isSearching = searching
                    }
                })
                .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSearching ? Color.blue.opacity(0.5) : Color.clear, lineWidth: 1)
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemGroupedBackground))
    }
}
