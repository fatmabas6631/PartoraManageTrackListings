import SwiftUI

@available(iOS 14.0, *)
struct MaintenanceRecordAddView: View {
    @ObservedObject var dataManager: FactoryDataManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var listingID = UUID()
    @State private var serviceDate = Date()
    @State private var performedBy = ""
    @State private var notes = ""
    @State private var costCents = ""
    @State private var durationMinutes = ""
    @State private var serviceType = ""
    @State private var location = ""
    @State private var status = ""
    @State private var warrantyClaim = false
    @State private var nextServiceDate = Date()
    @State private var conditionAfter = ""
    @State private var rating = 0
    @State private var approvedBy = ""
    @State private var approvedDate = Date()
    @State private var rejectionReason = ""
    @State private var signature = ""
    @State private var documentPath = ""
    @State private var priorityLevel = 1
    @State private var safetyNotes = ""
    @State private var customField1 = ""
    @State private var customField2 = ""
    @State private var customField3 = ""
    @State private var customField4 = ""
    @State private var customField5 = ""
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isSuccess = false
    
    private let serviceTypes = ["Repair", "Maintenance", "Inspection", "Calibration", "Replacement", "Upgrade"]
    private let statusOptions = ["Pending", "In Progress", "Completed", "Cancelled", "On Hold"]
    private let conditionOptions = ["Excellent", "Good", "Fair", "Poor", "Critical"]
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.green.opacity(0.1), Color.blue.opacity(0.05)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    MaintenanceRecordAddHeaderView()
                    
                    // Service Information Section
                    MaintenanceRecordAddSectionHeaderView(
                        title: "Service Information",
                        icon: "info.circle.fill",
                        color: .blue
                    )
                    
                    VStack(spacing: 16) {
                        MaintenanceRecordAddFieldView(
                            title: "Performed By",
                            text: $performedBy,
                            icon: "person.fill",
                            placeholder: "Enter technician name"
                        )
                        
                        MaintenanceRecordAddPickerView(
                            title: "Service Type",
                            selection: $serviceType,
                            options: serviceTypes,
                            icon: "wrench.and.screwdriver.fill"
                        )
                        
                        MaintenanceRecordAddDatePickerView(
                            title: "Service Date",
                            date: $serviceDate,
                            icon: "calendar"
                        )
                        
                        MaintenanceRecordAddFieldView(
                            title: "Location",
                            text: $location,
                            icon: "location.fill",
                            placeholder: "Enter service location"
                        )
                    }
                    
                    // Cost & Duration Section
                    MaintenanceRecordAddSectionHeaderView(
                        title: "Cost & Duration",
                        icon: "dollarsign.circle.fill",
                        color: .green
                    )
                    
                    HStack(spacing: 16) {
                        MaintenanceRecordAddFieldView(
                            title: "Cost (Cents)",
                            text: $costCents,
                            icon: "dollarsign.circle",
                            placeholder: "0",
                            keyboardType: .numberPad
                        )
                        
                        MaintenanceRecordAddFieldView(
                            title: "Duration (Minutes)",
                            text: $durationMinutes,
                            icon: "clock.fill",
                            placeholder: "0",
                            keyboardType: .numberPad
                        )
                    }
                    
                    // Status & Priority Section
                    MaintenanceRecordAddSectionHeaderView(
                        title: "Status & Priority",
                        icon: "flag.fill",
                        color: .orange
                    )
                    
                    VStack(spacing: 16) {
                        MaintenanceRecordAddPickerView(
                            title: "Status",
                            selection: $status,
                            options: statusOptions,
                            icon: "checkmark.circle.fill"
                        )
                        
                        MaintenanceRecordAddStepperView(
                            title: "Priority Level",
                            value: $priorityLevel,
                            range: 1...5,
                            icon: "exclamationmark.triangle.fill"
                        )
                        
                        MaintenanceRecordAddToggleView(
                            title: "Warranty Claim",
                            isOn: $warrantyClaim,
                            icon: "shield.fill"
                        )
                    }
                    
                    // Quality & Approval Section
                    MaintenanceRecordAddSectionHeaderView(
                        title: "Quality & Approval",
                        icon: "star.fill",
                        color: .purple
                    )
                    
                    VStack(spacing: 16) {
                        MaintenanceRecordAddPickerView(
                            title: "Condition After",
                            selection: $conditionAfter,
                            options: conditionOptions,
                            icon: "gauge"
                        )
                        
                        MaintenanceRecordAddStepperView(
                            title: "Rating",
                            value: $rating,
                            range: 0...5,
                            icon: "star.fill"
                        )
                        
                        MaintenanceRecordAddFieldView(
                            title: "Approved By",
                            text: $approvedBy,
                            icon: "person.crop.circle.fill.badge.checkmark",
                            placeholder: "Enter approver name"
                        )
                        
                        MaintenanceRecordAddDatePickerView(
                            title: "Approval Date",
                            date: $approvedDate,
                            icon: "checkmark.circle"
                        )
                    }
                    
                    // Additional Information Section
                    MaintenanceRecordAddSectionHeaderView(
                        title: "Additional Information",
                        icon: "doc.text.fill",
                        color: .orange
                    )
                    
                    VStack(spacing: 16) {
                        MaintenanceRecordAddTextAreaView(
                            title: "Service Notes",
                            text: $notes,
                            icon: "note.text",
                            placeholder: "Enter detailed service notes..."
                        )
                        
                        MaintenanceRecordAddTextAreaView(
                            title: "Safety Notes",
                            text: $safetyNotes,
                            icon: "exclamationmark.shield.fill",
                            placeholder: "Enter safety considerations..."
                        )
                        
                        MaintenanceRecordAddFieldView(
                            title: "Document Path",
                            text: $documentPath,
                            icon: "doc.fill",
                            placeholder: "Enter document reference"
                        )
                        
                        MaintenanceRecordAddFieldView(
                            title: "Signature",
                            text: $signature,
                            icon: "signature",
                            placeholder: "Enter signature reference"
                        )
                        
                        MaintenanceRecordAddDatePickerView(
                            title: "Next Service Date",
                            date: $nextServiceDate,
                            icon: "calendar.badge.clock"
                        )
                    }
                    
                    // Custom Fields Section
                    MaintenanceRecordAddSectionHeaderView(
                        title: "Custom Fields",
                        icon: "slider.horizontal.3",
                        color: .green
                    )
                    
                    VStack(spacing: 16) {
                        MaintenanceRecordAddFieldView(
                            title: "Custom Field 1",
                            text: $customField1,
                            icon: "1.circle.fill",
                            placeholder: "Enter custom value"
                        )
                        
                        MaintenanceRecordAddFieldView(
                            title: "Custom Field 2",
                            text: $customField2,
                            icon: "2.circle.fill",
                            placeholder: "Enter custom value"
                        )
                        
                        MaintenanceRecordAddFieldView(
                            title: "Custom Field 3",
                            text: $customField3,
                            icon: "3.circle.fill",
                            placeholder: "Enter custom value"
                        )
                        
                        MaintenanceRecordAddFieldView(
                            title: "Custom Field 4",
                            text: $customField4,
                            icon: "4.circle.fill",
                            placeholder: "Enter custom value"
                        )
                        
                        MaintenanceRecordAddFieldView(
                            title: "Custom Field 5",
                            text: $customField5,
                            icon: "5.circle.fill",
                            placeholder: "Enter custom value"
                        )
                    }
                    
                    // Save Button
                    MaintenanceRecordAddSaveButtonView(action: saveRecord)
                        .padding(.top, 16)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Add Maintenance Record")
        .navigationBarItems(leading: Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        })
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text(isSuccess ? "Success" : "Validation Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    if isSuccess {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
        }
    }
    
    private func saveRecord() {
        var errors: [String] = []
        
        // Validation
        if performedBy.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• Performed By is required")
        }
        
        if serviceType.isEmpty {
            errors.append("• Service Type is required")
        }
        
        if location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• Location is required")
        }
        
        if status.isEmpty {
            errors.append("• Status is required")
        }
        
        if notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• Service Notes are required")
        }
        
        if costCents.isEmpty || Int(costCents) == nil {
            errors.append("• Valid cost is required")
        }
        
        if durationMinutes.isEmpty || Int(durationMinutes) == nil {
            errors.append("• Valid duration is required")
        }
        
        if conditionAfter.isEmpty {
            errors.append("• Condition After is required")
        }
        
        if approvedBy.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• Approved By is required")
        }
        
        if !errors.isEmpty {
            alertMessage = "Please fix the following errors:\n\n" + errors.joined(separator: "\n")
            isSuccess = false
            showingAlert = true
            return
        }
        
        // Create and save record
        let newRecord = MaintenanceRecord(
            listingID: dataManager.listings.first?.id ?? UUID(),
            serviceDate: serviceDate,
            performedBy: performedBy.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
            costCents: Int(costCents) ?? 0,
            durationMinutes: Int(durationMinutes) ?? 0,
            serviceType: serviceType,
            location: location.trimmingCharacters(in: .whitespacesAndNewlines),
            status: status,
            warrantyClaim: warrantyClaim,
            nextServiceDate: nextServiceDate,
            conditionAfter: conditionAfter,
            rating: rating,
            approvedBy: approvedBy.trimmingCharacters(in: .whitespacesAndNewlines),
            approvedDate: approvedDate,
            rejectionReason: rejectionReason.trimmingCharacters(in: .whitespacesAndNewlines),
            signature: signature.trimmingCharacters(in: .whitespacesAndNewlines),
            documentPath: documentPath.trimmingCharacters(in: .whitespacesAndNewlines),
            priorityLevel: priorityLevel,
            safetyNotes: safetyNotes.trimmingCharacters(in: .whitespacesAndNewlines),
            customField1: customField1.trimmingCharacters(in: .whitespacesAndNewlines),
            customField2: customField2.trimmingCharacters(in: .whitespacesAndNewlines),
            customField3: customField3.trimmingCharacters(in: .whitespacesAndNewlines),
            customField4: customField4.trimmingCharacters(in: .whitespacesAndNewlines),
            customField5: customField5.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        dataManager.addMaintenanceRecord(newRecord)
        
        alertMessage = "Maintenance record has been successfully created and saved to your records."
        isSuccess = true
        showingAlert = true
    }
}

@available(iOS 14.0, *)
struct MaintenanceRecordAddHeaderView: View {
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.green]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            
            Text("New Maintenance Record")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Fill in all required fields to create a comprehensive maintenance record")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 16)
    }
}

@available(iOS 14.0, *)
struct MaintenanceRecordAddSectionHeaderView: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title3)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            Rectangle()
                .fill(color.opacity(0.3))
                .frame(height: 2)
                .frame(maxWidth: 100)
        }
        .padding(.horizontal, 4)
    }
}

@available(iOS 14.0, *)
struct MaintenanceRecordAddFieldView: View {
    let title: String
    @Binding var text: String
    let icon: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.caption)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
        }
    }
}

@available(iOS 14.0, *)
struct MaintenanceRecordAddTextAreaView: View {
    let title: String
    @Binding var text: String
    let icon: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.caption)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            
            // iOS 14 compatible text editor alternative
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                }
                
                TextEditor(text: $text)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
            }
            .frame(minHeight: 80)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
        }
    }
}

@available(iOS 14.0, *)
struct MaintenanceRecordAddDatePickerView: View {
    let title: String
    @Binding var date: Date
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.caption)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            
            DatePicker("", selection: $date, displayedComponents: [.date])
                .datePickerStyle(CompactDatePickerStyle())
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
        }
    }
}

@available(iOS 14.0, *)
struct MaintenanceRecordAddPickerView: View {
    let title: String
    @Binding var selection: String
    let options: [String]
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.caption)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            
            Picker(title, selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
        }
    }
}

@available(iOS 14.0, *)
struct MaintenanceRecordAddStepperView: View {
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.caption)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Stepper(value: $value, in: range) {
                    Text("\(value)")
                        .font(.body)
                        .fontWeight(.medium)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
        }
    }
}

@available(iOS 14.0, *)
struct MaintenanceRecordAddToggleView: View {
    let title: String
    @Binding var isOn: Bool
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.caption)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

@available(iOS 14.0, *)
struct MaintenanceRecordAddSaveButtonView: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title3)
                
                Text("Save Maintenance Record")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.green]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
        }
    }
}
