
import SwiftUI

@available(iOS 14.0, *)
struct InventoryItemAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataManager: FactoryDataManager
    @State private var newItem = InventoryItem(listingID: UUID())
    
    // Form state
    @State private var selectedListingID: UUID = UUID()
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isSuccessAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(.systemGray6), Color(.systemGray5)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header Card
                        VStack {
                            HStack {
                                Image(systemName: "cube.box.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.blue)
                                Text("Add Inventory Item")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }
                            .padding()
                            
                            Text("Fill in all required fields to add a new inventory item")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                        
                        // Basic Information Section
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "info.circle.fill")
                                    .foregroundColor(.blue)
                                Text("Basic Information")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            Divider()
                            
                            // Listing Selection
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "list.bullet")
                                        .foregroundColor(.blue)
                                        .frame(width: 20)
                                    Text("Product Listing")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    Spacer()
                                }
                                
                                Picker("Select Listing", selection: $selectedListingID) {
                                    Text("Select a product").tag(UUID())
                                    ForEach(dataManager.listings) { listing in
                                        Text(listing.title).tag(listing.id)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .onChange(of: selectedListingID) { newValue in
                                    newItem.listingID = newValue
                                }
                            }
                            .padding(.horizontal)
                            
                            // Location Fields
                            VStack(alignment: .leading, spacing: 12) {
                                IconTextFieldI(icon: "mappin.circle.fill", iconColor: .green, placeholder: "Location", text: $newItem.location)
                                IconTextFieldI(icon: "number.circle.fill", iconColor: .orange, placeholder: "Aisle", text: $newItem.aisle)
                                IconTextFieldI(icon: "square.stack.3d.down.right.fill", iconColor: .purple, placeholder: "Shelf", text: $newItem.shelf)
                                IconTextFieldI(icon: "archivebox.fill", iconColor: .red, placeholder: "Bin", text: $newItem.bin)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                        
                        // Quantity & Pricing Section
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "chart.bar.fill")
                                    .foregroundColor(.green)
                                Text("Quantity & Pricing")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 12) {
                                IconNumberField(icon: "number.circle.fill", iconColor: .blue, placeholder: "Quantity", value: $newItem.quantity)
                                IconNumberField(icon: "exclamationmark.triangle.fill", iconColor: .orange, placeholder: "Reorder Threshold", value: $newItem.reorderThreshold)
                                IconNumberField(icon: "dollarsign.circle.fill", iconColor: .green, placeholder: "Unit Cost (Cents)", value: $newItem.unitCostCents)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                        
                        // Batch & Dates Section
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "calendar.circle.fill")
                                    .foregroundColor(.purple)
                                Text("Batch & Dates")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 12) {
                                IconTextFieldI(icon: "barcode.viewfinder", iconColor: .blue, placeholder: "Lot Number", text: $newItem.lotNumber)
                                IconTextFieldI(icon: "number.square.fill", iconColor: .green, placeholder: "Batch Code", text: $newItem.batchCode)
                                
                                DatePickerField(icon: "calendar.badge.plus", iconColor: .orange, title: "Received Date", date: $newItem.receivedDate)
                                DatePickerField(icon: "calendar.badge.minus", iconColor: .red, title: "Expiry Date", date: $newItem.expiryDate)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                        
                        // Status & Conditions Section
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "checkmark.shield.fill")
                                    .foregroundColor(.red)
                                Text("Status & Conditions")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 12) {
                                IconTextFieldI(icon: "thermometer", iconColor: .orange, placeholder: "Temperature Requirement", text: $newItem.temperatureRequirement)
                                IconTextFieldI(icon: "drop.fill", iconColor: .blue, placeholder: "Humidity Requirement", text: $newItem.humidityRequirement)
                                IconTextFieldI(icon: "cube.fill", iconColor: .gray, placeholder: "Storage Type", text: $newItem.storageType)
                                IconTextFieldI(icon: "note.text", iconColor: .orange, placeholder: "Condition", text: $newItem.condition)
                                
                                ToggleFieldI(icon: "exclamationmark.triangle.fill", iconColor: .red, title: "Is Damaged", isOn: $newItem.isDamaged)
                                ToggleFieldI(icon: "person.fill.checkmark", iconColor: .green, title: "Is Reserved", isOn: $newItem.isReserved)
                                
                                if newItem.isReserved {
                                    IconTextFieldI(icon: "person.fill", iconColor: .purple, placeholder: "Reserved By", text: $newItem.reservedBy)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                        
                        // Additional Information Section
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "ellipsis.circle.fill")
                                    .foregroundColor(.gray)
                                Text("Additional Information")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 12) {
                                IconTextFieldI(icon: "person.2.fill", iconColor: .blue, placeholder: "Last Audited By", text: $newItem.lastAuditedBy)
                                IconTextFieldI(icon: "building.2.fill", iconColor: .green, placeholder: "Supplier Reference", text: $newItem.supplierReference)
                                IconTextFieldI(icon: "doc.text.fill", iconColor: .purple, placeholder: "Stock Status", text: $newItem.stockStatus)
                                
                                MultiLineTextField(icon: "note.text", iconColor: .purple, placeholder: "Notes", text: $newItem.notes)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                        
                        // Action Buttons
                        HStack(spacing: 15) {
                            Button("Cancel") {
                                presentationMode.wrappedValue.dismiss()
                            }
                            .font(.headline)
                            .foregroundColor(.red)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            
                            Button("Save Item") {
                                saveInventoryItem()
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                    .padding(.top)
                }
            }
            .navigationBarHidden(true)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(isSuccessAlert ? "Success" : "Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if isSuccessAlert {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
            }
        }
    }
    
    private func saveInventoryItem() {
        // Validate required fields
        guard newItem.listingID != UUID() else {
            alertMessage = "Please select a product listing"
            isSuccessAlert = false
            showAlert = true
            return
        }
        
        guard !newItem.location.isEmpty else {
            alertMessage = "Please enter a location"
            isSuccessAlert = false
            showAlert = true
            return
        }
        
        guard newItem.quantity >= 0 else {
            alertMessage = "Please enter a valid quantity"
            isSuccessAlert = false
            showAlert = true
            return
        }
        
        // Calculate total value
        newItem.totalValueCents = newItem.quantity * newItem.unitCostCents
        newItem.lastCheckedAt = Date()
        
        dataManager.addInventoryItem(newItem)
        
        alertMessage = "Inventory item has been successfully saved!"
        isSuccessAlert = true
        showAlert = true
    }
}

@available(iOS 14.0, *)
struct InventoryItemListView: View {
    @ObservedObject var dataManager: FactoryDataManager
    @State private var searchText = ""
    @State private var showingAddView = false
    
    var filteredItems: [InventoryItem] {
        if searchText.isEmpty {
            return dataManager.inventoryItems
        }
        
        return dataManager.inventoryItems.filter { item in
            let listing = dataManager.listings.first { $0.id == item.listingID }
            return listing?.title.localizedCaseInsensitiveContains(searchText) == true ||
                   item.location.localizedCaseInsensitiveContains(searchText) == true ||
                   item.lotNumber.localizedCaseInsensitiveContains(searchText) == true ||
                   item.batchCode.localizedCaseInsensitiveContains(searchText) == true
        }
    }
    
    var body: some View {
            ZStack {
                // Background
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Custom Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search inventory items...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top)
                    
                    if filteredItems.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "cube.box")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            Text("No Inventory Items Found")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Text(searchText.isEmpty ? 
                                 "Add your first inventory item to get started" :
                                 "No items match your search criteria")
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        List {
                            ForEach(filteredItems) { item in
                                NavigationLink(destination: InventoryItemDetailView(item: item, dataManager: dataManager)) {
                                    InventoryItemCardView(item: item, dataManager: dataManager)
                                }
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets())
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                            }
                            .onDelete(perform: deleteItems)
                        }
                        .listStyle(PlainListStyle())
                    }
                }
            }
            .navigationTitle("Inventory Items")
            .navigationBarItems(trailing:
                Button(action: { showingAddView = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            )
            .sheet(isPresented: $showingAddView) {
                InventoryItemAddView(dataManager: dataManager)
            }
        
    }
    
    private func deleteItems(at offsets: IndexSet) {
        dataManager.deleteInventoryItem(at: offsets)
    }
}

@available(iOS 14.0, *)
struct InventoryItemCardView: View {
    let item: InventoryItem
    let dataManager: FactoryDataManager
    
    var listing: Listing? {
        dataManager.listings.first { $0.id == item.listingID }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text(listing?.title ?? "Unknown Product")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(listing?.brand ?? "No Brand")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Status indicator
                VStack(alignment: .trailing) {
                    Text("\(item.quantity) units")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(item.quantity <= item.reorderThreshold ? .red : .green)
                    
                    Text(item.stockStatus.isEmpty ? "In Stock" : item.stockStatus)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(item.isDamaged ? Color.red.opacity(0.2) : Color.green.opacity(0.2))
                        .cornerRadius(4)
                }
            }
            
            Divider()
            
            HStack(spacing: 20) {
                InfoCapsule(icon: "mappin.circle.fill", text: item.location, color: .blue)
                InfoCapsule(icon: "number.circle.fill", text: item.lotNumber, color: .orange)
                InfoCapsule(icon: "dollarsign.circle.fill", text: "\(item.unitCostCents)¢", color: .green)
            }
            
            HStack {
                InfoCapsule(icon: "calendar.circle.fill", 
                           text: formatDate(item.receivedDate), 
                           color: .purple)
                
                Spacer()
                
                if item.isDamaged {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text("Damaged")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                if item.isReserved {
                    Image(systemName: "person.fill.checkmark")
                        .foregroundColor(.orange)
                    Text("Reserved")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

@available(iOS 14.0, *)
struct InventoryItemDetailView: View {
    let item: InventoryItem
    let dataManager: FactoryDataManager
    
    var listing: Listing? {
        dataManager.listings.first { $0.id == item.listingID }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Card
                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: "cube.box.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text(listing?.title ?? "Unknown Product")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(listing?.brand ?? "No Brand")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    
                    HStack(spacing: 20) {
                        StatusBadge(icon: "number.circle.fill", 
                                  value: "\(item.quantity)", 
                                  label: "Quantity", 
                                  color: item.quantity <= item.reorderThreshold ? .red : .green)
                        
                        StatusBadge(icon: "dollarsign.circle.fill", 
                                  value: "\(item.totalValueCents)¢", 
                                  label: "Total Value", 
                                  color: .blue)
                        
                        StatusBadge(icon: "exclamationmark.triangle.fill",
                                  value: "\(item.reorderThreshold)",
                                  label: "Reorder At", 
                                  color: .orange)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                
                // Location Information
                DetailSection(title: "Location Information", icon: "mappin.circle.fill", iconColor: .green) {
                    DetailRowI(icon: "mappin", title: "Location", value: item.location)
                    DetailRowI(icon: "number", title: "Aisle", value: item.aisle)
                    DetailRowI(icon: "square.stack.3d.down.right", title: "Shelf", value: item.shelf)
                    DetailRowI(icon: "archivebox", title: "Bin", value: item.bin)
                    DetailRowI(icon: "cube", title: "Storage Type", value: item.storageType)
                }
                
                // Batch Information
                DetailSection(title: "Batch Information", icon: "barcode.viewfinder", iconColor: .orange) {
                    DetailRowI(icon: "number.square", title: "Lot Number", value: item.lotNumber)
                    DetailRowI(icon: "barcode", title: "Batch Code", value: item.batchCode)
                    DetailRowI(icon: "building", title: "Supplier Reference", value: item.supplierReference)
                }
                
                // Dates Information
                DetailSection(title: "Dates", icon: "calendar.circle.fill", iconColor: .purple) {
                    DetailRowI(icon: "calendar.badge.plus", title: "Received Date", value: formatDate(item.receivedDate))
                    DetailRowI(icon: "calendar.badge.minus", title: "Expiry Date", value: formatDate(item.expiryDate))
                    DetailRowI(icon: "clock", title: "Last Checked", value: formatDateTime(item.lastCheckedAt))
                    
                    if let reservedUntil = item.reservedUntil {
                        DetailRowI(icon: "person.fill.checkmark", title: "Reserved Until", value: formatDateTime(reservedUntil))
                    }
                }
                
                // Status & Conditions
                DetailSection(title: "Status & Conditions", icon: "checkmark.shield.fill", iconColor: .red) {
                    DetailRowI(icon: "note.text", title: "Condition", value: item.condition)
                    DetailRowI(icon: "chart.bar", title: "Stock Status", value: item.stockStatus)
                    DetailRowI(icon: "thermometer", title: "Temperature", value: item.temperatureRequirement)
                    DetailRowI(icon: "drop", title: "Humidity", value: item.humidityRequirement)
                    
                    ToggleRow(icon: "exclamationmark.triangle.fill", title: "Is Damaged", isOn: item.isDamaged)
                    ToggleRow(icon: "person.fill.checkmark", title: "Is Reserved", isOn: item.isReserved)
                    
                    if item.isReserved {
                        DetailRowI(icon: "person", title: "Reserved By", value: item.reservedBy)
                    }
                }
                
                // Audit Information
                DetailSection(title: "Audit Information", icon: "person.2.fill", iconColor: .blue) {
                    DetailRowI(icon: "person.fill", title: "Last Audited By", value: item.lastAuditedBy)
                    DetailRowI(icon: "clock.fill", title: "Last Checked", value: formatDateTime(item.lastCheckedAt))
                }
                
                // Notes
                if !item.notes.isEmpty {
                    DetailSection(title: "Notes", icon: "note.text", iconColor: .purple) {
                        Text(item.notes)
                            .font(.body)
                            .foregroundColor(.primary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGray6))
        .navigationBarTitle("Inventory Details", displayMode: .inline)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func formatDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}


@available(iOS 14.0, *)
struct IconTextFieldI: View {
    let icon: String
    let iconColor: Color
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .frame(width: 20)
            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

@available(iOS 14.0, *)
struct IconNumberField: View {
    let icon: String
    let iconColor: Color
    let placeholder: String
    @Binding var value: Int
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .frame(width: 20)
            TextField(placeholder, value: $value, formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

@available(iOS 14.0, *)
struct DatePickerField: View {
    let icon: String
    let iconColor: Color
    let title: String
    @Binding var date: Date
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .frame(width: 20)
            Text(title)
                .font(.subheadline)
            Spacer()
            DatePicker("", selection: $date, displayedComponents: .date)
                .labelsHidden()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

@available(iOS 14.0, *)
struct ToggleFieldI: View {
    let icon: String
    let iconColor: Color
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .frame(width: 20)
            Text(title)
                .font(.subheadline)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

@available(iOS 14.0, *)
struct MultiLineTextField: View {
    let icon: String
    let iconColor: Color
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                Text(placeholder)
                    .font(.subheadline)
                Spacer()
            }
            
            TextEditor(text: $text)
                .frame(minHeight: 80)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

@available(iOS 14.0, *)
struct InfoCapsule: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(color)
            Text(text.isEmpty ? "N/A" : text)
                .font(.caption)
                .lineLimit(1)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.2))
        .cornerRadius(8)
    }
}

@available(iOS 14.0, *)
struct StatusBadge: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

@available(iOS 14.0, *)
struct DetailSection<Content: View>: View {
    let title: String
    let icon: String
    let iconColor: Color
    let content: Content
    
    init(title: String, icon: String, iconColor: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.iconColor = iconColor
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding(.horizontal)
            
            Divider()
            
            VStack(spacing: 12) {
                content
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct DetailRowI: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            Text(title)
                .font(.subheadline)
                .foregroundColor(.primary)
            Spacer()
            Text(value.isEmpty ? "Not set" : value)
                .font(.subheadline)
                .foregroundColor(value.isEmpty ? .secondary : .primary)
        }
    }
}

@available(iOS 14.0, *)
struct ToggleRow: View {
    let icon: String
    let title: String
    let isOn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            Text(title)
                .font(.subheadline)
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: isOn ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(isOn ? .green : .red)
        }
    }
}

