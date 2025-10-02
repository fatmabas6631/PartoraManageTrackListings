
import SwiftUI

@available(iOS 14.0, *)
struct SaleRecordAddView: View {
    @ObservedObject var manager: FactoryDataManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var customerName = ""
    @State private var invoiceNumber = ""
    @State private var totalAmount = ""
    @State private var paymentStatus = "Pending"
    @State private var currency = "USD"
    @State private var salesperson = ""
    @State private var shippingAddress = ""
    @State private var billingAddress = ""
    @State private var contactEmail = ""
    @State private var contactPhone = ""
    @State private var deliveryStatus = "Pending"
    @State private var trackingNumber = ""
    @State private var notes = ""
    @State private var approvedBy = ""
    @State private var tags = ""
    @State private var customField1 = ""
    @State private var customField2 = ""
    @State private var customField3 = ""
    
    @State private var createdAt = Date()
    @State private var dueDate = Date()
    @State private var deliveryDate = Date()
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    private let paymentStatuses = ["Pending", "Paid", "Overdue", "Cancelled", "Refunded"]
    private let currencies = ["USD", "EUR", "GBP", "CAD", "AUD"]
    private let deliveryStatuses = ["Pending", "Processing", "Shipped", "In Transit", "Delivered", "Cancelled"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Section
                    SaleRecordAddSectionHeaderView(
                        title: "Sale Information",
                        icon: "doc.text.fill",
                        color: .blue
                    )
                    
                    VStack(spacing: 16) {
                        SaleRecordAddFieldView(
                            title: "Customer Name",
                            text: $customerName,
                            icon: "person.fill",
                            placeholder: "Enter customer name"
                        )
                        
                        SaleRecordAddFieldView(
                            title: "Invoice Number",
                            text: $invoiceNumber,
                            icon: "number.square.fill",
                            placeholder: "INV-2024-001"
                        )
                        
                        HStack(spacing: 12) {
                            SaleRecordAddFieldView(
                                title: "Total Amount",
                                text: $totalAmount,
                                icon: "dollarsign.circle.fill",
                                placeholder: "0.00",
                                keyboardType: .decimalPad
                            )
                            
                            SaleRecordAddPickerView(
                                title: "Currency",
                                selection: $currency,
                                options: currencies,
                                icon: "banknote.fill"
                            )
                        }
                        
                        HStack(spacing: 12) {
                            SaleRecordAddPickerView(
                                title: "Payment Status",
                                selection: $paymentStatus,
                                options: paymentStatuses,
                                icon: "creditcard.fill"
                            )
                            
                            SaleRecordAddFieldView(
                                title: "Salesperson",
                                text: $salesperson,
                                icon: "person.badge.plus.fill",
                                placeholder: "Enter salesperson name"
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Dates Section
                    SaleRecordAddSectionHeaderView(
                        title: "Important Dates",
                        icon: "calendar.circle.fill",
                        color: .purple
                    )
                    
                    VStack(spacing: 16) {
                        SaleRecordAddDatePickerView(
                            title: "Created Date",
                            date: $createdAt,
                            icon: "calendar.badge.plus"
                        )
                        
                        SaleRecordAddDatePickerView(
                            title: "Due Date",
                            date: $dueDate,
                            icon: "calendar.badge.exclamationmark"
                        )
                        
                        SaleRecordAddDatePickerView(
                            title: "Delivery Date",
                            date: $deliveryDate,
                            icon: "truck.box.badge.clock"
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Contact & Delivery Section
                    SaleRecordAddSectionHeaderView(
                        title: "Contact & Delivery",
                        icon: "location.circle.fill",
                        color: .green
                    )
                    
                    VStack(spacing: 16) {
                        SaleRecordAddFieldView(
                            title: "Contact Email",
                            text: $contactEmail,
                            icon: "envelope.fill",
                            placeholder: "customer@example.com",
                            keyboardType: .emailAddress
                        )
                        
                        SaleRecordAddFieldView(
                            title: "Contact Phone",
                            text: $contactPhone,
                            icon: "phone.fill",
                            placeholder: "+1-555-0123",
                            keyboardType: .phonePad
                        )
                        
                        SaleRecordAddTextAreaView(
                            title: "Shipping Address",
                            text: $shippingAddress,
                            icon: "location.fill",
                            placeholder: "Enter complete shipping address"
                        )
                        
                        SaleRecordAddTextAreaView(
                            title: "Billing Address",
                            text: $billingAddress,
                            icon: "building.2.fill",
                            placeholder: "Enter complete billing address"
                        )
                        
                        HStack(spacing: 12) {
                            SaleRecordAddPickerView(
                                title: "Delivery Status",
                                selection: $deliveryStatus,
                                options: deliveryStatuses,
                                icon: "truck.box.fill"
                            )
                            
                            SaleRecordAddFieldView(
                                title: "Tracking Number",
                                text: $trackingNumber,
                                icon: "barcode.viewfinder",
                                placeholder: "TRK123456789"
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Additional Information Section
                    SaleRecordAddSectionHeaderView(
                        title: "Additional Information",
                        icon: "info.circle.fill",
                        color: .orange
                    )
                    
                    VStack(spacing: 16) {
                        SaleRecordAddTextAreaView(
                            title: "Notes",
                            text: $notes,
                            icon: "note.text",
                            placeholder: "Add any additional notes or comments"
                        )
                        
                        SaleRecordAddFieldView(
                            title: "Approved By",
                            text: $approvedBy,
                            icon: "checkmark.seal.fill",
                            placeholder: "Enter approver name"
                        )
                        
                        SaleRecordAddFieldView(
                            title: "Tags (comma separated)",
                            text: $tags,
                            icon: "tag.fill",
                            placeholder: "Priority, Corporate, Bulk"
                        )
                        
                        VStack(spacing: 12) {
                            SaleRecordAddFieldView(
                                title: "Custom Field 1",
                                text: $customField1,
                                icon: "square.and.pencil",
                                placeholder: "Custom information"
                            )
                            
                            SaleRecordAddFieldView(
                                title: "Custom Field 2",
                                text: $customField2,
                                icon: "square.and.pencil",
                                placeholder: "Custom information"
                            )
                            
                            SaleRecordAddFieldView(
                                title: "Custom Field 3",
                                text: $customField3,
                                icon: "square.and.pencil",
                                placeholder: "Custom information"
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Save Button
                    Button(action: saveSaleRecord) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 18, weight: .semibold))
                            
                            Text("Save Sale Record")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                        .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("New Sale Record")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: EmptyView()
            )
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if alertTitle == "Success" {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
            }
        }
    }
    
    private func saveSaleRecord() {
        let validationErrors = validateFields()
        
        if !validationErrors.isEmpty {
            alertTitle = "Validation Error"
            alertMessage = "Please fix the following issues:\n\n" + validationErrors.joined(separator: "\n")
            showingAlert = true
            return
        }
        
        let totalCents = Int((Double(totalAmount) ?? 0.0) * 100)
        let tagArray = tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        
        let newRecord = SaleRecord(
            totalCents: totalCents,
            customerName: customerName,
            createdAt: createdAt,
            invoiceNumber: invoiceNumber,
            paymentStatus: paymentStatus,
            dueDate: dueDate,
            currency: currency,
            salesperson: salesperson,
            shippingAddress: shippingAddress,
            billingAddress: billingAddress,
            contactEmail: contactEmail,
            contactPhone: contactPhone,
            deliveryDate: deliveryDate,
            deliveryStatus: deliveryStatus,
            trackingNumber: trackingNumber,
            notes: notes,
            approvedBy: approvedBy,
            tags: tagArray,
            customField1: customField1,
            customField2: customField2,
            customField3: customField3
        )
        
        manager.addSaleRecord(newRecord)
        
        alertTitle = "Success"
        alertMessage = "Sale record has been successfully created!"
        showingAlert = true
    }
    
    private func validateFields() -> [String] {
        var errors: [String] = []
        
        if customerName.trimmingCharacters(in: .whitespaces).isEmpty {
            errors.append("• Customer name is required")
        }
        
        if invoiceNumber.trimmingCharacters(in: .whitespaces).isEmpty {
            errors.append("• Invoice number is required")
        }
        
        if totalAmount.trimmingCharacters(in: .whitespaces).isEmpty {
            errors.append("• Total amount is required")
        } else if Double(totalAmount) == nil || Double(totalAmount)! < 0 {
            errors.append("• Total amount must be a valid positive number")
        }
        
        if salesperson.trimmingCharacters(in: .whitespaces).isEmpty {
            errors.append("• Salesperson is required")
        }
        
        if !contactEmail.isEmpty && !isValidEmail(contactEmail) {
            errors.append("• Contact email format is invalid")
        }
        
        if shippingAddress.trimmingCharacters(in: .whitespaces).isEmpty {
            errors.append("• Shipping address is required")
        }
        
        if billingAddress.trimmingCharacters(in: .whitespaces).isEmpty {
            errors.append("• Billing address is required")
        }
        
        return errors
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

@available(iOS 14.0, *)
struct SaleRecordAddSectionHeaderView: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 20, weight: .semibold))
                
                Text(title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
}

@available(iOS 14.0, *)
struct SaleRecordAddFieldView: View {
    let title: String
    @Binding var text: String
    let icon: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    
    @State private var isFocused = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.system(size: 14, weight: .medium))
                    .frame(width: 16)
                
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
            }
            
            TextField(placeholder, text: $text, onEditingChanged: { editing in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isFocused = editing
                }
            })
            .keyboardType(keyboardType)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isFocused ? Color.blue : Color.clear, lineWidth: 2)
                    )
            )
            .scaleEffect(isFocused ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
    }
}

@available(iOS 14.0, *)
struct SaleRecordAddTextAreaView: View {
    let title: String
    @Binding var text: String
    let icon: String
    let placeholder: String
    
    @State private var isFocused = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.system(size: 14, weight: .medium))
                    .frame(width: 16)
                
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
            }
            
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                }
                
                TextEditor(text: $text)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .frame(minHeight: 80)
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isFocused ? Color.blue : Color.clear, lineWidth: 2)
                    )
            )
            .onTapGesture {
                isFocused = true
            }
        }
    }
}

@available(iOS 14.0, *)
struct SaleRecordAddPickerView: View {
    let title: String
    @Binding var selection: String
    let options: [String]
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.system(size: 14, weight: .medium))
                    .frame(width: 16)
                
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
            }
            
            Picker(title, selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
        }
    }
}

@available(iOS 14.0, *)
struct SaleRecordAddDatePickerView: View {
    let title: String
    @Binding var date: Date
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.system(size: 14, weight: .medium))
                    .frame(width: 16)
                
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
            }
            
            DatePicker("", selection: $date, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
        }
    }
}
