import SwiftUI

@available(iOS 14.0, *)
struct SaleRecordDetailView: View {
    let record: SaleRecord
    
    private var formattedTotal: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = record.currency.isEmpty ? "USD" : record.currency
        return formatter.string(from: NSNumber(value: Double(record.totalCents) / 100.0)) ?? "$0.00"
    }
    
    private var formattedDiscount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = record.currency.isEmpty ? "USD" : record.currency
        return formatter.string(from: NSNumber(value: Double(record.discountCents) / 100.0)) ?? "$0.00"
    }
    
    private var formattedTax: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = record.currency.isEmpty ? "USD" : record.currency
        return formatter.string(from: NSNumber(value: Double(record.taxCents) / 100.0)) ?? "$0.00"
    }
    
    private var formattedRefund: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = record.currency.isEmpty ? "USD" : record.currency
        return formatter.string(from: NSNumber(value: Double(record.refundCents) / 100.0)) ?? "$0.00"
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Card
                SaleRecordDetailHeaderCard(record: record, formattedTotal: formattedTotal)
                
                // Financial Information
                SaleRecordDetailSectionView(
                    title: "Financial Details",
                    icon: "dollarsign.circle.fill",
                    color: .green
                ) {
                    VStack(spacing: 12) {
                        SaleRecordDetailFieldRow(
                            label: "Total Amount",
                            value: formattedTotal,
                            icon: "banknote.fill",
                            color: .green
                        )
                        
                        SaleRecordDetailFieldRow(
                            label: "Currency",
                            value: record.currency.isEmpty ? "USD" : record.currency,
                            icon: "globe",
                            color: .blue
                        )
                        
                        SaleRecordDetailFieldRow(
                            label: "Discount Applied",
                            value: formattedDiscount,
                            icon: "percent",
                            color: .orange
                        )
                        
                        SaleRecordDetailFieldRow(
                            label: "Tax Amount",
                            value: formattedTax,
                            icon: "doc.text.fill",
                            color: .purple
                        )
                        
                        if record.refundCents > 0 {
                            SaleRecordDetailFieldRow(
                                label: "Refund Amount",
                                value: formattedRefund,
                                icon: "arrow.counterclockwise.circle.fill",
                                color: .red
                            )
                        }
                    }
                }
                
                // Customer & Contact Information
                SaleRecordDetailSectionView(
                    title: "Customer Information",
                    icon: "person.circle.fill",
                    color: .blue
                ) {
                    VStack(spacing: 12) {
                        SaleRecordDetailFieldRow(
                            label: "Customer Name",
                            value: record.customerName.isEmpty ? "N/A" : record.customerName,
                            icon: "person.fill",
                            color: .blue
                        )
                        
                        SaleRecordDetailFieldRow(
                            label: "Contact Email",
                            value: record.contactEmail.isEmpty ? "N/A" : record.contactEmail,
                            icon: "envelope.fill",
                            color: .green
                        )
                        
                        SaleRecordDetailFieldRow(
                            label: "Contact Phone",
                            value: record.contactPhone.isEmpty ? "N/A" : record.contactPhone,
                            icon: "phone.fill",
                            color: .yellow
                        )
                        
                        SaleRecordDetailFieldRow(
                            label: "Salesperson",
                            value: record.salesperson.isEmpty ? "N/A" : record.salesperson,
                            icon: "person.badge.plus.fill",
                            color: .orange
                        )
                    }
                }
                
                // Address Information
                SaleRecordDetailSectionView(
                    title: "Address Information",
                    icon: "location.circle.fill",
                    color: .orange
                ) {
                    VStack(spacing: 12) {
                        SaleRecordDetailAddressRow(
                            label: "Shipping Address",
                            value: record.shippingAddress.isEmpty ? "N/A" : record.shippingAddress,
                            icon: "truck.box.fill",
                            color: .orange
                        )
                        
                        SaleRecordDetailAddressRow(
                            label: "Billing Address",
                            value: record.billingAddress.isEmpty ? "N/A" : record.billingAddress,
                            icon: "building.2.fill",
                            color: .gray
                        )
                    }
                }
                
                // Delivery & Tracking
                SaleRecordDetailSectionView(
                    title: "Delivery & Tracking",
                    icon: "shippingbox.circle.fill",
                    color: .purple
                ) {
                    VStack(spacing: 12) {
                        SaleRecordDetailFieldRow(
                            label: "Delivery Status",
                            value: record.deliveryStatus.isEmpty ? "N/A" : record.deliveryStatus,
                            icon: "truck.box.fill",
                            color: .purple
                        )
                        
                        SaleRecordDetailFieldRow(
                            label: "Tracking Number",
                            value: record.trackingNumber.isEmpty ? "N/A" : record.trackingNumber,
                            icon: "barcode.viewfinder",
                            color: .red
                        )
                        
                        if let deliveryDate = record.deliveryDate {
                            SaleRecordDetailFieldRow(
                                label: "Delivery Date",
                                value: DateFormatter.mediumDate.string(from: deliveryDate),
                                icon: "calendar.badge.clock",
                                color: .pink
                            )
                        }
                    }
                }
                
                // Important Dates
                SaleRecordDetailSectionView(
                    title: "Important Dates",
                    icon: "calendar.circle.fill",
                    color: .red
                ) {
                    VStack(spacing: 12) {
                        SaleRecordDetailFieldRow(
                            label: "Created Date",
                            value: DateFormatter.mediumDate.string(from: record.createdAt),
                            icon: "calendar.badge.plus",
                            color: .green
                        )
                        
                        SaleRecordDetailFieldRow(
                            label: "Due Date",
                            value: DateFormatter.mediumDate.string(from: record.dueDate),
                            icon: "calendar.badge.exclamationmark",
                            color: .red
                        )
                        
                        if let approvedDate = record.approvedDate {
                            SaleRecordDetailFieldRow(
                                label: "Approved Date",
                                value: DateFormatter.mediumDate.string(from: approvedDate),
                                icon: "checkmark.seal.fill",
                                color: .blue
                            )
                        }
                    }
                }
                
                // Approval & Notes
                SaleRecordDetailSectionView(
                    title: "Additional Information",
                    icon: "info.circle.fill",
                    color: .purple
                ) {
                    VStack(spacing: 12) {
                        if !record.approvedBy.isEmpty {
                            SaleRecordDetailFieldRow(
                                label: "Approved By",
                                value: record.approvedBy,
                                icon: "checkmark.seal.fill",
                                color: .green
                            )
                        }
                        
                        if !record.notes.isEmpty {
                            SaleRecordDetailNotesRow(
                                label: "Notes",
                                value: record.notes,
                                icon: "note.text",
                                color: .yellow
                            )
                        }
                        
                        if !record.cancellationReason.isEmpty {
                            SaleRecordDetailNotesRow(
                                label: "Cancellation Reason",
                                value: record.cancellationReason,
                                icon: "xmark.circle.fill",
                                color: .red
                            )
                        }
                    }
                }
                
                // Custom Fields
                if !record.customField1.isEmpty || !record.customField2.isEmpty || !record.customField3.isEmpty {
                    SaleRecordDetailSectionView(
                        title: "Custom Fields",
                        icon: "square.and.pencil",
                        color: .gray
                    ) {
                        VStack(spacing: 12) {
                            if !record.customField1.isEmpty {
                                SaleRecordDetailFieldRow(
                                    label: "Custom Field 1",
                                    value: record.customField1,
                                    icon: "1.square.fill",
                                    color: .gray
                                )
                            }
                            
                            if !record.customField2.isEmpty {
                                SaleRecordDetailFieldRow(
                                    label: "Custom Field 2",
                                    value: record.customField2,
                                    icon: "2.square.fill",
                                    color: .gray
                                )
                            }
                            
                            if !record.customField3.isEmpty {
                                SaleRecordDetailFieldRow(
                                    label: "Custom Field 3",
                                    value: record.customField3,
                                    icon: "3.square.fill",
                                    color: .gray
                                )
                            }
                        }
                    }
                }
                
                // Tags
                if !record.tags.isEmpty {
                    SaleRecordDetailTagsSection(tags: record.tags)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .navigationTitle("Sale Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

@available(iOS 14.0, *)
struct SaleRecordDetailHeaderCard: View {
    let record: SaleRecord
    let formattedTotal: String
    
    private var statusColor: Color {
        switch record.paymentStatus.lowercased() {
        case "paid": return .green
        case "pending": return .orange
        case "overdue": return .red
        case "cancelled": return .gray
        case "refunded": return .purple
        default: return .gray
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Top Row
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Invoice")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                    
                    Text(record.invoiceNumber)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Total")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                    
                    Text(formattedTotal)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                }
            }
            
            // Status Badge
            HStack {
                HStack(spacing: 8) {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 12, height: 12)
                    
                    Text(record.paymentStatus)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(statusColor)
                        .textCase(.uppercase)
                }
                
                Spacer()
                
                Text(record.customerName)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.primary)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(.systemBackground),
                            Color(.systemGray6).opacity(0.3)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.black.opacity(0.1), radius: 12, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [statusColor.opacity(0.3), statusColor.opacity(0.1)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
    }
}

@available(iOS 14.0, *)
struct SaleRecordDetailSectionView<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    let content: Content
    
    init(title: String, icon: String, color: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.color = color
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 20, weight: .semibold))
                
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            content
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
}

@available(iOS 14.0, *)
struct SaleRecordDetailFieldRow: View {
    let label: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 16, weight: .semibold))
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                
                Text(value)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

@available(iOS 14.0, *)
struct SaleRecordDetailAddressRow: View {
    let label: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 16, weight: .semibold))
                    .frame(width: 20)
                
                Text(label)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
            }
            
            Text(value)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
                .padding(.leading, 28)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 4)
    }
}

@available(iOS 14.0, *)
struct SaleRecordDetailNotesRow: View {
    let label: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 16, weight: .semibold))
                    .frame(width: 20)
                
                Text(label)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
            }
            
            Text(value)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
                .padding(.leading, 28)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray6))
                )
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 4)
    }
}

@available(iOS 14.0, *)
struct SaleRecordDetailTagsSection: View {
    let tags: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "tag.circle.fill")
                    .foregroundColor(.pink)
                    .font(.system(size: 20, weight: .semibold))
                
                Text("Tags")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 100), spacing: 8)
            ], spacing: 8) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(.system(size: 14, weight: .medium))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.pink.opacity(0.2),
                                            Color.pink.opacity(0.1)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .foregroundColor(.pink)
                        .overlay(
                            Capsule()
                                .stroke(Color.pink.opacity(0.3), lineWidth: 1)
                        )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
}

@available(iOS 14.0, *)
extension DateFormatter {
    static let mediumDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}
