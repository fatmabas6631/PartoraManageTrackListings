import SwiftUI

@available(iOS 14.0, *)
struct PartListRowView: View {
    let part: Part
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Section
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "gear.badge.checkmark")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(part.partNumber)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(part.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("$\(String(format: "%.2f", Double(part.priceCents) / 100))")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "cube.box.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.orange)
                        Text("\(part.quantityOnHand)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.orange)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            // Details Grid
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    PartListInfoCard(icon: "building.2.fill", title: "Supplier", value: part.supplierName, color: .blue)
                    PartListInfoCard(icon: "tag.fill", title: "Category", value: part.category, color: .orange)
                }
                
                HStack(spacing: 12) {
                    PartListInfoCard(icon: "location.fill", title: "Location", value: part.storageLocation, color: .green)
                    PartListInfoCard(icon: "building.columns.fill", title: "Manufacturer", value: part.manufacturer, color: .purple)
                }
                
                HStack(spacing: 12) {
                    PartListInfoCard(icon: "cube.fill", title: "Material", value: part.material, color: .red)
                    PartListInfoCard(icon: "paintbrush.fill", title: "Color", value: part.color, color: .pink)
                }
                
                HStack(spacing: 12) {
                    PartListInfoCard(icon: "scalemass.fill", title: "Weight", value: "\(part.weightGrams)g", color: .red)
                    PartListInfoCard(icon: "shield.fill", title: "Warranty", value: "\(part.warrantyMonths)mo", color: .blue)
                }
                
                if !part.notes.isEmpty {
                    HStack(spacing: 8) {
                        Image(systemName: "note.text")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Text(part.notes)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}
