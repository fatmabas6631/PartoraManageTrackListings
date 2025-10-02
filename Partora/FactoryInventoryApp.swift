import SwiftUI

@available(iOS 14.0, *)
struct DashboardView: View {
    @ObservedObject var dataManager = FactoryDataManager()
    
    var body: some View {
        NavigationView{
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Factory Dashboard")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Overview of your operations")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    
                    // Stats Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        StatCard(
                            title: "Listings",
                            count: dataManager.listings.count,
                            color: .blue,
                            icon: "cube.box"
                        )
                        
                        StatCard(
                            title: "Inventory Items",
                            count: dataManager.inventoryItems.count,
                            color: .green,
                            icon: "list.bullet.rectangle"
                        )
                        
                        StatCard(
                            title: "Maintenance Records",
                            count: dataManager.maintenanceRecords.count,
                            color: .orange,
                            icon: "wrench.and.screwdriver"
                        )
                        
                        StatCard(
                            title: "Sales Records",
                            count: dataManager.saleRecords.count,
                            color: .purple,
                            icon: "dollarsign.circle"
                        )
                        
                        StatCard(
                            title: "Contacts",
                            count: dataManager.contactRecords.count,
                            color: .red,
                            icon: "person.2"
                        )
                        
                        StatCard(
                            title: "Parts",
                            count: dataManager.parts.count,
                            color: .green,
                            icon: "gear"
                        )
                    }
                    .padding(.horizontal)
                    
                    // Quick Actions
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Quick Actions")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            NavigationLink(destination: ListingListView(dataManager: dataManager)) {
                                QuickActionCard(
                                    title: "Manage Listings",
                                    icon: "cube.box",
                                    color: .blue
                                )
                            }
                            
                            NavigationLink(destination: InventoryItemListView(dataManager: dataManager)) {
                                QuickActionCard(
                                    title: "View Inventory",
                                    icon: "list.bullet.rectangle",
                                    color: .green
                                )
                            }
                            
                            NavigationLink(destination: MaintenanceRecordListView(dataManager: dataManager )) {
                                QuickActionCard(
                                    title: "Maintenance",
                                    icon: "wrench.and.screwdriver",
                                    color: .orange
                                )
                            }
                            
                            NavigationLink(destination: SaleRecordListView()) {
                                QuickActionCard(
                                    title: "Sales Records",
                                    icon: "dollarsign.circle",
                                    color: .purple
                                )
                            }
                            
                            NavigationLink(destination: ContactRecordListView(dataManager: dataManager )) {
                                QuickActionCard(
                                    title: "Contacts",
                                    icon: "person.2",
                                    color: .red
                                )
                            }
                            
                            NavigationLink(destination: PartListView(dataManager: dataManager)) {
                                QuickActionCard(
                                    title: "Parts",
                                    icon: "gear",
                                    color: .orange
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Recent Activity
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Activity")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: 8) {
                            if let recentSale = dataManager.saleRecords.last {
                                ActivityRow(
                                    icon: "dollarsign.circle",
                                    title: "Recent Sale",
                                    subtitle: "\(recentSale.customerName) - \(formatCurrency(recentSale.totalCents))",
                                    color: .green
                                )
                            }
                            
                            if let recentMaintenance = dataManager.maintenanceRecords.last {
                                ActivityRow(
                                    icon: "wrench.and.screwdriver",
                                    title: "Recent Maintenance",
                                    subtitle: "\(recentMaintenance.serviceType) - \(formatCurrency(recentMaintenance.costCents))",
                                    color: .orange
                                )
                            }
                            
                            if let lowStockItem = dataManager.inventoryItems.first(where: { $0.quantity <= $0.reorderThreshold }) {
                                ActivityRow(
                                    icon: "exclamationmark.triangle",
                                    title: "Low Stock Alert",
                                    subtitle: "\(lowStockItem.location) - \(lowStockItem.quantity) remaining",
                                    color: .red
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    private func formatCurrency(_ cents: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: Double(cents) / 100)) ?? "$0.00"
    }
}

@available(iOS 14.0, *)
struct StatCard: View {
    let title: String
    let count: Int
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
                
                Text("\(count)")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

@available(iOS 14.0, *)
struct QuickActionCard: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
    }
}

@available(iOS 14.0, *)
struct ActivityRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

