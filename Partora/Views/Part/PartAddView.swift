import SwiftUI

@available(iOS 14.0, *)
struct PartAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataManager: FactoryDataManager
    
    @State private var partNumber = ""
    @State private var description = ""
    @State private var quantityOnHand = ""
    @State private var supplierName = ""
    @State private var category = ""
    @State private var subcategory = ""
    @State private var weightGrams = ""
    @State private var lengthMM = ""
    @State private var widthMM = ""
    @State private var heightMM = ""
    @State private var material = ""
    @State private var color = ""
    @State private var priceCents = ""
    @State private var reorderThreshold = ""
    @State private var barcode = ""
    @State private var storageLocation = ""
    @State private var warrantyMonths = ""
    @State private var manufacturer = ""
    @State private var batchCode = ""
    @State private var lotNumber = ""
    @State private var notes = ""
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    PartAddHeaderView()
                    
                    LazyVStack(spacing: 20) {
                        PartAddSectionView(title: "Basic Information", icon: "info.circle.fill", color: .blue) {
                            VStack(spacing: 16) {
                                PartAddFieldView(title: "Part Number", text: $partNumber, icon: "number.circle.fill", isRequired: true)
                                PartAddFieldView(title: "Description", text: $description, icon: "text.alignleft", isRequired: true)
                                PartAddFieldView(title: "Supplier Name", text: $supplierName, icon: "building.2.fill", isRequired: true)
                            }
                        }
                        
                        PartAddSectionView(title: "Category & Classification", icon: "folder.fill", color: .orange) {
                            VStack(spacing: 16) {
                                PartAddFieldView(title: "Category", text: $category, icon: "tag.fill", isRequired: true)
                                PartAddFieldView(title: "Subcategory", text: $subcategory, icon: "tag", isRequired: true)
                                PartAddFieldView(title: "Material", text: $material, icon: "cube.fill", isRequired: true)
                                PartAddFieldView(title: "Color", text: $color, icon: "paintbrush.fill", isRequired: true)
                            }
                        }
                        
                        PartAddSectionView(title: "Inventory & Pricing", icon: "dollarsign.circle.fill", color: .green) {
                            VStack(spacing: 16) {
                                PartAddFieldView(title: "Quantity on Hand", text: $quantityOnHand, icon: "cube.box.fill", isRequired: true, keyboardType: .numberPad)
                                PartAddFieldView(title: "Price (Cents)", text: $priceCents, icon: "dollarsign.square.fill", isRequired: true, keyboardType: .numberPad)
                                PartAddFieldView(title: "Reorder Threshold", text: $reorderThreshold, icon: "exclamationmark.triangle.fill", isRequired: true, keyboardType: .numberPad)
                                PartAddFieldView(title: "Storage Location", text: $storageLocation, icon: "location.fill", isRequired: true)
                            }
                        }
                        
                        PartAddSectionView(title: "Physical Specifications", icon: "ruler.fill", color: .purple) {
                            VStack(spacing: 16) {
                                PartAddFieldView(title: "Weight (Grams)", text: $weightGrams, icon: "scalemass.fill", isRequired: true, keyboardType: .numberPad)
                                PartAddFieldView(title: "Length (MM)", text: $lengthMM, icon: "ruler", isRequired: true, keyboardType: .numberPad)
                                PartAddFieldView(title: "Width (MM)", text: $widthMM, icon: "ruler", isRequired: true, keyboardType: .numberPad)
                                PartAddFieldView(title: "Height (MM)", text: $heightMM, icon: "ruler", isRequired: true, keyboardType: .numberPad)
                            }
                        }
                        
                        PartAddSectionView(title: "Manufacturing & Quality", icon: "gear.badge.checkmark", color: .red) {
                            VStack(spacing: 16) {
                                PartAddFieldView(title: "Manufacturer", text: $manufacturer, icon: "building.columns.fill", isRequired: true)
                                PartAddFieldView(title: "Barcode", text: $barcode, icon: "barcode", isRequired: true)
                                PartAddFieldView(title: "Batch Code", text: $batchCode, icon: "qrcode", isRequired: true)
                                PartAddFieldView(title: "Lot Number", text: $lotNumber, icon: "number.square.fill", isRequired: true)
                                PartAddFieldView(title: "Warranty (Months)", text: $warrantyMonths, icon: "shield.fill", isRequired: true, keyboardType: .numberPad)
                            }
                        }
                        
                        PartAddSectionView(title: "Additional Notes", icon: "note.text", color: .green) {
                            PartAddTextAreaView(title: "Notes", text: $notes, icon: "text.quote")
                        }
                        
                        PartAddSubmitButtonView {
                            validateAndSave()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitle("Add New Part", displayMode: .large)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    validateAndSave()
                }
            )
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func validateAndSave() {
        var errors: [String] = []
        
        if partNumber.isEmpty { errors.append("Part Number") }
        if description.isEmpty { errors.append("Description") }
        if supplierName.isEmpty { errors.append("Supplier Name") }
        if category.isEmpty { errors.append("Category") }
        if subcategory.isEmpty { errors.append("Subcategory") }
        if material.isEmpty { errors.append("Material") }
        if color.isEmpty { errors.append("Color") }
        if quantityOnHand.isEmpty || Int(quantityOnHand) == nil { errors.append("Quantity on Hand") }
        if priceCents.isEmpty || Int(priceCents) == nil { errors.append("Price") }
        if reorderThreshold.isEmpty || Int(reorderThreshold) == nil { errors.append("Reorder Threshold") }
        if storageLocation.isEmpty { errors.append("Storage Location") }
        if weightGrams.isEmpty || Int(weightGrams) == nil { errors.append("Weight") }
        if lengthMM.isEmpty || Int(lengthMM) == nil { errors.append("Length") }
        if widthMM.isEmpty || Int(widthMM) == nil { errors.append("Width") }
        if heightMM.isEmpty || Int(heightMM) == nil { errors.append("Height") }
        if manufacturer.isEmpty { errors.append("Manufacturer") }
        if barcode.isEmpty { errors.append("Barcode") }
        if batchCode.isEmpty { errors.append("Batch Code") }
        if lotNumber.isEmpty { errors.append("Lot Number") }
        if warrantyMonths.isEmpty || Int(warrantyMonths) == nil { errors.append("Warranty Months") }
        
        if !errors.isEmpty {
            alertTitle = "Missing Required Fields"
            alertMessage = "Please fill in the following fields:\n\n" + errors.joined(separator: "\n")
            showingAlert = true
            return
        }
        
        let newPart = Part(
            partNumber: partNumber,
            description: description,
            quantityOnHand: Int(quantityOnHand) ?? 0,
            supplierName: supplierName,
            category: category,
            subcategory: subcategory,
            weightGrams: Int(weightGrams) ?? 0,
            lengthMM: Int(lengthMM) ?? 0,
            widthMM: Int(widthMM) ?? 0,
            heightMM: Int(heightMM) ?? 0,
            material: material,
            color: color,
            priceCents: Int(priceCents) ?? 0,
            reorderThreshold: Int(reorderThreshold) ?? 0,
            barcode: barcode,
            storageLocation: storageLocation,
            warrantyMonths: Int(warrantyMonths) ?? 0,
            manufacturer: manufacturer,
            batchCode: batchCode,
            lotNumber: lotNumber,
            notes: notes
        )
        
        dataManager.addPart(newPart)
        
        alertTitle = "Success!"
        alertMessage = "Part '\(partNumber)' has been successfully added to the inventory."
        showingAlert = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            presentationMode.wrappedValue.dismiss()
        }
    }
}
