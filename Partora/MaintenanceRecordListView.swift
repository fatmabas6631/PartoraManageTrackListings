import SwiftUI

@available(iOS 14.0, *)
struct MaintenanceRecordListView: View {
    @ObservedObject var dataManager: FactoryDataManager
    @State private var searchText = ""
    @State private var isSearching = false
    
    var filteredRecords: [MaintenanceRecord] {
        if searchText.isEmpty {
            return dataManager.maintenanceRecords
        } else {
            return dataManager.maintenanceRecords.filter { record in
                record.performedBy.localizedCaseInsensitiveContains(searchText) ||
                record.serviceType.localizedCaseInsensitiveContains(searchText) ||
                record.location.localizedCaseInsensitiveContains(searchText) ||
                record.status.localizedCaseInsensitiveContains(searchText) ||
                record.notes.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.05)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                MaintenanceRecordSearchBarView(searchText: $searchText, isSearching: $isSearching)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                if filteredRecords.isEmpty {
                    MaintenanceRecordNoDataView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredRecords) { record in
                                NavigationLink(destination: MaintenanceRecordDetailView(record: record)) {
                                    MaintenanceRecordListRowView(record: record)
                                        .onLongPressGesture {
                                            // iOS 14 compatible swipe-to-delete alternative
                                            if let index = dataManager.maintenanceRecords.firstIndex(where: { $0.id == record.id }) {
                                                dataManager.deleteMaintenanceRecord(at: IndexSet(integer: index))
                                            }
                                        }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    }
                }
            }
        }
        .navigationTitle("Maintenance Records")
        .navigationBarItems(
            trailing: NavigationLink(destination: MaintenanceRecordAddView(dataManager: dataManager)) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
        )
    }
}

@available(iOS 14.0, *)
struct MaintenanceRecordSearchBarView: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    @State private var animateIcon = false
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .scaleEffect(animateIcon ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: animateIcon)
                
                TextField("Search maintenance records...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .onTapGesture {
                        isSearching = true
                        animateIcon = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            animateIcon = false
                        }
                    }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        isSearching = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
            
            if isSearching {
                Button("Cancel") {
                    searchText = ""
                    isSearching = false
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .foregroundColor(.blue)
                .transition(.move(edge: .trailing))
                .animation(.easeInOut, value: isSearching)
            }
        }
    }
}

@available(iOS 14.0, *)
struct MaintenanceRecordListRowView: View {
    let record: MaintenanceRecord
    
    private var statusColor: Color {
        switch record.status.lowercased() {
        case "completed": return .green
        case "in progress": return .orange
        case "pending": return .yellow
        case "cancelled": return .red
        default: return .gray
        }
    }
    
    private var priorityColor: Color {
        switch record.priorityLevel {
        case 1: return .green
        case 2: return .yellow
        case 3: return .orange
        case 4, 5: return .red
        default: return .gray
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header Section
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "wrench.and.screwdriver.fill")
                            .foregroundColor(.blue)
                            .font(.title3)
                        
                        Text(record.serviceType.isEmpty ? "Service" : record.serviceType)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        // Status Badge
                        Text(record.status.isEmpty ? "Unknown" : record.status)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(statusColor.opacity(0.2))
                            .foregroundColor(statusColor)
                            .cornerRadius(8)
                    }
                    
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.secondary)
                            .font(.caption)
                        
                        Text(record.performedBy.isEmpty ? "Unknown Technician" : record.performedBy)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            Divider()
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            
            // Content Grid
            VStack(spacing: 12) {
                HStack(spacing: 16) {
                    MaintenanceRecordInfoCard(
                        icon: "calendar",
                        title: "Service Date",
                        value: DateFormatter.shortDate.string(from: record.serviceDate),
                        color: .blue
                    )
                    
                    MaintenanceRecordInfoCard(
                        icon: "dollarsign.circle",
                        title: "Cost",
                        value: "$\(String(format: "%.2f", Double(record.costCents) / 100.0))",
                        color: .green
                    )

                }
                
                HStack(spacing: 16) {
                    MaintenanceRecordInfoCard(
                        icon: "clock",
                        title: "Duration",
                        value: "\(record.durationMinutes) min",
                        color: .orange
                    )
                    
                    MaintenanceRecordInfoCard(
                        icon: "location",
                        title: "Location",
                        value: record.location.isEmpty ? "Not specified" : record.location,
                        color: .purple
                    )
                }
                
                if record.priorityLevel > 0 {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(priorityColor)
                        
                        Text("Priority Level: \(record.priorityLevel)")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(priorityColor)
                        
                        Spacer()
                        
                        if record.warrantyClaim {
                            HStack {
                                Image(systemName: "checkmark.shield.fill")
                                    .foregroundColor(.green)
                                Text("Warranty")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                
                if !record.notes.isEmpty {
                    HStack {
                        Image(systemName: "note.text")
                            .foregroundColor(.secondary)
                        
                        Text(record.notes)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                }
            }.padding(.horizontal)
            .padding(.bottom, 16)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

@available(iOS 14.0, *)
struct MaintenanceRecordInfoCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.caption)
                
                Text(title)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
            }
            
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

@available(iOS 14.0, *)
struct MaintenanceRecordNoDataView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.1)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "wrench.and.screwdriver")
                    .font(.system(size: 50))
                    .foregroundColor(.blue)
            }
            
            VStack(spacing: 8) {
                Text("No Maintenance Records")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Start by adding your first maintenance record to track equipment service history.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
    }
}


