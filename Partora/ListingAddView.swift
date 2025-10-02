
import SwiftUI

@available(iOS 14.0, *)
struct ListingAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataManager: FactoryDataManager
    
    @State private var sku = ""
    @State private var title = ""
    @State private var details = ""
    @State private var brand = ""
    @State private var category = ""
    @State private var subcategory = ""
    @State private var modelNumber = ""
    @State private var serialNumber = ""
    @State private var priceCents = ""
    @State private var weightGrams = ""
    @State private var lengthMM = ""
    @State private var widthMM = ""
    @State private var heightMM = ""
    @State private var color = ""
    @State private var material = ""
    @State private var status = "Active"
    @State private var barcode = ""
    @State private var manufacturer = ""
    @State private var warrantyMonths = ""
    @State private var notes = ""
    @State private var rating = 0.0
    @State private var isActive = true
    @State private var isFeatured = false
    @State private var storageLocation = ""
    @State private var unitOfMeasure = ""
    @State private var minOrderQty = ""
    @State private var maxOrderQty = ""
    @State private var customField1 = ""
    @State private var customField2 = ""
    @State private var customField3 = ""
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    ListingAddHeaderView()
                    
                    LazyVStack(spacing: 20) {
                        ListingAddSectionHeaderView(title: "Basic Information", icon: "info.circle.fill", color: .blue)
                        ListingAddBasicSection(
                            sku: $sku,
                            title: $title,
                            details: $details,
                            brand: $brand,
                            category: $category,
                            subcategory: $subcategory
                        )
                        
                        ListingAddSectionHeaderView(title: "Product Details", icon: "cube.box.fill", color: .green)
                        ListingAddProductSection(
                            modelNumber: $modelNumber,
                            serialNumber: $serialNumber,
                            barcode: $barcode,
                            manufacturer: $manufacturer,
                            material: $material,
                            color: $color
                        )
                        
                        ListingAddSectionHeaderView(title: "Pricing & Measurements", icon: "dollarsign.circle.fill", color: .orange)
                        ListingAddPricingSection(
                            priceCents: $priceCents,
                            weightGrams: $weightGrams,
                            lengthMM: $lengthMM,
                            widthMM: $widthMM,
                            heightMM: $heightMM,
                            unitOfMeasure: $unitOfMeasure
                        )
                        
                        ListingAddSectionHeaderView(title: "Inventory & Status", icon: "archivebox.fill", color: .purple)
                        ListingAddInventorySection(
                            status: $status,
                            storageLocation: $storageLocation,
                            minOrderQty: $minOrderQty,
                            maxOrderQty: $maxOrderQty,
                            warrantyMonths: $warrantyMonths,
                            isActive: $isActive,
                            isFeatured: $isFeatured
                        )
                        
                        ListingAddSectionHeaderView(title: "Additional Information", icon: "doc.text.fill", color: .red)
                        ListingAddAdditionalSection(
                            notes: $notes,
                            rating: $rating,
                            customField1: $customField1,
                            customField2: $customField2,
                            customField3: $customField3
                        )
                        
                        ListingAddSubmitButton(action: validateAndSave)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color(.systemBackground), Color(.systemGray6)]), startPoint: .top, endPoint: .bottom))
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.red),
            )
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func validateAndSave() {
        var errors: [String] = []
        
        if sku.isEmpty { errors.append("SKU is required") }
        if title.isEmpty { errors.append("Title is required") }
        if brand.isEmpty { errors.append("Brand is required") }
        if category.isEmpty { errors.append("Category is required") }
        if modelNumber.isEmpty { errors.append("Model Number is required") }
        if serialNumber.isEmpty { errors.append("Serial Number is required") }
        if priceCents.isEmpty { errors.append("Price is required") }
        if weightGrams.isEmpty { errors.append("Weight is required") }
        if lengthMM.isEmpty { errors.append("Length is required") }
        if widthMM.isEmpty { errors.append("Width is required") }
        if heightMM.isEmpty { errors.append("Height is required") }
        if color.isEmpty { errors.append("Color is required") }
        if material.isEmpty { errors.append("Material is required") }
        if manufacturer.isEmpty { errors.append("Manufacturer is required") }
        if storageLocation.isEmpty { errors.append("Storage Location is required") }
        
        if !errors.isEmpty {
            alertTitle = "Validation Errors"
            alertMessage = errors.joined(separator: "\n• ")
            showAlert = true
            return
        }
        
        let newListing = Listing(
            sku: sku,
            title: title,
            details: details,
            brand: brand,
            category: category,
            subcategory: subcategory,
            modelNumber: modelNumber,
            serialNumber: serialNumber,
            priceCents: Int(priceCents) ?? 0,
            weightGrams: Int(weightGrams) ?? 0,
            lengthMM: Int(lengthMM) ?? 0,
            widthMM: Int(widthMM) ?? 0,
            heightMM: Int(heightMM) ?? 0,
            color: color,
            material: material,
            status: status,
            barcode: barcode,
            manufacturer: manufacturer,
            warrantyMonths: Int(warrantyMonths) ?? 0,
            notes: notes,
            rating: rating,
            isActive: isActive,
            isFeatured: isFeatured,
            storageLocation: storageLocation,
            unitOfMeasure: unitOfMeasure,
            minOrderQty: Int(minOrderQty) ?? 0,
            maxOrderQty: Int(maxOrderQty) ?? 0,
            customField1: customField1,
            customField2: customField2,
            customField3: customField3
        )
        
        dataManager.addListing(newListing)
        
        alertTitle = "Success"
        alertMessage = "Listing '\(title)' has been successfully created!"
        showAlert = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ListingAddHeaderView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
                .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
            
            Text("Create New Listing")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Fill in all required fields to add a new product listing")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

@available(iOS 14.0, *)
struct ListingAddSectionHeaderView: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30, height: 30)
                .background(color.opacity(0.1))
                .clipShape(Circle())
            
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Spacer()
            
            Rectangle()
                .fill(color.opacity(0.3))
                .frame(height: 2)
                .frame(maxWidth: 100)
        }
        .padding(.horizontal, 5)
        .padding(.top, 10)
    }
}

@available(iOS 14.0, *)
struct ListingAddFieldView: View {
    let title: String
    let icon: String
    @Binding var text: String
    let placeholder: String
    let keyboardType: UIKeyboardType
    
    init(title: String, icon: String, text: Binding<String>, placeholder: String = "", keyboardType: UIKeyboardType = .default) {
        self.title = title
        self.icon = icon
        self._text = text
        self.placeholder = placeholder.isEmpty ? title : placeholder
        self.keyboardType = keyboardType
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 20)
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .padding(.horizontal, 15)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(text.isEmpty ? Color.clear : Color.blue, lineWidth: 1)
                )
        }
    }
}

@available(iOS 14.0, *)
struct ListingAddBasicSection: View {
    @Binding var sku: String
    @Binding var title: String
    @Binding var details: String
    @Binding var brand: String
    @Binding var category: String
    @Binding var subcategory: String
    
    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                ListingAddFieldView(title: "SKU *", icon: "barcode", text: $sku)
                ListingAddFieldView(title: "Brand *", icon: "building.2", text: $brand)
            }
            
            ListingAddFieldView(title: "Product Title *", icon: "textformat", text: $title)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "doc.text")
                        .foregroundColor(.blue)
                        .frame(width: 20)
                    Text("Product Details")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                
                TextEditor(text: $details)
                    .frame(height: 80)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(details.isEmpty ? Color.clear : Color.blue, lineWidth: 1)
                    )
            }
            
            HStack(spacing: 15) {
                ListingAddFieldView(title: "Category *", icon: "folder", text: $category)
                ListingAddFieldView(title: "Subcategory", icon: "folder.badge.plus", text: $subcategory)
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

@available(iOS 14.0, *)
struct ListingAddProductSection: View {
    @Binding var modelNumber: String
    @Binding var serialNumber: String
    @Binding var barcode: String
    @Binding var manufacturer: String
    @Binding var material: String
    @Binding var color: String
    
    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                ListingAddFieldView(title: "Model Number *", icon: "number", text: $modelNumber)
                ListingAddFieldView(title: "Serial Number *", icon: "qrcode", text: $serialNumber)
            }
            
            HStack(spacing: 15) {
                ListingAddFieldView(title: "Barcode", icon: "barcode.viewfinder", text: $barcode)
                ListingAddFieldView(title: "Manufacturer *", icon: "building.columns", text: $manufacturer)
            }
            
            HStack(spacing: 15) {
                ListingAddFieldView(title: "Material *", icon: "cube", text: $material)
                ListingAddFieldView(title: "Color *", icon: "paintpalette", text: $color)
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

@available(iOS 14.0, *)
struct ListingAddPricingSection: View {
    @Binding var priceCents: String
    @Binding var weightGrams: String
    @Binding var lengthMM: String
    @Binding var widthMM: String
    @Binding var heightMM: String
    @Binding var unitOfMeasure: String
    
    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                ListingAddFieldView(title: "Price (cents) *", icon: "dollarsign.circle", text: $priceCents, keyboardType: .numberPad)
                ListingAddFieldView(title: "Weight (g) *", icon: "scalemass", text: $weightGrams, keyboardType: .numberPad)
            }
            
            HStack(spacing: 15) {
                ListingAddFieldView(title: "Length (mm) *", icon: "ruler", text: $lengthMM, keyboardType: .numberPad)
                ListingAddFieldView(title: "Width (mm) *", icon: "ruler.fill", text: $widthMM, keyboardType: .numberPad)
            }
            
            HStack(spacing: 15) {
                ListingAddFieldView(title: "Height (mm) *", icon: "arrow.up.and.down", text: $heightMM, keyboardType: .numberPad)
                ListingAddFieldView(title: "Unit of Measure", icon: "square.grid.3x3", text: $unitOfMeasure)
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

@available(iOS 14.0, *)
struct ListingAddInventorySection: View {
    @Binding var status: String
    @Binding var storageLocation: String
    @Binding var minOrderQty: String
    @Binding var maxOrderQty: String
    @Binding var warrantyMonths: String
    @Binding var isActive: Bool
    @Binding var isFeatured: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                ListingAddFieldView(title: "Status", icon: "checkmark.circle", text: $status)
                ListingAddFieldView(title: "Storage Location *", icon: "location", text: $storageLocation)
            }
            
            HStack(spacing: 15) {
                ListingAddFieldView(title: "Min Order Qty", icon: "minus.circle", text: $minOrderQty, keyboardType: .numberPad)
                ListingAddFieldView(title: "Max Order Qty", icon: "plus.circle", text: $maxOrderQty, keyboardType: .numberPad)
            }
            
            ListingAddFieldView(title: "Warranty (months)", icon: "shield", text: $warrantyMonths, keyboardType: .numberPad)
            
            HStack(spacing: 30) {
                ListingAddToggleView(title: "Active", icon: "power", isOn: $isActive, color: .green)
                ListingAddToggleView(title: "Featured", icon: "star.fill", isOn: $isFeatured, color: .yellow)
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

@available(iOS 14.0, *)
struct ListingAddToggleView: View {
    let title: String
    let icon: String
    @Binding var isOn: Bool
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(isOn ? color : .gray)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .scaleEffect(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(isOn ? color.opacity(0.1) : Color(.systemGray6))
        .cornerRadius(12)
    }
}

@available(iOS 14.0, *)
struct ListingAddAdditionalSection: View {
    @Binding var notes: String
    @Binding var rating: Double
    @Binding var customField1: String
    @Binding var customField2: String
    @Binding var customField3: String
    
    var body: some View {
        VStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "doc.plaintext")
                        .foregroundColor(.blue)
                        .frame(width: 20)
                    Text("Notes")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                
                TextEditor(text: $notes)
                    .frame(height: 80)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.blue)
                        .frame(width: 20)
                    Text("Rating")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Slider(value: $rating, in: 0...5, step: 0.5)
                    Text(String(format: "%.1f", rating))
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(width: 40)
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            
            ListingAddFieldView(title: "Custom Field 1", icon: "1.circle", text: $customField1)
            ListingAddFieldView(title: "Custom Field 2", icon: "2.circle", text: $customField2)
            ListingAddFieldView(title: "Custom Field 3", icon: "3.circle", text: $customField3)
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

@available(iOS 14.0, *)
struct ListingAddSubmitButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                Text("Create Listing")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(15)
            .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .padding(.top, 20)
    }
}
