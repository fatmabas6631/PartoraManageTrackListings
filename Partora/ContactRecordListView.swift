import SwiftUI

@available(iOS 14.0, *)
struct ContactRecordListView: View {
    @ObservedObject var dataManager: FactoryDataManager
    @State private var searchText = ""
    @State private var showingAddView = false
    @State private var selectedContact: ContactRecord?
    
    private var filteredContacts: [ContactRecord] {
        if searchText.isEmpty {
            return dataManager.contactRecords
        } else {
            return dataManager.contactRecords.filter { contact in
                contact.name.localizedCaseInsensitiveContains(searchText) ||
                contact.company.localizedCaseInsensitiveContains(searchText) ||
                contact.role.localizedCaseInsensitiveContains(searchText) ||
                contact.email.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
            VStack(spacing: 0) {
                ContactRecordListHeaderView(showingAddView: $showingAddView)
                
                ContactRecordSearchBarView(searchText: $searchText)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                
                if filteredContacts.isEmpty {
                    ContactRecordNoDataView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredContacts) { contact in
                                ContactRecordListRowView(
                                    contact: contact,
                                    onTap: {
                                        selectedContact = contact
                                    },
                                    onDelete: {
                                        deleteContact(contact)
                                    }
                                )
                                .padding(.horizontal, 16)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                Spacer()
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        
        .sheet(isPresented: $showingAddView) {
            ContactRecordAddView(dataManager: dataManager)
        }
        .sheet(item: $selectedContact) { contact in
            ContactRecordDetailView(contact: contact, dataManager: dataManager)
        }
    }
    
    private func deleteContact(_ contact: ContactRecord) {
        if let index = dataManager.contactRecords.firstIndex(where: { $0.id == contact.id }) {
            dataManager.deleteContactRecord(at: IndexSet(integer: index))
        }
    }
}

@available(iOS 14.0, *)
struct ContactRecordListHeaderView: View {
    @Binding var showingAddView: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.green.opacity(0.8), Color.blue.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 0))
            
            HStack {
                // Back Button
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left.circle.fill")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(.white)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Contacts")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Manage your business contacts")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
                
                Spacer()
                
                // Add Button
                Button(action: {
                    showingAddView = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(.white)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
}

@available(iOS 14.0, *)
struct ContactRecordSearchBarView: View {
    @Binding var searchText: String
    @State private var isSearching = false
    
    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSearching ? .blue : .secondary)
                    .animation(.easeInOut(duration: 0.2), value: isSearching)
                
                TextField("Search contacts...", text: $searchText, onEditingChanged: { editing in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isSearching = editing
                    }
                })
                .font(.body)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            .scaleEffect(isSearching ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSearching)
        }
    }
}

@available(iOS 14.0, *)
struct ContactRecordListRowView: View {
    let contact: ContactRecord
    let onTap: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGFloat = 0
    @State private var showingDeleteButton = false
    
    var body: some View {
        ZStack {
            // Delete button background
            HStack {
                Spacer()
                Button(action: onDelete) {
                    VStack(spacing: 4) {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 20, weight: .semibold))
                        Text("Delete")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .frame(width: 80, height: 120)
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .opacity(showingDeleteButton ? 1 : 0)
            }
            
            // Main content
            Button(action: onTap) {
                HStack(spacing: 16) {
                    ContactRecordListAvatarView(contact: contact)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ContactRecordListMainInfoView(contact: contact)
                        ContactRecordListContactInfoView(contact: contact)
                        ContactRecordListBusinessInfoView(contact: contact)
                        ContactRecordListLocationInfoView(contact: contact)
                        ContactRecordListStatusInfoView(contact: contact)
                    }
                    
                    Spacer()
                    
                    ContactRecordListChevronView()
                }
                .padding(16)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(PlainButtonStyle())
            .offset(x: offset)
        }
    }
}

@available(iOS 14.0, *)
struct ContactRecordListAvatarView: View {
    let contact: ContactRecord
    
    private var initials: String {
        let components = contact.name.components(separatedBy: " ")
        let firstInitial = components.first?.first?.uppercased() ?? ""
        let lastInitial = components.count > 1 ? components.last?.first?.uppercased() ?? "" : ""
        return firstInitial + lastInitial
    }
    
    private var avatarColor: Color {
        let colors: [Color] = [.blue, .green, .orange, .purple, .red, .pink, .orange, .purple]
        let index = abs(contact.name.hashValue) % colors.count
        return colors[index]
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(avatarColor.opacity(0.2))
                .frame(width: 60, height: 60)
            
            Text(initials)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(avatarColor)
        }
    }
}

@available(iOS 14.0, *)
struct ContactRecordListMainInfoView: View {
    let contact: ContactRecord
    
    var body: some View {
        HStack(spacing: 8) {
            Text(contact.name)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .lineLimit(1)
            
            if contact.isSupplier {
                Image(systemName: "truck.box.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.orange)
            }
            
            if contact.isCustomer {
                Image(systemName: "cart.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.green)
            }
            
            Spacer()
            
            ContactRecordListRatingView(rating: contact.rating)
        }
        
        HStack(spacing: 4) {
            Image(systemName: "briefcase.fill")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            
            Text(contact.role)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .lineLimit(1)
            
            Text("at")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(contact.company)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
                .lineLimit(1)
        }
    }
}

@available(iOS 14.0, *)
struct ContactRecordListContactInfoView: View {
    let contact: ContactRecord
    
    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 4) {
                Image(systemName: "phone.fill")
                    .font(.system(size: 10))
                    .foregroundColor(.green)
                
                Text(contact.phone)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            HStack(spacing: 4) {
                Image(systemName: "envelope.fill")
                    .font(.system(size: 10))
                    .foregroundColor(.blue)
                
                Text(contact.email)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
    }
}

@available(iOS 14.0, *)
struct ContactRecordListBusinessInfoView: View {
    let contact: ContactRecord
    
    var body: some View {
        HStack(spacing: 12) {
            if !contact.department.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.purple)
                    
                    Text(contact.department)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            if !contact.position.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.yellow)
                    
                    Text(contact.position)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
        }
    }
}

@available(iOS 14.0, *)
struct ContactRecordListLocationInfoView: View {
    let contact: ContactRecord
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "location.fill")
                .font(.system(size: 10))
                .foregroundColor(.red)
            
            Text("\(contact.city), \(contact.country)")
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
            
            Spacer()
            
            if !contact.preferredContactMethod.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.green)
                    
                    Text(contact.preferredContactMethod)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

@available(iOS 14.0, *)
struct ContactRecordListStatusInfoView: View {
    let contact: ContactRecord
    
    var body: some View {
        HStack(spacing: 8) {
            if !contact.status.isEmpty {
                HStack(spacing: 4) {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 8, height: 8)
                    
                    Text(contact.status)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(statusColor)
                }
            }
            
            Spacer()
            
            Text(formatDate(contact.createdAt))
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
    
    private var statusColor: Color {
        switch contact.status.lowercased() {
        case "active": return .green
        case "inactive": return .gray
        case "pending": return .orange
        case "blocked": return .red
        default: return .secondary
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

@available(iOS 14.0, *)
struct ContactRecordListRatingView: View {
    let rating: Int
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
                    .font(.system(size: 10))
                    .foregroundColor(star <= rating ? .yellow : .gray)
            }
        }
    }
}

@available(iOS 14.0, *)
struct ContactRecordListChevronView: View {
    var body: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.secondary)
    }
}

@available(iOS 14.0, *)
struct ContactRecordNoDataView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "person.3.fill")
                .font(.system(size: 80, weight: .thin))
                .foregroundColor(.secondary.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("No Contacts Found")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("Add your first contact to get started")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Image(systemName: "arrow.up.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(.blue)
                .opacity(0.7)
        }
        .padding(40)
    }
}
