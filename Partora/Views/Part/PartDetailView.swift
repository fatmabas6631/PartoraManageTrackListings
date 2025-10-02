import SwiftUI

@available(iOS 14.0, *)
struct PartDetailView: View {
    let part: Part
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                PartDetailHeaderView(part: part)
                
                VStack(spacing: 20) {
                    PartDetailSectionView(title: "Basic Information", icon: "info.circle.fill", color: .blue) {
                        VStack(spacing: 12) {
                            PartDetailFieldRow(label: "Part Number", value: part.partNumber, icon: "number.circle.fill")
                            PartDetailFieldRow(label: "Description", value: part.description, icon: "text.alignleft")
                            PartDetailFieldRow(label: "Supplier", value: part.supplierName, icon: "building.2.fill")
                            PartDetailFieldRow(label: "Manufacturer", value: part.manufacturer, icon: "building.columns.fill")
                        }
                    }
                    
                    PartDetailSectionView(title: "Category & Classification", icon: "folder.fill", color: .orange) {
                        VStack(spacing: 12) {
                            PartDetailFieldRow(label: "Category", value: part.category, icon: "tag.fill")
                            PartDetailFieldRow(label: "Subcategory", value: part.subcategory, icon: "tag")
                            PartDetailFieldRow(label: "Material", value: part.material, icon: "cube.fill")
                            PartDetailFieldRow(label: "Color", value: part.color, icon: "paintbrush.fill")
                        }
                    }
                    
                    PartDetailSectionView(title: "Inventory & Pricing", icon: "dollarsign.circle.fill", color: .green) {
                        VStack(spacing: 12) {
                            PartDetailFieldRow(label: "Quantity on Hand", value: "\(part.quantityOnHand)", icon: "cube.box.fill")
                            PartDetailFieldRow(label: "Price", value: "$\(String(format: "%.2f", Double(part.priceCents) / 100))", icon: "dollarsign.square.fill")
                            PartDetailFieldRow(label: "Reorder Threshold", value: "\(part.reorderThreshold)", icon: "exclamationmark.triangle.fill")
                            PartDetailFieldRow(label: "Storage Location", value: part.storageLocation, icon: "location.fill")
                        }
                    }
                    
                    PartDetailSectionView(title: "Physical Specifications", icon: "ruler.fill", color: .purple) {
                        VStack(spacing: 12) {
                            PartDetailFieldRow(label: "Weight", value: "\(part.weightGrams) grams", icon: "scalemass.fill")
                            PartDetailFieldRow(label: "Length", value: "\(part.lengthMM) mm", icon: "ruler")
                            PartDetailFieldRow(label: "Width", value: "\(part.widthMM) mm", icon: "ruler")
                            PartDetailFieldRow(label: "Height", value: "\(part.heightMM) mm", icon: "ruler")
                        }
                    }
                    
                    PartDetailSectionView(title: "Manufacturing & Quality", icon: "gear.badge.checkmark", color: .red) {
                        VStack(spacing: 12) {
                            PartDetailFieldRow(label: "Barcode", value: part.barcode, icon: "barcode")
                            PartDetailFieldRow(label: "Batch Code", value: part.batchCode, icon: "qrcode")
                            PartDetailFieldRow(label: "Lot Number", value: part.lotNumber, icon: "number.square.fill")
                            PartDetailFieldRow(label: "Warranty", value: "\(part.warrantyMonths) months", icon: "shield.fill")
                        }
                    }
                    
                    PartDetailSectionView(title: "Dates & Status", icon: "calendar.circle.fill", color: .red) {
                        VStack(spacing: 12) {
                            PartDetailFieldRow(label: "Created", value: DateFormatter.shortDate.string(from: part.createdAt), icon: "calendar.badge.plus")
                            PartDetailFieldRow(label: "Updated", value: DateFormatter.shortDate.string(from: part.updatedAt), icon: "calendar.badge.clock")
                            PartDetailFieldRow(label: "Status", value: part.isActive ? "Active" : "Inactive", icon: "checkmark.circle.fill")
                            if let expiryDate = part.expiryDate {
                                PartDetailFieldRow(label: "Expiry Date", value: DateFormatter.shortDate.string(from: expiryDate), icon: "calendar.badge.exclamationmark")
                            }
                        }
                    }
                    
                    if !part.notes.isEmpty {
                        PartDetailSectionView(title: "Additional Notes", icon: "note.text", color: .green) {
                            PartDetailNotesView(notes: part.notes)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitle("Part Details", displayMode: .inline)
    }
}
