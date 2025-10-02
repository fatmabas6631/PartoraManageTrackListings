import SwiftUI

@available(iOS 14.0, *)
struct PartListView: View {
    @ObservedObject var dataManager: FactoryDataManager
    @State private var searchText = ""
    @State private var showingAddView = false
    
    var filteredParts: [Part] {
        if searchText.isEmpty {
            return dataManager.parts
        } else {
            return dataManager.parts.filter { part in
                part.partNumber.localizedCaseInsensitiveContains(searchText) ||
                part.description.localizedCaseInsensitiveContains(searchText) ||
                part.supplierName.localizedCaseInsensitiveContains(searchText) ||
                part.category.localizedCaseInsensitiveContains(searchText) ||
                part.manufacturer.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
            VStack(spacing: 0) {
                PartSearchBarView(searchText: $searchText)
                
                if filteredParts.isEmpty {
                    PartNoDataView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredParts) { part in
                                NavigationLink(destination: PartDetailView(part: part)) {
                                    PartListRowView(part: part)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .onDelete(perform: deleteParts)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 100)
                    }
                }
                
                Spacer()
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitle("Parts Inventory", displayMode: .large)
            .navigationBarItems(
                trailing: Button(action: {
                    showingAddView = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.blue)
                }
            )
        
        .sheet(isPresented: $showingAddView) {
            PartAddView(dataManager: dataManager)
        }
    }
    
    private func deleteParts(offsets: IndexSet) {
        dataManager.deletePart(at: offsets)
    }
}
