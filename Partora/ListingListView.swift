import SwiftUI

@available(iOS 14.0, *)
struct ListingListView: View {
    @ObservedObject var dataManager: FactoryDataManager
    @State private var searchText = ""
    @State private var showingAddView = false
    
    var filteredListings: [Listing] {
        if searchText.isEmpty {
            return dataManager.listings
        } else {
            return dataManager.listings.filter { listing in
                listing.title.localizedCaseInsensitiveContains(searchText) ||
                listing.sku.localizedCaseInsensitiveContains(searchText) ||
                listing.brand.localizedCaseInsensitiveContains(searchText) ||
                listing.category.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
            VStack(spacing: 0) {
                ListingSearchBarView(searchText: $searchText)
                
                if filteredListings.isEmpty {
                    ListingNoDataView(searchText: searchText)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredListings) { listing in
                                NavigationLink(destination: ListingDetailView(listing: listing, dataManager: dataManager)) {
                                    ListingListRowView(listing: listing)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .onDelete(perform: deleteListing)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitle("Listings", displayMode: .large)
            .navigationBarItems(
                trailing: Button(action: { showingAddView = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            )
        
        .sheet(isPresented: $showingAddView) {
            ListingAddView(dataManager: dataManager)
        }
    }
    
    private func deleteListing(at offsets: IndexSet) {
        let indicesToDelete = offsets.map { filteredListings[$0] }
        for listing in indicesToDelete {
            if let index = dataManager.listings.firstIndex(where: { $0.id == listing.id }) {
                dataManager.listings.remove(at: index)
            }
        }
    }
}

@available(iOS 14.0, *)
struct ListingSearchBarView: View {
    @Binding var searchText: String
    @State private var isSearching = false
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .font(.system(size: 16, weight: .medium))
                
                TextField("Search listings...", text: $searchText, onEditingChanged: { editing in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isSearching = editing
                    }
                })
                .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .scaleEffect(isSearching ? 1.02 : 1.0)
            .shadow(color: isSearching ? .blue.opacity(0.3) : .clear, radius: 5, x: 0, y: 2)
            
            if isSearching {
                Button("Cancel") {
                    searchText = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isSearching = false
                    }
                }
                .foregroundColor(.blue)
                .transition(.move(edge: .trailing))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

@available(iOS 14.0, *)
struct ListingListRowView: View {
    let listing: Listing
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Section
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(listing.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    HStack {
                        ListingRowBadgeView(text: listing.sku, icon: "barcode", color: .blue)
                        ListingRowBadgeView(text: listing.brand, icon: "building.2", color: .green)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("$\(String(format: "%.2f", Double(listing.priceCents) / 100))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    HStack {
                        Image(systemName: listing.isActive ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(listing.isActive ? .green : .red)
                        Text(listing.status)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            // Details Grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ListingRowDetailView(title: "Category", value: listing.category, icon: "folder.fill", color: .orange)
                ListingRowDetailView(title: "Model", value: listing.modelNumber, icon: "number.circle", color: .purple)
                ListingRowDetailView(title: "Material", value: listing.material, icon: "cube.fill", color: .red)
                ListingRowDetailView(title: "Weight", value: "\(listing.weightGrams)g", icon: "scalemass.fill", color: .gray)
                ListingRowDetailView(title: "Dimensions", value: "\(listing.lengthMM)×\(listing.widthMM)×\(listing.heightMM)mm", icon: "ruler.fill", color: .orange)
                ListingRowDetailView(title: "Warranty", value: "\(listing.warrantyMonths)mo", icon: "shield.fill", color: .green)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            // Additional Info Section
            VStack(spacing: 8) {
                HStack {
                    ListingRowInfoChip(text: "Serial: \(listing.serialNumber)", color: .red)
                    Spacer()
                    ListingRowInfoChip(text: "Location: \(listing.storageLocation)", color: .yellow)
                }
                
                HStack {
                    ListingRowInfoChip(text: "Manufacturer: \(listing.manufacturer)", color: .pink)
                    Spacer()
                    if listing.isFeatured {
                        ListingRowInfoChip(text: "Featured", color: .yellow)
                    }
                }
                
                if !listing.notes.isEmpty {
                    HStack {
                        Text("Notes: \(listing.notes)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                        Spacer()
                    }
                }
                
                // Rating and Custom Fields
                HStack {
                    HStack {
                        ForEach(0..<5) { index in
                            Image(systemName: index < Int(listing.rating) ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .font(.caption)
                        }
                        Text(String(format: "%.1f", listing.rating))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text("Updated: \(listing.updatedAt, formatter: dateFormatter)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray5), lineWidth: 0.5)
        )
    }
}

@available(iOS 14.0, *)
struct ListingRowBadgeView: View {
    let text: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
        }
        .foregroundColor(color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

@available(iOS 14.0, *)
struct ListingRowDetailView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(color)
                .frame(width: 16, height: 16)
            
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
                .fontWeight(.medium)
            
            Text(value)
                .font(.caption)
                .foregroundColor(.primary)
                .fontWeight(.semibold)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(color.opacity(0.05))
        .cornerRadius(8)
    }
}

@available(iOS 14.0, *)
struct ListingRowInfoChip: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.caption2)
            .foregroundColor(color)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.1))
            .cornerRadius(4)
    }
}

@available(iOS 14.0, *)
struct ListingNoDataView: View {
    let searchText: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: searchText.isEmpty ? "tray" : "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray)
                .opacity(0.6)
            
            VStack(spacing: 8) {
                Text(searchText.isEmpty ? "No Listings Found" : "No Search Results")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(searchText.isEmpty ? 
                     "Start by adding your first product listing" : 
                     "Try adjusting your search terms")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            if searchText.isEmpty {
                Button("Add First Listing") {
                    // This would trigger the add view
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.blue)
                .cornerRadius(12)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

@available(iOS 14.0, *)
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()
