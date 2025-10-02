import Foundation
import SwiftUI

struct Listing: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var sku: String = ""
    var title: String = ""
    var details: String = ""
    var brand: String = ""
    var tags: [String] = []
    var category: String = ""
    var subcategory: String = ""
    var modelNumber: String = ""
    var serialNumber: String = ""
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    var priceCents: Int = 0
    var weightGrams: Int = 0
    var lengthMM: Int = 0
    var widthMM: Int = 0
    var heightMM: Int = 0
    var color: String = ""
    var material: String = ""
    var status: String = ""
    var barcode: String = ""
    var manufacturer: String = ""
    var warrantyMonths: Int = 0
    var notes: String = ""
    var rating: Double = 0.0
    var isActive: Bool = true
    var isFeatured: Bool = false
    var keywords: [String] = []
    var storageLocation: String = ""
    var supplierID: UUID?
    var imagePaths: [String] = []
    var unitOfMeasure: String = ""
    var minOrderQty: Int = 0
    var maxOrderQty: Int = 0
    var customField1: String = ""
    var customField2: String = ""
    var customField3: String = ""
}

struct InventoryItem: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var listingID: UUID
    var location: String = ""
    var quantity: Int = 0
    var reorderThreshold: Int = 0
    var lotNumber: String = ""
    var batchCode: String = ""
    var receivedDate: Date = Date()
    var expiryDate: Date = Date()
    var condition: String = ""
    var storageType: String = ""
    var aisle: String = ""
    var shelf: String = ""
    var bin: String = ""
    var unitCostCents: Int = 0
    var totalValueCents: Int = 0
    var isDamaged: Bool = false
    var isReserved: Bool = false
    var reservedBy: String = ""
    var reservedUntil: Date?
    var lastCheckedAt: Date = Date()
    var lastAuditedBy: String = ""
    var stockStatus: String = ""
    var tags: [String] = []
    var temperatureRequirement: String = ""
    var humidityRequirement: String = ""
    var supplierReference: String = ""
    var customField1: String = ""
    var customField2: String = ""
    var customField3: String = ""
    var customField4: String = ""
    var customField5: String = ""
    var notes: String = ""
}

struct MaintenanceRecord: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var listingID: UUID
    var serviceDate: Date = Date()
    var performedBy: String = ""
    var notes: String = ""
    var costCents: Int = 0
    var durationMinutes: Int = 0
    var serviceType: String = ""
    var location: String = ""
    var technicianID: UUID?
    var status: String = ""
    var warrantyClaim: Bool = false
    var partsUsed: [UUID] = []
    var nextServiceDate: Date?
    var conditionAfter: String = ""
    var rating: Int = 0
    var approvedBy: String = ""
    var approvedDate: Date?
    var rejectionReason: String = ""
    var signature: String = ""
    var documentPath: String = ""
    var tags: [String] = []
    var priorityLevel: Int = 0
    var safetyNotes: String = ""
    var images: [String] = []
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    var customField1: String = ""
    var customField2: String = ""
    var customField3: String = ""
    var customField4: String = ""
    var customField5: String = ""
}

struct SaleRecord: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var items: [UUID] = []
    var totalCents: Int = 0
    var customerName: String = ""
    var createdAt: Date = Date()
    var invoiceNumber: String = ""
    var paymentStatus: String = ""
    var dueDate: Date = Date()
    var discountCents: Int = 0
    var taxCents: Int = 0
    var currency: String = ""
    var salesperson: String = ""
    var shippingAddress: String = ""
    var billingAddress: String = ""
    var contactEmail: String = ""
    var contactPhone: String = ""
    var deliveryDate: Date?
    var deliveryStatus: String = ""
    var trackingNumber: String = ""
    var notes: String = ""
    var approvedBy: String = ""
    var approvedDate: Date?
    var cancellationReason: String = ""
    var refundCents: Int = 0
    var tags: [String] = []
    var customField1: String = ""
    var customField2: String = ""
    var customField3: String = ""
    var customField4: String = ""
    var customField5: String = ""
    var customField6: String = ""
    var customField7: String = ""
}

struct ContactRecord: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String = ""
    var role: String = ""
    var phone: String = ""
    var notes: String = ""
    var email: String = ""
    var company: String = ""
    var address: String = ""
    var city: String = ""
    var country: String = ""
    var postalCode: String = ""
    var website: String = ""
    var tags: [String] = []
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    var isSupplier: Bool = false
    var isCustomer: Bool = false
    var preferredContactMethod: String = ""
    var rating: Int = 0
    var status: String = ""
    var contactPerson: String = ""
    var department: String = ""
    var position: String = ""
    var language: String = ""
    var timezone: String = ""
    var taxID: String = ""
    var bankAccount: String = ""
    var paymentTerms: String = ""
    var customField1: String = ""
    var customField2: String = ""
    var customField3: String = ""
    var customField4: String = ""
    var customField5: String = ""
    var customField6: String = ""
    var customField7: String = ""
}

struct Part: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var partNumber: String = ""
    var description: String = ""
    var quantityOnHand: Int = 0
    var linkedListingID: UUID?
    var supplierName: String = ""
    var category: String = ""
    var subcategory: String = ""
    var weightGrams: Int = 0
    var lengthMM: Int = 0
    var widthMM: Int = 0
    var heightMM: Int = 0
    var material: String = ""
    var color: String = ""
    var priceCents: Int = 0
    var reorderThreshold: Int = 0
    var barcode: String = ""
    var storageLocation: String = ""
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    var warrantyMonths: Int = 0
    var isActive: Bool = true
    var tags: [String] = []
    var imagePaths: [String] = []
    var manufacturer: String = ""
    var batchCode: String = ""
    var lotNumber: String = ""
    var expiryDate: Date?
    var notes: String = ""
    var customField1: String = ""
    var customField2: String = ""
    var customField3: String = ""
    var customField4: String = ""
    var customField5: String = ""
    var customField6: String = ""
}

import Foundation
import Combine

class FactoryDataManager: ObservableObject {
    @Published var listings: [Listing] = []
    @Published var inventoryItems: [InventoryItem] = []
    @Published var maintenanceRecords: [MaintenanceRecord] = []
    @Published var saleRecords: [SaleRecord] = []
    @Published var contactRecords: [ContactRecord] = []
    @Published var parts: [Part] = []
    
    // MARK: - UserDefaults Keys
    private let listingsKey = "listings"
    private let inventoryKey = "inventoryItems"
    private let maintenanceKey = "maintenanceRecords"
    private let salesKey = "saleRecords"
    private let contactsKey = "contactRecords"
    private let partsKey = "parts"
    
    init() {
        loadData()
        loadDummyData()
    }



    
    private func save<T: Codable>(_ data: [T], key: String) {
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    private func load<T: Codable>(key: String, type: T.Type) -> [T] {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([T].self, from: data) {
            return decoded
        }
        return []
    }
    
    func loadData() {
        listings = load(key: listingsKey, type: Listing.self)
        inventoryItems = load(key: inventoryKey, type: InventoryItem.self)
        maintenanceRecords = load(key: maintenanceKey, type: MaintenanceRecord.self)
        saleRecords = load(key: salesKey, type: SaleRecord.self)
        contactRecords = load(key: contactsKey, type: ContactRecord.self)
        parts = load(key: partsKey, type: Part.self)
    }
    
    func addListing(_ item: Listing) { listings.append(item); save(listings, key: listingsKey) }
    func addInventoryItem(_ item: InventoryItem) { inventoryItems.append(item); save(inventoryItems, key: inventoryKey) }
    func addMaintenanceRecord(_ record: MaintenanceRecord) { maintenanceRecords.append(record); save(maintenanceRecords, key: maintenanceKey) }
    func addSaleRecord(_ record: SaleRecord) { saleRecords.append(record); save(saleRecords, key: salesKey) }
    func addContactRecord(_ record: ContactRecord) { contactRecords.append(record); save(contactRecords, key: contactsKey) }
    func addPart(_ part: Part) { parts.append(part); save(parts, key: partsKey) }
    
    func deleteListing(at offsets: IndexSet) { listings.remove(atOffsets: offsets); save(listings, key: listingsKey) }
    func deleteInventoryItem(at offsets: IndexSet) { inventoryItems.remove(atOffsets: offsets); save(inventoryItems, key: inventoryKey) }
    func deleteMaintenanceRecord(at offsets: IndexSet) { maintenanceRecords.remove(atOffsets: offsets); save(maintenanceRecords, key: maintenanceKey) }
    func deleteSaleRecord(at offsets: IndexSet) { saleRecords.remove(atOffsets: offsets); save(saleRecords, key: salesKey) }
    func deleteContactRecord(at offsets: IndexSet) { contactRecords.remove(atOffsets: offsets); save(contactRecords, key: contactsKey) }
    func deletePart(at offsets: IndexSet) { parts.remove(atOffsets: offsets); save(parts, key: partsKey) }
    
    func loadDummyData() {
        listings = [
            Listing(
                sku: "SKU001",
                title: "Water Pump A1",
                details: "1.5 HP water pump with durable motor",
                brand: "PumpCo",
                tags: ["pump", "water", "industrial"],
                category: "Machinery",
                subcategory: "Pumps",
                modelNumber: "A1-1500",
                serialNumber: "SN-123456",
                createdAt: Date(),
                updatedAt: Date(),
                priceCents: 12000,
                weightGrams: 25000,
                lengthMM: 400,
                widthMM: 200,
                heightMM: 250,
                color: "Blue",
                material: "Steel",
                status: "Available",
                barcode: "1234567890123",
                manufacturer: "PumpCo Ltd.",
                warrantyMonths: 24,
                notes: "High efficiency pump",
                rating: 4.5,
                isActive: true,
                isFeatured: true,
                keywords: ["pump", "water", "steel"],
                storageLocation: "Warehouse A1",
                supplierID: UUID(),
                imagePaths: ["pump_a1.png"],
                unitOfMeasure: "pcs",
                minOrderQty: 1,
                maxOrderQty: 50,
                customField1: "Custom A",
                customField2: "Custom B",
                customField3: "Custom C"
            )
        ]
        
        inventoryItems = [
            InventoryItem(
                listingID: listings[0].id,
                location: "Warehouse A",
                quantity: 50,
                reorderThreshold: 10,
                lotNumber: "LOT-001",
                batchCode: "BATCH-123",
                receivedDate: Date(),
                expiryDate: Calendar.current.date(byAdding: .year, value: 2, to: Date())!,
                condition: "New",
                storageType: "Dry",
                aisle: "A1",
                shelf: "S1",
                bin: "B1",
                unitCostCents: 10000,
                totalValueCents: 500000,
                isDamaged: false,
                isReserved: false,
                reservedBy: "",
                reservedUntil: nil,
                lastCheckedAt: Date(),
                lastAuditedBy: "Auditor A",
                stockStatus: "In Stock",
                tags: ["priority", "fragile"],
                temperatureRequirement: "Room Temp",
                humidityRequirement: "Normal",
                supplierReference: "SUP-001",
                customField1: "C1",
                customField2: "C2",
                customField3: "C3",
                customField4: "C4",
                customField5: "C5",
                notes: "Inventory in good condition"
            )
        ]
        
        maintenanceRecords = [
            MaintenanceRecord(
                listingID: listings[0].id,
                serviceDate: Date(),
                performedBy: "John Doe",
                notes: "Replaced motor seals",
                costCents: 3000,
                durationMinutes: 120,
                serviceType: "Repair",
                location: "Workshop A",
                technicianID: UUID(),
                status: "Completed",
                warrantyClaim: false,
                partsUsed: [UUID()],
                nextServiceDate: Calendar.current.date(byAdding: .month, value: 6, to: Date()),
                conditionAfter: "Good",
                rating: 5,
                approvedBy: "Manager A",
                approvedDate: Date(),
                rejectionReason: "",
                signature: "Signed by John",
                documentPath: "service_report.pdf",
                tags: ["repair", "motor"],
                priorityLevel: 1,
                safetyNotes: "Wear gloves",
                images: ["repair_img1.png"],
                createdAt: Date(),
                updatedAt: Date(),
                customField1: "M1",
                customField2: "M2",
                customField3: "M3",
                customField4: "M4",
                customField5: "M5"
            )
        ]
        
        saleRecords = [
            SaleRecord(
                items: [listings[0].id],
                totalCents: 15000,
                customerName: "Acme Corp",
                createdAt: Date(),
                invoiceNumber: "INV-001",
                paymentStatus: "Paid",
                dueDate: Calendar.current.date(byAdding: .day, value: 30, to: Date())!,
                discountCents: 500,
                taxCents: 1500,
                currency: "USD",
                salesperson: "Sales Rep A",
                shippingAddress: "123 Industrial St",
                billingAddress: "123 Industrial St",
                contactEmail: "contact@acme.com",
                contactPhone: "+123456789",
                deliveryDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()),
                deliveryStatus: "Delivered",
                trackingNumber: "TRACK123",
                notes: "Urgent order",
                approvedBy: "Manager B",
                approvedDate: Date(),
                cancellationReason: "",
                refundCents: 0,
                tags: ["priority", "bulk"],
                customField1: "S1",
                customField2: "S2",
                customField3: "S3",
                customField4: "S4",
                customField5: "S5",
                customField6: "S6",
                customField7: "S7"
            )
        ]
        
        contactRecords = [
            ContactRecord(
                name: "Alice Smith",
                role: "Purchasing Manager",
                phone: "123456789",
                notes: "Key contact for purchases",
                email: "alice@acme.com",
                company: "Acme Corp",
                address: "456 Market St",
                city: "New York",
                country: "USA",
                postalCode: "10001",
                website: "www.acme.com",
                tags: ["customer"],
                createdAt: Date(),
                updatedAt: Date(),
                isSupplier: false,
                isCustomer: true,
                preferredContactMethod: "Email",
                rating: 5,
                status: "Active",
                contactPerson: "Alice",
                department: "Purchasing",
                position: "Manager",
                language: "English",
                timezone: "EST",
                taxID: "TAX123",
                bankAccount: "BANK123",
                paymentTerms: "Net 30",
                customField1: "C1",
                customField2: "C2",
                customField3: "C3",
                customField4: "C4",
                customField5: "C5",
                customField6: "C6",
                customField7: "C7"
            )
        ]
        
        parts = [
            Part(
                partNumber: "P-001",
                description: "Pump Seal",
                quantityOnHand: 200,
                linkedListingID: listings[0].id,
                supplierName: "SealCo",
                category: "Seals",
                subcategory: "Pump Parts",
                weightGrams: 100,
                lengthMM: 50,
                widthMM: 50,
                heightMM: 10,
                material: "Rubber",
                color: "Black",
                priceCents: 500,
                reorderThreshold: 20,
                barcode: "9876543210987",
                storageLocation: "Bin A1",
                createdAt: Date(),
                updatedAt: Date(),
                warrantyMonths: 12,
                isActive: true,
                tags: ["spare", "seal"],
                imagePaths: ["seal.png"],
                manufacturer: "SealCo Ltd.",
                batchCode: "BATCH-SEAL-01",
                lotNumber: "LOT-SEAL-2023",
                expiryDate: Calendar.current.date(byAdding: .year, value: 2, to: Date()),
                notes: "Keep in cool dry place",
                customField1: "P1",
                customField2: "P2",
                customField3: "P3",
                customField4: "P4",
                customField5: "P5",
                customField6: "P6"
            )
        ]
        
        save(listings, key: listingsKey)
        save(inventoryItems, key: inventoryKey)
        save(maintenanceRecords, key: maintenanceKey)
        save(saleRecords, key: salesKey)
        save(contactRecords, key: contactsKey)
        save(parts, key: partsKey)
    }
}
