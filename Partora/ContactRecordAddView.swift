
import SwiftUI

@available(iOS 14.0, *)
struct ContactRecordAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataManager: FactoryDataManager
    
    @State private var name = ""
    @State private var role = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var company = ""
    @State private var address = ""
    @State private var city = ""
    @State private var country = ""
    @State private var postalCode = ""
    @State private var website = ""
    @State private var isSupplier = false
    @State private var isCustomer = false
    @State private var preferredContactMethod = ""
    @State private var rating = 0
    @State private var status = ""
    @State private var contactPerson = ""
    @State private var department = ""
    @State private var position = ""
    @State private var language = ""
    @State private var timezone = ""
    @State private var taxID = ""
    @State private var bankAccount = ""
    @State private var paymentTerms = ""
    @State private var notes = ""
    @State private var customField1 = ""
    @State private var customField2 = ""
    @State private var customField3 = ""
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    private let contactMethods = ["Email", "Phone", "SMS", "WhatsApp", "Video Call"]
    private let statusOptions = ["Active", "Inactive", "Pending", "Blocked"]
    private let languages = ["English", "Spanish", "French", "German", "Chinese", "Japanese"]
    private let timezones = ["UTC", "EST", "PST", "GMT", "CET", "JST"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    ContactRecordAddHeaderView()
                    
                    LazyVStack(spacing: 20) {
                        ContactRecordAddSectionView(title: "Basic Information", icon: "person.circle.fill", color: .blue) {
                            VStack(spacing: 16) {
                                ContactRecordAddFieldView(title: "Full Name", text: $name, icon: "person.fill", isRequired: true)
                                ContactRecordAddFieldView(title: "Role", text: $role, icon: "briefcase.fill", isRequired: true)
                                ContactRecordAddFieldView(title: "Company", text: $company, icon: "building.2.fill", isRequired: true)
                                ContactRecordAddFieldView(title: "Department", text: $department, icon: "person.3.fill")
                                ContactRecordAddFieldView(title: "Position", text: $position, icon: "star.fill")
                            }
                        }
                        
                        ContactRecordAddSectionView(title: "Contact Details", icon: "phone.circle.fill", color: .green) {
                            VStack(spacing: 16) {
                                ContactRecordAddFieldView(title: "Phone Number", text: $phone, icon: "phone.fill", isRequired: true)
                                ContactRecordAddFieldView(title: "Email Address", text: $email, icon: "envelope.fill", isRequired: true)
                                ContactRecordAddFieldView(title: "Website", text: $website, icon: "globe")
                                ContactRecordAddPickerView(title: "Preferred Contact", selection: $preferredContactMethod, options: contactMethods, icon: "bubble.left.and.bubble.right.fill")
                            }
                        }
                        
                        ContactRecordAddSectionView(title: "Address Information", icon: "location.circle.fill", color: .orange) {
                            VStack(spacing: 16) {
                                ContactRecordAddFieldView(title: "Street Address", text: $address, icon: "house.fill", isRequired: true)
                                ContactRecordAddFieldView(title: "City", text: $city, icon: "building.fill", isRequired: true)
                                ContactRecordAddFieldView(title: "Country", text: $country, icon: "flag.fill", isRequired: true)
                                ContactRecordAddFieldView(title: "Postal Code", text: $postalCode, icon: "number")
                            }
                        }
                        
                        ContactRecordAddSectionView(title: "Business Details", icon: "dollarsign.circle.fill", color: .purple) {
                            VStack(spacing: 16) {
                                ContactRecordAddToggleView(title: "Is Supplier", isOn: $isSupplier, icon: "truck.box.fill")
                                ContactRecordAddToggleView(title: "Is Customer", isOn: $isCustomer, icon: "cart.fill")
                                ContactRecordAddPickerView(title: "Status", selection: $status, options: statusOptions, icon: "checkmark.circle.fill")
                                ContactRecordAddRatingView(title: "Rating", rating: $rating, icon: "star.fill")
                            }
                        }
                        
                        ContactRecordAddSectionView(title: "Financial Information", icon: "creditcard.circle.fill", color: .red) {
                            VStack(spacing: 16) {
                                ContactRecordAddFieldView(title: "Tax ID", text: $taxID, icon: "doc.text.fill")
                                ContactRecordAddFieldView(title: "Bank Account", text: $bankAccount, icon: "banknote.fill")
                                ContactRecordAddFieldView(title: "Payment Terms", text: $paymentTerms, icon: "calendar.badge.clock")
                            }
                        }
                        
                        ContactRecordAddSectionView(title: "Preferences", icon: "gear.circle.fill", color: .green) {
                            VStack(spacing: 16) {
                                ContactRecordAddPickerView(title: "Language", selection: $language, options: languages, icon: "globe")
                                ContactRecordAddPickerView(title: "Timezone", selection: $timezone, options: timezones, icon: "clock.fill")
                                ContactRecordAddFieldView(title: "Contact Person", text: $contactPerson, icon: "person.crop.circle")
                            }
                        }
                        
                        ContactRecordAddSectionView(title: "Additional Information", icon: "doc.circle.fill", color: .red) {
                            VStack(spacing: 16) {
                                ContactRecordAddTextEditorView(title: "Notes", text: $notes, icon: "note.text")
                                ContactRecordAddFieldView(title: "Custom Field 1", text: $customField1, icon: "1.circle.fill")
                                ContactRecordAddFieldView(title: "Custom Field 2", text: $customField2, icon: "2.circle.fill")
                                ContactRecordAddFieldView(title: "Custom Field 3", text: $customField3, icon: "3.circle.fill")
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .overlay(
                ContactRecordAddFloatingButtonView(action: saveContact)
                    .padding(.bottom, 30)
                , alignment: .bottom
            )
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                if alertTitle == "Success" {
                    presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }
    
    private func saveContact() {
        let errors = validateFields()
        
        if !errors.isEmpty {
            alertTitle = "Validation Errors"
            alertMessage = errors.joined(separator: "\n")
            showingAlert = true
            return
        }
        
        let newContact = ContactRecord(
            name: name,
            role: role,
            phone: phone,
            notes: notes,
            email: email,
            company: company,
            address: address,
            city: city,
            country: country,
            postalCode: postalCode,
            website: website,
            isSupplier: isSupplier,
            isCustomer: isCustomer,
            preferredContactMethod: preferredContactMethod,
            rating: rating,
            status: status,
            contactPerson: contactPerson,
            department: department,
            position: position,
            language: language,
            timezone: timezone,
            taxID: taxID,
            bankAccount: bankAccount,
            paymentTerms: paymentTerms,
            customField1: customField1,
            customField2: customField2,
            customField3: customField3
        )
        
        dataManager.addContactRecord(newContact)
        
        alertTitle = "Success"
        alertMessage = "Contact record has been successfully created!"
        showingAlert = true
    }
    
    private func validateFields() -> [String] {
        var errors: [String] = []
        
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• Full Name is required")
        }
        if role.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• Role is required")
        }
        if company.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• Company is required")
        }
        if phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• Phone Number is required")
        }
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• Email Address is required")
        } else if !email.contains("@") || !email.contains(".") {
            errors.append("• Email Address format is invalid")
        }
        if address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• Street Address is required")
        }
        if city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• City is required")
        }
        if country.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• Country is required")
        }
        
        return errors
    }
}

@available(iOS 14.0, *)
struct ContactRecordAddHeaderView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 0))
            
            VStack(spacing: 8) {
                Image(systemName: "person.badge.plus.fill")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Add New Contact")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding(.top, 20)
        }
    }
}

@available(iOS 14.0, *)
struct ContactRecordAddSectionView<Content: View>: View {
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
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(color)
                    .frame(width: 30, height: 30)
                    .background(color.opacity(0.1))
                    .clipShape(Circle())
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            content
        }
        .padding(20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

@available(iOS 14.0, *)
struct ContactRecordAddFieldView: View {
    let title: String
    @Binding var text: String
    let icon: String
    var isRequired: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                if isRequired {
                    Text("*")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }
            }
            
            TextField("Enter \(title.lowercased())", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.body)
        }
    }
}

@available(iOS 14.0, *)
struct ContactRecordAddPickerView: View {
    let title: String
    @Binding var selection: String
    let options: [String]
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            
            Picker(title, selection: $selection) {
                Text("Select \(title)").tag("")
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

@available(iOS 14.0, *)
struct ContactRecordAddToggleView: View {
    let title: String
    @Binding var isOn: Bool
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isOn ? .green : .secondary)
                .frame(width: 20)
            
            Text(title)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.vertical, 4)
    }
}

@available(iOS 14.0, *)
struct ContactRecordAddRatingView: View {
    let title: String
    @Binding var rating: Int
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 8) {
                ForEach(1...5, id: \.self) { star in
                    Button(action: {
                        rating = star
                    }) {
                        Image(systemName: star <= rating ? "star.fill" : "star")
                            .font(.system(size: 20))
                            .foregroundColor(star <= rating ? .yellow : .gray)
                    }
                }
                
                Spacer()
                
                Text("\(rating)/5")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
        }
    }
}

@available(iOS 14.0, *)
struct ContactRecordAddTextEditorView: View {
    let title: String
    @Binding var text: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            
            TextEditor(text: $text)
                .frame(minHeight: 80)
                .padding(8)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

@available(iOS 14.0, *)
struct ContactRecordAddFloatingButtonView: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20, weight: .semibold))
                
                Text("Save Contact")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(Capsule())
            .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
        }
    }
}
