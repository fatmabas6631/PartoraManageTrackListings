import SwiftUI

@available(iOS 14.0, *)
struct ListingDetailView: View {
    let listing: Listing
    @ObservedObject var dataManager: FactoryDataManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ListingDetailHeaderView(listing: listing)
                
                LazyVStack(spacing: 20) {
                    ListingDetailBasicInfoSection(listing: listing)
                    ListingDetailSpecificationsSection(listing: listing)
                    ListingDetailPricingInventorySection(listing: listing)
                    ListingDetailStatusSection(listing: listing)
                    ListingDetailAdditionalSection(listing: listing)
                    ListingDetailCustomFieldsSection(listing: listing)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(.systemBackground), Color(.systemGray6)]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .navigationBarTitle("", displayMode: .inline)

    }
}

@available(iOS 14.0, *)
struct ListingDetailHeaderView: View {
    let listing: Listing
    
    var body: some View {
        VStack(spacing: 16) {
            // Status indicator
            HStack {
                Spacer()
                ListingDetailStatusBadge(
                    text: listing.status,
                    isActive: listing.isActive,
                    isFeatured: listing.isFeatured
                )
            }
            
            // Main product image placeholder
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue.opacity(0.1), .purple.opacity(0.1)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 200)
                .overlay(
                    VStack {
                        Image(systemName: "cube.box.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.blue.opacity(0.6))
                        Text("Product Image")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                )
            
            // Title and basic info
            VStack(spacing: 12) {
                Text(listing.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 16) {
                    ListingDetailHeaderChip(
                        icon: "barcode",
                        text: listing.sku,
                        color: .blue
                    )
                    ListingDetailHeaderChip(
                        icon: "building.2.fill",
                        text: listing.brand,
                        color: .green
                    )
                    ListingDetailHeaderChip(
                        icon: "dollarsign.circle.fill",
                        text: "$\(String(format: "%.2f", Double(listing.priceCents) / 100))",
                        color: .orange
                    )
                }
                
                // Rating
                HStack {
                    ForEach(0..<5) { index in
                        Image(systemName: index < Int(listing.rating) ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .font(.title3)
                    }
                    Text(String(format: "%.1f", listing.rating))
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.leading, 8)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 30)
        .background(Color(.systemBackground))
        .cornerRadius(25)
        .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 8)
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

@available(iOS 14.0, *)
struct ListingDetailStatusBadge: View {
    let text: String
    let isActive: Bool
    let isFeatured: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            HStack(spacing: 4) {
                Image(systemName: isActive ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(isActive ? .green : .red)
                Text(text)
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(isActive ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
            .cornerRadius(12)
            
            if isFeatured {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("Featured")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(12)
            }
        }
    }
}

@available(iOS 14.0, *)
struct ListingDetailHeaderChip: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
            Text(text)
                .font(.caption)
                .fontWeight(.semibold)
        }
        .foregroundColor(color)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

@available(iOS 14.0, *)
struct ListingDetailSectionHeader: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 30, height: 30)
                    .background(color.opacity(0.1))
                    .clipShape(Circle())
                
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            Rectangle()
                .fill(color.opacity(0.3))
                .frame(width: 60, height: 3)
                .cornerRadius(1.5)
        }
        .padding(.bottom, 5)
    }
}

@available(iOS 14.0, *)
struct ListingDetailFieldRow: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
                .frame(width: 24, height: 24)
                .background(color.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                Text(value.isEmpty ? "Not specified" : value)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(value.isEmpty ? .secondary : .primary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

@available(iOS 14.0, *)
struct ListingDetailBasicInfoSection: View {
    let listing: Listing
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ListingDetailSectionHeader(
                title: "Basic Information",
                icon: "info.circle.fill",
                color: .blue
            )
            
            VStack(spacing: 12) {
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 12) {
                        ListingDetailFieldRow(
                            title: "Category",
                            value: listing.category,
                            icon: "folder.fill",
                            color: .orange
                        )
                        ListingDetailFieldRow(
                            title: "Model Number",
                            value: listing.modelNumber,
                            icon: "number.circle.fill",
                            color: .purple
                        )
                        ListingDetailFieldRow(
                            title: "Color",
                            value: listing.color,
                            icon: "paintpalette.fill",
                            color: .pink
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        ListingDetailFieldRow(
                            title: "Subcategory",
                            value: listing.subcategory,
                            icon: "folder.badge.plus",
                            color: .orange
                        )
                        ListingDetailFieldRow(
                            title: "Serial Number",
                            value: listing.serialNumber,
                            icon: "qrcode",
                            color: .purple
                        )
                        ListingDetailFieldRow(
                            title: "Material",
                            value: listing.material,
                            icon: "cube.fill",
                            color: .green
                        )
                    }
                }
                
                if !listing.details.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(.blue)
                            Text("Product Details")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(listing.details)
                            .font(.body)
                            .foregroundColor(.primary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

@available(iOS 14.0, *)
struct ListingDetailSpecificationsSection: View {
    let listing: Listing
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ListingDetailSectionHeader(
                title: "Specifications",
                icon: "ruler.fill",
                color: .green
            )
            
            // Dimensions Grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ListingDetailSpecCard(
                    title: "Length",
                    value: "\(listing.lengthMM) mm",
                    icon: "ruler",
                    color: .blue
                )
                ListingDetailSpecCard(
                    title: "Width",
                    value: "\(listing.widthMM) mm",
                    icon: "ruler.fill",
                    color: .green
                )
                ListingDetailSpecCard(
                    title: "Height",
                    value: "\(listing.heightMM) mm",
                    icon: "arrow.up.and.down",
                    color: .orange
                )
            }
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    ListingDetailFieldRow(
                        title: "Weight",
                        value: "\(listing.weightGrams) grams",
                        icon: "scalemass.fill",
                        color: .gray
                    )
                    ListingDetailFieldRow(
                        title: "Barcode",
                        value: listing.barcode,
                        icon: "barcode.viewfinder",
                        color: .orange
                    )
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    ListingDetailFieldRow(
                        title: "Unit of Measure",
                        value: listing.unitOfMeasure,
                        icon: "square.grid.3x3.fill",
                        color: .purple
                    )
                    ListingDetailFieldRow(
                        title: "Manufacturer",
                        value: listing.manufacturer,
                        icon: "building.columns.fill",
                        color: .yellow
                    )
                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

@available(iOS 14.0, *)
struct ListingDetailSpecCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(color.opacity(0.05))
        .cornerRadius(12)
    }
}

@available(iOS 14.0, *)
struct ListingDetailPricingInventorySection: View {
    let listing: Listing
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ListingDetailSectionHeader(
                title: "Pricing & Inventory",
                icon: "dollarsign.circle.fill",
                color: .green
            )
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    ListingDetailFieldRow(
                        title: "Price",
                        value: "$\(String(format: "%.2f", Double(listing.priceCents) / 100))",
                        icon: "dollarsign.circle.fill",
                        color: .green
                    )
                    ListingDetailFieldRow(
                        title: "Min Order Qty",
                        value: "\(listing.minOrderQty)",
                        icon: "minus.circle.fill",
                        color: .orange
                    )
                    ListingDetailFieldRow(
                        title: "Storage Location",
                        value: listing.storageLocation,
                        icon: "location.fill",
                        color: .red
                    )
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    ListingDetailFieldRow(
                        title: "Warranty",
                        value: "\(listing.warrantyMonths) months",
                        icon: "shield.fill",
                        color: .blue
                    )
                    ListingDetailFieldRow(
                        title: "Max Order Qty",
                        value: "\(listing.maxOrderQty)",
                        icon: "plus.circle.fill",
                        color: .purple
                    )
                    ListingDetailFieldRow(
                        title: "Created",
                        value: DateFormatter.shortDate.string(from: listing.createdAt),
                        icon: "calendar.badge.plus",
                        color: .yellow
                    )
                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

@available(iOS 14.0, *)
struct ListingDetailStatusSection: View {
    let listing: Listing
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ListingDetailSectionHeader(
                title: "Status & Flags",
                icon: "flag.fill",
                color: .purple
            )
            
            HStack(spacing: 20) {
                ListingDetailStatusCard(
                    title: "Active Status",
                    isActive: listing.isActive,
                    icon: "power",
                    activeColor: .green,
                    inactiveColor: .red
                )
                
                ListingDetailStatusCard(
                    title: "Featured",
                    isActive: listing.isFeatured,
                    icon: "star.fill",
                    activeColor: .yellow,
                    inactiveColor: .gray
                )
            }
            
            ListingDetailFieldRow(
                title: "Last Updated",
                value: DateFormatter.fullDateTime.string(from: listing.updatedAt),
                icon: "clock.fill",
                color: .green
            )
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

@available(iOS 14.0, *)
struct ListingDetailStatusCard: View {
    let title: String
    let isActive: Bool
    let icon: String
    let activeColor: Color
    let inactiveColor: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(isActive ? activeColor : inactiveColor)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Text(isActive ? "Yes" : "No")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(isActive ? activeColor : inactiveColor)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background((isActive ? activeColor : inactiveColor).opacity(0.1))
        .cornerRadius(12)
    }
}

@available(iOS 14.0, *)
struct ListingDetailAdditionalSection: View {
    let listing: Listing
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ListingDetailSectionHeader(
                title: "Additional Information",
                icon: "doc.text.fill",
                color: .orange
            )
            
            if !listing.notes.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "note.text")
                            .foregroundColor(.orange)
                        Text("Notes")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(listing.notes)
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
            }
            
            // Tags section (if any were added)
            if !listing.tags.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "tag.fill")
                            .foregroundColor(.orange)
                        Text("Tags")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                    }
                    
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 80))
                    ], spacing: 8) {
                        ForEach(listing.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                }
            }
            
            // Keywords section (if any were added)
            if !listing.keywords.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "key.fill")
                            .foregroundColor(.orange)
                        Text("Keywords")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                    }
                    
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 80))
                    ], spacing: 8) {
                        ForEach(listing.keywords, id: \.self) { keyword in
                            Text(keyword)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

@available(iOS 14.0, *)
struct ListingDetailCustomFieldsSection: View {
    let listing: Listing
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ListingDetailSectionHeader(
                title: "Custom Fields",
                icon: "slider.horizontal.3",
                color: .yellow
            )
            
            VStack(spacing: 12) {
                ListingDetailFieldRow(
                    title: "Custom Field 1",
                    value: listing.customField1,
                    icon: "1.circle.fill",
                    color: .orange
                )
                ListingDetailFieldRow(
                    title: "Custom Field 2",
                    value: listing.customField2,
                    icon: "2.circle.fill",
                    color: .pink
                )
                ListingDetailFieldRow(
                    title: "Custom Field 3",
                    value: listing.customField3,
                    icon: "3.circle.fill",
                    color: .green
                )
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

@available(iOS 14.0, *)
extension DateFormatter {
       static let fullDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}
