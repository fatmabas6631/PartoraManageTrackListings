import SwiftUI

@available(iOS 14.0, *)
struct MaintenanceRecordDetailView: View {
    let record: MaintenanceRecord
    @State private var showingFullNotes = false
    @State private var showingSafetyNotes = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.1), Color.blue.opacity(0.05)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    MaintenanceRecordDetailHeaderView(record: record)
                    
                    // Service Overview Section
                    MaintenanceRecordDetailSectionView(
                        title: "Service Overview",
                        icon: "info.circle.fill",
                        color: .blue
                    ) {
                        VStack(spacing: 12) {
                            MaintenanceRecordDetailFieldRow(
                                label: "Service Type",
                                value: record.serviceType.isEmpty ? "Not specified" : record.serviceType,
                                icon: "wrench.and.screwdriver.fill",
                                color: .blue
                            )
                            
                            MaintenanceRecordDetailFieldRow(
                                label: "Performed By",
                                value: record.performedBy.isEmpty ? "Unknown" : record.performedBy,
                                icon: "person.fill",
                                color: .green
                            )
                            
                            MaintenanceRecordDetailFieldRow(
                                label: "Service Date",
                                value: DateFormatter.detailDate.string(from: record.serviceDate),
                                icon: "calendar",
                                color: .orange
                            )
                            
                            MaintenanceRecordDetailFieldRow(
                                label: "Location",
                                value: record.location.isEmpty ? "Not specified" : record.location,
                                icon: "location.fill",
                                color: .purple
                            )
                        }
                    }
                    
                    // Cost & Duration Section
                    MaintenanceRecordDetailSectionView(
                        title: "Cost & Duration",
                        icon: "dollarsign.circle.fill",
                        color: .green
                    ) {
                        HStack(spacing: 16) {
                            MaintenanceRecordDetailMetricCard(
                                title: "Total Cost",
                                value: "$\(String(format: "%.2f", Double(record.costCents) / 100.0))",
                                icon: "dollarsign.circle.fill",
                                color: .green
                            )
                            
                            MaintenanceRecordDetailMetricCard(
                                title: "Duration",
                                value: "\(record.durationMinutes) min",
                                icon: "clock.fill",
                                color: .blue
                            )
                        }
                    }
                    
                    // Status & Priority Section
                    MaintenanceRecordDetailSectionView(
                        title: "Status & Priority",
                        icon: "flag.fill",
                        color: .orange
                    ) {
                        VStack(spacing: 12) {
                            HStack(spacing: 16) {
                                MaintenanceRecordDetailStatusCard(
                                    title: "Status",
                                    value: record.status.isEmpty ? "Unknown" : record.status,
                                    color: statusColor(for: record.status)
                                )
                                
                                MaintenanceRecordDetailStatusCard(
                                    title: "Priority",
                                    value: "Level \(record.priorityLevel)",
                                    color: priorityColor(for: record.priorityLevel)
                                )
                            }
                            
                            if record.warrantyClaim {
                                MaintenanceRecordDetailWarrantyBadge()
                            }
                        }
                    }
                    
                    // Quality Assessment Section
                    MaintenanceRecordDetailSectionView(
                        title: "Quality Assessment",
                        icon: "star.fill",
                        color: .yellow
                    ) {
                        VStack(spacing: 12) {
                            MaintenanceRecordDetailFieldRow(
                                label: "Condition After Service",
                                value: record.conditionAfter.isEmpty ? "Not assessed" : record.conditionAfter,
                                icon: "gauge",
                                color: .blue
                            )
                            
                            MaintenanceRecordDetailRatingView(rating: record.rating)
                            
                            if record.nextServiceDate != nil {
                                MaintenanceRecordDetailFieldRow(
                                    label: "Next Service Due",
                                    value: DateFormatter.detailDate.string(from: record.nextServiceDate!),
                                    icon: "calendar.badge.clock",
                                    color: .orange
                                )
                            }
                        }
                    }
                    
                    // Approval Information Section
                    MaintenanceRecordDetailSectionView(
                        title: "Approval Information",
                        icon: "checkmark.shield.fill",
                        color: .green
                    ) {
                        VStack(spacing: 12) {
                            MaintenanceRecordDetailFieldRow(
                                label: "Approved By",
                                value: record.approvedBy.isEmpty ? "Pending approval" : record.approvedBy,
                                icon: "person.crop.circle.fill.badge.checkmark",
                                color: .green
                            )
                            
                            if record.approvedDate != nil {
                                MaintenanceRecordDetailFieldRow(
                                    label: "Approval Date",
                                    value: DateFormatter.detailDate.string(from: record.approvedDate!),
                                    icon: "checkmark.circle",
                                    color: .blue
                                )
                            }
                            
                            if !record.signature.isEmpty {
                                MaintenanceRecordDetailFieldRow(
                                    label: "Signature Reference",
                                    value: record.signature,
                                    icon: "signature",
                                    color: .purple
                                )
                            }
                        }
                    }
                    
                    // Documentation Section
                    MaintenanceRecordDetailSectionView(
                        title: "Documentation",
                        icon: "doc.text.fill",
                        color: .red
                    ) {
                        VStack(spacing: 12) {
                            if !record.notes.isEmpty {
                                MaintenanceRecordDetailNotesCard(
                                    title: "Service Notes",
                                    content: record.notes,
                                    icon: "note.text",
                                    isExpanded: $showingFullNotes
                                )
                            }
                            
                            if !record.safetyNotes.isEmpty {
                                MaintenanceRecordDetailNotesCard(
                                    title: "Safety Notes",
                                    content: record.safetyNotes,
                                    icon: "exclamationmark.shield.fill",
                                    isExpanded: $showingSafetyNotes
                                )
                            }
                            
                            if !record.documentPath.isEmpty {
                                MaintenanceRecordDetailFieldRow(
                                    label: "Document Reference",
                                    value: record.documentPath,
                                    icon: "doc.fill",
                                    color: .blue
                                )
                            }
                            
                            if !record.rejectionReason.isEmpty {
                                MaintenanceRecordDetailRejectionCard(reason: record.rejectionReason)
                            }
                        }
                    }
                    
                    // Custom Fields Section
                    if hasCustomFields() {
                        MaintenanceRecordDetailSectionView(
                            title: "Custom Fields",
                            icon: "slider.horizontal.3",
                            color: .purple
                        ) {
                            VStack(spacing: 12) {
                                if !record.customField1.isEmpty {
                                    MaintenanceRecordDetailFieldRow(
                                        label: "Custom Field 1",
                                        value: record.customField1,
                                        icon: "1.circle.fill",
                                        color: .orange
                                    )
                                }
                                
                                if !record.customField2.isEmpty {
                                    MaintenanceRecordDetailFieldRow(
                                        label: "Custom Field 2",
                                        value: record.customField2,
                                        icon: "2.circle.fill",
                                        color: .pink
                                    )
                                }
                                
                                if !record.customField3.isEmpty {
                                    MaintenanceRecordDetailFieldRow(
                                        label: "Custom Field 3",
                                        value: record.customField3,
                                        icon: "3.circle.fill",
                                        color: .red
                                    )
                                }
                                
                                if !record.customField4.isEmpty {
                                    MaintenanceRecordDetailFieldRow(
                                        label: "Custom Field 4",
                                        value: record.customField4,
                                        icon: "4.circle.fill",
                                        color: .yellow
                                    )
                                }
                                
                                if !record.customField5.isEmpty {
                                    MaintenanceRecordDetailFieldRow(
                                        label: "Custom Field 5",
                                        value: record.customField5,
                                        icon: "5.circle.fill",
                                        color: .red
                                    )
                                }
                            }
                        }
                    }
                    
                    // Timestamps Section
                    MaintenanceRecordDetailSectionView(
                        title: "Record Information",
                        icon: "clock.arrow.circlepath",
                        color: .gray
                    ) {
                        VStack(spacing: 12) {
                            MaintenanceRecordDetailFieldRow(
                                label: "Created",
                                value: DateFormatter.detailDateTime.string(from: record.createdAt),
                                icon: "plus.circle",
                                color: .gray
                            )
                            
                            MaintenanceRecordDetailFieldRow(
                                label: "Last Updated",
                                value: DateFormatter.detailDateTime.string(from: record.updatedAt),
                                icon: "pencil.circle",
                                color: .gray
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Maintenance Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func hasCustomFields() -> Bool {
        return !record.customField1.isEmpty ||
               !record.customField2.isEmpty ||
               !record.customField3.isEmpty ||
               !record.customField4.isEmpty ||
               !record.customField5.isEmpty
    }
    
    private func statusColor(for status: String) -> Color {
        switch status.lowercased() {
        case "completed": return .green
        case "in progress": return .orange
        case "pending": return .yellow
        case "cancelled": return .red
        default: return .gray
        }
    }
    
    private func priorityColor(for level: Int) -> Color {
        switch level {
        case 1: return .green
        case 2: return .yellow
        case 3: return .orange
        case 4, 5: return .red
        default: return .gray
        }
    }
}

@available(iOS 14.0, *)
struct MaintenanceRecordDetailHeaderView: View {
    let record: MaintenanceRecord
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.purple, Color.blue]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "wrench.and.screwdriver.fill")
                    .font(.system(size: 45))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 8) {
                Text(record.serviceType.isEmpty ? "Maintenance Service" : record.serviceType)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Record ID: \(record.id.uuidString.prefix(8))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
            }
        }
        .padding(.vertical, 20)
    }
}

@available(iOS 14.0, *)
struct MaintenanceRecordDetailSectionView<Content: View>: View {
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
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.title3)
                    
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                
                Spacer()
            }
            
            content
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

@available(iOS 14.0, *)
struct MaintenanceRecordDetailFieldRow: View {
    let label: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.body)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                
                Text(value)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

@available(iOS 14.0, *)
struct MaintenanceRecordDetailMetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

@available(iOS 14.0, *)
struct MaintenanceRecordDetailStatusCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

@available(iOS 14.0, *)
struct MaintenanceRecordDetailWarrantyBadge: View {
    var body: some View {
        HStack {
            Image(systemName: "checkmark.shield.fill")
                .foregroundColor(.green)
            
            Text("Warranty Claim")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.green)
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.green.opacity(0.1))
        .cornerRadius(8)
    }
}

@available(iOS 14.0, *)
struct MaintenanceRecordDetailRatingView: View {
    let rating: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
                .font(.body)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Service Rating")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                
                HStack(spacing: 4) {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= rating ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .font(.caption)
                    }
                    
                    Text("(\(rating)/5)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

@available(iOS 14.0, *)
struct MaintenanceRecordDetailNotesCard: View {
    let title: String
    let content: String
    let icon: String
    @Binding var isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: { isExpanded.toggle() }) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.blue)
                        .font(.body)
                    
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
            
            if isExpanded {
                Text(content)
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding(.top, 4)
            } else {
                Text(content)
                    .font(.body)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .padding(.top, 4)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(Color.blue.opacity(0.05))
        .cornerRadius(8)
    }
}

@available(iOS 14.0, *)
struct MaintenanceRecordDetailRejectionCard: View {
    let reason: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                
                Text("Rejection Reason")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.red)
            }
            
            Text(reason)
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(Color.red.opacity(0.05))
        .cornerRadius(8)
    }
}

extension DateFormatter {
    static let detailDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    
    static let detailDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}
