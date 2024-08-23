//
//  DatePickerDialogeVC.swift
//  Numerologycalculator2
//
//  Created by ios01 on 22/08/24.
//

import SwiftUI

struct DatePickerDialogeVC: View
{
    @State private var day: String = "01"
    @State private var month: String = "01"
    @State private var year: String = "2023"
    @State private var showDatePicker = false
    @State private var validationMessage: String = ""
    
    private let daysRange = 1...31
    private let monthsRange = 1...12
    private let yearsRange = 1900...2100
    
    var body: some View {
        VStack {
            
            
//            Button(action: {
//               
//            }) {
//                Text("Select Date")
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
           
            
            if showDatePicker {
                VStack(spacing: 20) {
                    HStack {
                        VStack {
                            Text("Day")
                            HStack {
                                Button(action: {
                                    adjustDay(by: -1)
                                }) {
                                    Image(systemName: "minus.circle")
                                }
                                TextField("", text: $day, onEditingChanged: { _ in validateDay() })
                                    .keyboardType(.numberPad)
                                    .frame(width: 50)
                                    .multilineTextAlignment(.center)
                                Button(action: {
                                    adjustDay(by: 1)
                                }) {
                                    Image(systemName: "plus.circle")
                                }
                            }
                        }
                        
                        VStack {
                            Text("Month")
                            HStack {
                                Button(action: {
                                    adjustMonth(by: -1)
                                }) {
                                    Image(systemName: "minus.circle")
                                }
                                TextField("", text: $month, onEditingChanged: { _ in validateMonth() })
                                    .keyboardType(.numberPad)
                                    .frame(width: 50)
                                    .multilineTextAlignment(.center)
                                Button(action: {
                                    adjustMonth(by: 1)
                                }) {
                                    Image(systemName: "plus.circle")
                                }
                            }
                        }
                        
                        VStack {
                            Text("Year")
                            HStack {
                                Button(action: {
                                    adjustYear(by: -1)
                                }) {
                                    Image(systemName: "minus.circle")
                                }
                                TextField("", text: $year, onEditingChanged: { _ in validateYear() })
                                    .keyboardType(.numberPad)
                                    .frame(width: 80)
                                    .multilineTextAlignment(.center)
                                Button(action: {
                                    adjustYear(by: 1)
                                }) {
                                    Image(systemName: "plus.circle")
                                }
                            }
                        }
                    }
                    
                    if !validationMessage.isEmpty {
                        Text(validationMessage)
                            .foregroundColor(.red)
                    }
                    
                    Button("Done") {
                        if validateDate() {
                            showDatePicker = false
                        }
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)
            }
        }.onAppear(perform: {
            self.showDatePicker.toggle()
        })
        .onDisappear(perform: {
            let appdelegate : AppDelegate = AppDelegate()
            appdelegate.selectedDate = "\(formattedDate())"

        })
        .padding()
    }
    
    // Adjust functions
    private func adjustDay(by value: Int) {
        if let dayInt = Int(day) {
            let newDay = min(max(dayInt + value, daysRange.lowerBound), daysRange.upperBound)
            day = String(format: "%02d", newDay)
            validateDay()
        }
    }
    
    private func adjustMonth(by value: Int) {
        if let monthInt = Int(month) {
            let newMonth = min(max(monthInt + value, monthsRange.lowerBound), monthsRange.upperBound)
            month = String(format: "%02d", newMonth)
            validateMonth()
        }
    }
    
    private func adjustYear(by value: Int) {
        if let yearInt = Int(year) {
            let newYear = min(max(yearInt + value, yearsRange.lowerBound), yearsRange.upperBound)
            year = "\(newYear)"
            validateYear()
        }
    }
    
    // Validation functions
    private func validateDay() {
        if let dayInt = Int(day), daysRange.contains(dayInt) {
            validationMessage = ""
        } else {
            validationMessage = "Invalid day. Must be between 01 and \(daysRange.upperBound)."
        }
    }
    
    private func validateMonth() {
        if let monthInt = Int(month), monthsRange.contains(monthInt) {
            validationMessage = ""
        } else {
            validationMessage = "Invalid month. Must be between 01 and \(monthsRange.upperBound)."
        }
    }
    
    private func validateYear() {
        if let yearInt = Int(year), yearsRange.contains(yearInt) {
            validationMessage = ""
        } else {
            validationMessage = "Invalid year. Must be between \(yearsRange.lowerBound) and \(yearsRange.upperBound)."
        }
    }
    
    private func validateDate() -> Bool {
        validateDay()
        validateMonth()
        validateYear()
        return validationMessage.isEmpty
    }
    
    // Date formatting
    private func formattedDate() -> String {
        let dateComponents = DateComponents(year: Int(year), month: Int(month), day: Int(day))
        if let date = Calendar.current.date(from: dateComponents) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.dateFormat = "dd-MM-yyyy"
            return formatter.string(from: date)
        }
        return "Invalid Date"
    }
    
}



#Preview {
    DatePickerDialogeVC()
}
