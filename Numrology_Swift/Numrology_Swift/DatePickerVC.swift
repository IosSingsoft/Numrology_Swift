//
//  DatePickerVC.swift
//  Numrology_Swift
//
//  Created by ios01 on 22/08/24.
//


import UIKit
import SwiftUI

class DatePickerVC: UIViewController
{
        @IBOutlet weak var theContainer: UIView!
        @IBOutlet weak var dayTextField: UITextField!
        @IBOutlet weak var monthTextField: UITextField!
        @IBOutlet weak var yearTextField: UITextField!
        @IBOutlet weak var dateLabel: UILabel!
        @IBOutlet weak var validationLabel: UILabel!
        
         private var showDatePicker = false
        
        private let daysRange = 1...31
        private let monthsRange = 1...12
        private let yearsRange = 1900...2100
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
                    let childView = UIHostingController(rootView: DatePickerDialogeVC())
                    addChild(childView)
                    childView.view.frame = theContainer.bounds
                    theContainer.addSubview(childView.view)
                    childView.didMove(toParent: self)
            
            
            dayTextField.text = "01"
            monthTextField.text = "01"
            yearTextField.text = "2023"
            updateDateLabel()
        }
        
        @IBAction func selectDateTapped(_ sender: UIButton) {
            showDatePicker.toggle()
            // Logic to show/hide the date picker section
        }
        
        @IBAction func doneButtonTapped(_ sender: UIButton) {
            if validateDate() {
                showDatePicker = false
                // Logic to hide the date picker section
            }
        }
        
        // Adjust Functions
        @IBAction func adjustDayMinus(_ sender: UIButton) {
            adjustDay(by: -1)
        }
        
        @IBAction func adjustDayPlus(_ sender: UIButton) {
            adjustDay(by: 1)
        }
        
        @IBAction func adjustMonthMinus(_ sender: UIButton) {
            adjustMonth(by: -1)
        }
        
        @IBAction func adjustMonthPlus(_ sender: UIButton) {
            adjustMonth(by: 1)
        }
        
        @IBAction func adjustYearMinus(_ sender: UIButton) {
            adjustYear(by: -1)
        }
        
        @IBAction func adjustYearPlus(_ sender: UIButton) {
            adjustYear(by: 1)
        }
        
        private func adjustDay(by value: Int) {
            if let dayInt = Int(dayTextField.text ?? ""), daysRange.contains(dayInt + value) {
                dayTextField.text = String(format: "%02d", dayInt + value)
                validateDay()
                updateDateLabel()
            }
        }
        
        private func adjustMonth(by value: Int) {
            if let monthInt = Int(monthTextField.text ?? ""), monthsRange.contains(monthInt + value) {
                monthTextField.text = String(format: "%02d", monthInt + value)
                validateMonth()
                updateDateLabel()
            }
        }
        
        private func adjustYear(by value: Int) {
            if let yearInt = Int(yearTextField.text ?? ""), yearsRange.contains(yearInt + value) {
                yearTextField.text = "\(yearInt + value)"
                validateYear()
                updateDateLabel()
            }
        }
        
        // Validation Functions
        private func validateDay() 
        {
            if let dayInt = Int(dayTextField.text ?? ""), daysRange.contains(dayInt) {
                validationLabel.text = ""
            } else {
                validationLabel.text = "Invalid day. Must be between 01 and \(daysRange.upperBound)."
            }
        }
        
        private func validateMonth() 
        {
            if let monthInt = Int(monthTextField.text ?? ""), monthsRange.contains(monthInt) {
                validationLabel.text = ""
            } else {
                validationLabel.text = "Invalid month. Must be between 01 and \(monthsRange.upperBound)."
            }
        }
        
        private func validateYear() 
        {
            if let yearInt = Int(yearTextField.text ?? ""), yearsRange.contains(yearInt) {
                validationLabel.text = ""
            } else {
                validationLabel.text = "Invalid year. Must be between \(yearsRange.lowerBound) and \(yearsRange.upperBound)."
            }
        }
        
        private func validateDate() -> Bool {
            validateDay()
            validateMonth()
            validateYear()
            return validationLabel.text?.isEmpty ?? false
        }
        
        // Update Date Label
        private func updateDateLabel() {
            let dateComponents = DateComponents(year: Int(yearTextField.text ?? ""), month: Int(monthTextField.text ?? ""), day: Int(dayTextField.text ?? ""))
            if let date = Calendar.current.date(from: dateComponents) {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.dateFormat = "dd-MM-yyyy"
                dateLabel.text = formatter.string(from: date)
            } else {
                dateLabel.text = "Invalid Date"
            }
        }
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


