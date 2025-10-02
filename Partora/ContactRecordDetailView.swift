
import SwiftUI

@available(iOS 14.0, *)
struct ContactRecordDetailView: View {
    let contact: ContactRecord
    @ObservedObject var dataManager: FactoryDataManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    ContactRecordDetailHeaderView(contact: contact)
                    
                    LazyVStack(spacing: 24) {
                        ContactRecordDetailPersonalSection(contact: contact)
                        ContactRecordDetailContactSection(contact: contact)
                        ContactRecordDetailBusinessSection(contact: contact)
                        ContactRecordDetailLocationSection(contact: contact)
                        ContactRecordDetailPreferencesSection(contact: contact)
                        ContactRecordDetailFinancialSection(contact: contact)
                        ContactRecordDetailAdditionalSection(contact: contact)
                        ContactRecordDetailMetadataSection(contact: contact)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .overlay(
                ContactRecordDetailCloseButton(action: {
                    presentationMode.wrappedValue.dismiss()
                })
                .padding(.top, 50)
                .padding(.trailing, 20)
                , alignment: .topTrailing
            )
        }
    }
}

@available(iOS 14.0, *)
struct ContactRecordDetailHeaderView: View {
    let contact: ContactRecord
    
    private var initials: String {
        let components = contact.name.components(separatedBy: " ")
        let firstInitial = components.first?.first?.uppercased() ?? ""
        let lastInitial = components.count > 1 ? components.last?.first?.uppercased() ?? "" : ""
        return firstInitial + lastInitial
    }
    
    private var avatarColor: Color {
        let colors: [Color] = [.blue, .green, .orange, .purple, .red, .pink, .green, .yellow]
        let index = abs(contact.name.hashValue) % colors.count
        return colors[index]
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [avatarColor.opacity(0.8), avatarColor.opacity(0.4)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 0))
            
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 100, height: 100)
                    
                    Text(initials)
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 4) {
                    Text(contact.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(contact.role)
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text(contact.company)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                ContactRecordDetailRatingView(rating: contact.rating)
            }
            .padding(.top, 20)
        }
    }
}

@available(iOS 14.0, *)
struct ContactRecordDetailRatingView: View {
    let rating: Int
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
                    .font(.system(size: 16))
                    .foregroundColor(star <= rating ? .yellow : .white.opacity(0.5))
            }
            
            Text("(\(rating)/5)")
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

@available(iOS 14.0, *)
struct ContactRecordDetailPersonalSection: View {
    let contact: ContactRecord
    
    var body: some View {
        ContactRecordDetailSectionContainer(
            title: "Personal Information",
            icon: "person.circle.fill",
            color: .blue
        ) {
            VStack(spacing: 16) {
                ContactRecordDetailFieldRow(
                    label: "Full Name",
                    value: contact.name,
                    icon: "person.fill",
                    color: .blue
                )
                
                ContactRecordDetailFieldRow(
                    label: "Role",
                    value: contact.role,
                    icon: "briefcase.fill",
                    color: .purple
                )
                
                ContactRecordDetailFieldRow(
                    label: "Department",
                    value: contact.department.isEmpty ? "Not specified" : contact.department,
                    icon: "person.3.fill",
                    color: .red
                )
                
                ContactRecordDetailFieldRow(
                    label: "Position",
                    value: contact.position.isEmpty ? "Not specified" : contact.position,
                    icon: "star.fill",
                    color: .yellow
                )
                
                ContactRecordDetailFieldRow(
                    label: "Contact Person",
                    value: contact.contactPerson.isEmpty ? "Not specified" : contact.contactPerson,
                    icon: "person.crop.circle",
                    color: .green
                )
            }
        }
    }
}

@available(iOS 14.0, *)
struct ContactRecordDetailContactSection: View {
    let contact: ContactRecord
    
    var body: some View {
        ContactRecordDetailSectionContainer(
            title: "Contact Information",
            icon: "phone.circle.fill",
            color: .green
        ) {
            VStack(spacing: 16) {
                ContactRecordDetailFieldRow(
                    label: "Phone Number",
                    value: contact.phone,
                    icon: "phone.fill",
                    color: .green
                )
                
                ContactRecordDetailFieldRow(
                    label: "Email Address",
                    value: contact.email,
                    icon: "envelope.fill",
                    color: .blue
                )
                
                ContactRecordDetailFieldRow(
                    label: "Website",
                    value: contact.website.isEmpty ? "Not provided" : contact.website,
                    icon: "globe",
                    color: .orange
                )
                
                ContactRecordDetailFieldRow(
                    label: "Preferred Contact",
                    value: contact.preferredContactMethod.isEmpty ? "Not specified" : contact.preferredContactMethod,
                    icon: "bubble.left.and.bubble.right.fill",
                    color: .purple
                )
            }
        }
    }
}

@available(iOS 14.0, *)
struct ContactRecordDetailBusinessSection: View {
    let contact: ContactRecord
    
    var body: some View {
        ContactRecordDetailSectionContainer(
            title: "Business Details",
            icon: "building.2.circle.fill",
            color: .orange
        ) {
            VStack(spacing: 16) {
                ContactRecordDetailFieldRow(
                    label: "Company",
                    value: contact.company,
                    icon: "building.2.fill",
                    color: .orange
                )
                
                ContactRecordDetailToggleRow(
                    label: "Is Supplier",
                    value: contact.isSupplier,
                    icon: "truck.box.fill",
                    color: .orange
                )
                
                ContactRecordDetailToggleRow(
                    label: "Is Customer",
                    value: contact.isCustomer,
                    icon: "cart.fill",
                    color: .green
                )
                
                ContactRecordDetailFieldRow(
                    label: "Status",
                    value: contact.status.isEmpty ? "Not specified" : contact.status,
                    icon: "checkmark.circle.fill",
                    color: statusColor(contact.status)
                )
            }
        }
    }
    
    private func statusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "active": return .green
        case "inactive": return .gray
        case "pending": return .orange
        case "blocked": return .red
        default: return .secondary
        }
    }
}

@available(iOS 14.0, *)
struct ContactRecordDetailLocationSection: View {
    let contact: ContactRecord
    
    var body: some View {
        ContactRecordDetailSectionContainer(
            title: "Location Information",
            icon: "location.circle.fill",
            color: .red
        ) {
            VStack(spacing: 16) {
                ContactRecordDetailFieldRow(
                    label: "Street Address",
                    value: contact.address,
                    icon: "house.fill",
                    color: .red
                )
                
                HStack(spacing: 12) {
                    ContactRecordDetailFieldRow(
                        label: "City",
                        value: contact.city,
                        icon: "building.fill",
                        color: .blue
                    )
                    
                    ContactRecordDetailFieldRow(
                        label: "Country",
                        value: contact.country,
                        icon: "flag.fill",
                        color: .green
                    )
                }
                
                ContactRecordDetailFieldRow(
                    label: "Postal Code",
                    value: contact.postalCode.isEmpty ? "Not provided" : contact.postalCode,
                    icon: "number",
                    color: .purple
                )
            }
        }
    }
}

@available(iOS 14.0, *)
struct ContactRecordDetailPreferencesSection: View {
    let contact: ContactRecord
    
    var body: some View {
        ContactRecordDetailSectionContainer(
            title: "Preferences",
            icon: "gear.circle.fill",
            color: .orange
        ) {
            VStack(spacing: 16) {
                ContactRecordDetailFieldRow(
                    label: "Language",
                    value: contact.language.isEmpty ? "Not specified" : contact.language,
                    icon: "globe",
                    color: .green
                )
                
                ContactRecordDetailFieldRow(
                    label: "Timezone",
                    value: contact.timezone.isEmpty ? "Not specified" : contact.timezone,
                    icon: "clock.fill",
                    color: .blue
                )
            }
        }
    }
}

@available(iOS 14.0, *)
struct ContactRecordDetailFinancialSection: View {
    let contact: ContactRecord
    
    var body: some View {
        ContactRecordDetailSectionContainer(
            title: "Financial Information",
            icon: "creditcard.circle.fill",
            color: .pink
        ) {
            VStack(spacing: 16) {
                ContactRecordDetailFieldRow(
                    label: "Tax ID",
                    value: contact.taxID.isEmpty ? "Not provided" : contact.taxID,
                    icon: "doc.text.fill",
                    color: .pink
                )
                
                ContactRecordDetailFieldRow(
                    label: "Bank Account",
                    value: contact.bankAccount.isEmpty ? "Not provided" : contact.bankAccount,
                    icon: "banknote.fill",
                    color: .green
                )
                
                ContactRecordDetailFieldRow(
                    label: "Payment Terms",
                    value: contact.paymentTerms.isEmpty ? "Not specified" : contact.paymentTerms,
                    icon: "calendar.badge.clock",
                    color: .orange
                )
            }
        }
    }
}

@available(iOS 14.0, *)
struct ContactRecordDetailAdditionalSection: View {
    let contact: ContactRecord
    
    var body: some View {
        ContactRecordDetailSectionContainer(
            title: "Additional Information",
            icon: "doc.circle.fill",
            color: .orange
        ) {
            VStack(spacing: 16) {
                if !contact.notes.isEmpty {
                    ContactRecordDetailNotesRow(
                        label: "Notes",
                        value: contact.notes,
                        icon: "note.text",
                        color: .green
                    )
                }
                
                ContactRecordDetailFieldRow(
                    label: "Custom Field 1",
                    value: contact.customField1.isEmpty ? "Not provided" : contact.customField1,
                    icon: "1.circle.fill",
                    color: .blue
                )
                
                ContactRecordDetailFieldRow(
                    label: "Custom Field 2",
                    value: contact.customField2.isEmpty ? "Not provided" : contact.customField2,
                    icon: "2.circle.fill",
                    color: .green
                )
                
                ContactRecordDetailFieldRow(
                    label: "Custom Field 3",
                    value: contact.customField3.isEmpty ? "Not provided" : contact.customField3,
                    icon: "3.circle.fill",
                    color: .orange
                )
            }
        }
    }
}

@available(iOS 14.0, *)
struct ContactRecordDetailMetadataSection: View {
    let contact: ContactRecord
    
    var body: some View {
        ContactRecordDetailSectionContainer(
            title: "Record Information",
            icon: "info.circle.fill",
            color: .gray
        ) {
            VStack(spacing: 16) {
                ContactRecordDetailFieldRow(
                    label: "Created At",
                    value: formatDate(contact.createdAt),
                    icon: "calendar.badge.plus",
                    color: .blue
                )
                
                ContactRecordDetailFieldRow(
                    label: "Updated At",
                    value: formatDate(contact.updatedAt),
                    icon: "calendar.badge.clock",
                    color: .orange
                )
                
                ContactRecordDetailFieldRow(
                    label: "Record ID",
                    value: contact.id.uuidString,
                    icon: "number",
                    color: .gray
                )
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

@available(iOS 14.0, *)
struct ContactRecordDetailSectionContainer<Content: View>: View {
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
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(color)
                    .frame(width: 40, height: 40)
                    .background(color.opacity(0.1))
                    .clipShape(Circle())
                
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            content
        }
        .padding(24)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
    }
}

@available(iOS 14.0, *)
struct ContactRecordDetailFieldRow: View {
    let label: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
                .frame(width: 24, height: 24)
                .background(color.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

@available(iOS 14.0, *)
struct ContactRecordDetailToggleRow: View {
    let label: String
    let value: Bool
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
                .frame(width: 24, height: 24)
                .background(color.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    Image(systemName: value ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(value ? .green : .red)
                    
                    Text(value ? "Yes" : "No")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(value ? .green : .red)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

@available(iOS 14.0, *)
struct ContactRecordDetailNotesRow: View {
    let label: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(color)
                    .frame(width: 24, height: 24)
                    .background(color.opacity(0.1))
                    .clipShape(Circle())
                
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            
            Text(value)
                .font(.body)
                .foregroundColor(.primary)
                .padding(16)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

@available(iOS 14.0, *)
struct ContactRecordDetailCloseButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(.white)
                .background(Color.black.opacity(0.2))
                .clipShape(Circle())
        }
    }
}
