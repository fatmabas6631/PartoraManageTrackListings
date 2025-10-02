import SwiftUI

@available(iOS 14.0, *)
struct SaleRecordListView: View {
    @StateObject private var manager = FactoryDataManager()
    @State private var searchText = ""
    @State private var showingAddView = false
    
    var filteredRecords: [SaleRecord] {
        if searchText.isEmpty {
            return manager.saleRecords
        } else {
            return manager.saleRecords.filter { record in
                record.customerName.localizedCaseInsensitiveContains(searchText) ||
                record.invoiceNumber.localizedCaseInsensitiveContains(searchText) ||
                record.salesperson.localizedCaseInsensitiveContains(searchText) ||
                record.paymentStatus.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
            VStack(spacing: 0) {
                SaleRecordSearchBarView(searchText: $searchText)
                
                if filteredRecords.isEmpty {
                    SaleRecordNoDataView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredRecords) { record in
                                NavigationLink(destination: SaleRecordDetailView(record: record)) {
                                    SaleRecordListRowView(record: record)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    }
                }
            }
            .navigationTitle("Sales Records")
            .navigationBarItems(
                trailing: Button(action: {
                    showingAddView = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            )
            .sheet(isPresented: $showingAddView) {
                SaleRecordAddView(manager: manager)
            }
        
    }
}

@available(iOS 14.0, *)
struct SaleRecordSearchBarView: View {
    @Binding var searchText: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .font(.system(size: 16, weight: .medium))
                
                TextField("Search sales records...", text: $searchText, onEditingChanged: { editing in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isEditing = editing
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
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isEditing ? Color.blue : Color.clear, lineWidth: 2)
                    )
            )
            .scaleEffect(isEditing ? 1.02 : 1.0)
            
            if isEditing {
                Button("Cancel") {
                    searchText = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .foregroundColor(.blue)
                .transition(.move(edge: .trailing))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .animation(.easeInOut(duration: 0.2), value: isEditing)
    }
}

@available(iOS 14.0, *)
struct SaleRecordListRowView: View {
    let record: SaleRecord
    
    private var formattedTotal: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = record.currency.isEmpty ? "USD" : record.currency
        return formatter.string(from: NSNumber(value: Double(record.totalCents) / 100.0)) ?? "$0.00"
    }
    
    private var statusColor: Color {
        switch record.paymentStatus.lowercased() {
        case "paid": return .green
        case "pending": return .orange
        case "overdue": return .red
        default: return .gray
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Section
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "doc.text.fill")
                            .foregroundColor(.blue)
                            .font(.system(size: 16, weight: .semibold))
                        
                        Text(record.invoiceNumber)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    
                    Text(record.customerName)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(formattedTotal)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(statusColor)
                            .frame(width: 8, height: 8)
                        
                        Text(record.paymentStatus)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(statusColor)
                            .textCase(.uppercase)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            // Details Grid
            VStack(spacing: 12) {
                Divider()
                    .padding(.horizontal, 16)
                
                // Row 1
                HStack(spacing: 16) {
                    SaleRecordInfoItem(
                        icon: "person.fill",
                        title: "Salesperson",
                        value: record.salesperson.isEmpty ? "N/A" : record.salesperson,
                        color: .purple
                    )
                    
                    SaleRecordInfoItem(
                        icon: "calendar",
                        title: "Date",
                        value: DateFormatter.shortDate.string(from: record.createdAt),
                        color: .red
                    )
                }
                
                // Row 2
                HStack(spacing: 16) {
                    SaleRecordInfoItem(
                        icon: "truck.box.fill",
                        title: "Delivery",
                        value: record.deliveryStatus.isEmpty ? "N/A" : record.deliveryStatus,
                        color: .green
                    )
                    
                    SaleRecordInfoItem(
                        icon: "envelope.fill",
                        title: "Contact",
                        value: record.contactEmail.isEmpty ? "N/A" : record.contactEmail,
                        color: .yellow
                    )
                }
                
                // Row 3
                HStack(spacing: 16) {
                    SaleRecordInfoItem(
                        icon: "location.fill",
                        title: "Shipping",
                        value: record.shippingAddress.isEmpty ? "N/A" : String(record.shippingAddress.prefix(30)) + (record.shippingAddress.count > 30 ? "..." : ""),
                        color: .orange
                    )
                    
                    SaleRecordInfoItem(
                        icon: "number.square.fill",
                        title: "Tracking",
                        value: record.trackingNumber.isEmpty ? "N/A" : record.trackingNumber,
                        color: .purple
                    )
                }
                
                // Tags Section
                if !record.tags.isEmpty {
                    HStack {
                        Image(systemName: "tag.fill")
                            .foregroundColor(.pink)
                            .font(.system(size: 12))
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach(record.tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.system(size: 10, weight: .medium))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(
                                            Capsule()
                                                .fill(Color.pink.opacity(0.2))
                                        )
                                        .foregroundColor(.pink)
                                }
                            }
                            .padding(.horizontal, 1)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                }
            }
            .padding(.bottom, 16)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
}

@available(iOS 14.0, *)
struct SaleRecordInfoItem: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 14, weight: .semibold))
                .frame(width: 16)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                
                Text(value)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

@available(iOS 14.0, *)
struct SaleRecordNoDataView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "doc.text.magnifyingglass")
                    .font(.system(size: 64, weight: .light))
                    .foregroundColor(.gray)
                
                VStack(spacing: 8) {
                    Text("No Sales Records Found")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("Start by adding your first sale record using the + button above")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
            }
            
            Spacer()
        }
    }
}

@available(iOS 14.0, *)
extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}
