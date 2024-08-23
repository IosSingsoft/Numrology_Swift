//
//  ViewController.swift
//  Numrology_Swift
//
//  Created by ios01 on 14/08/24.
//

import UIKit
import Foundation
import SwiftUI


class CustomTextField: UITextField {
    var previousText: String = ""

    // This method is called whenever the text in the text field is changed.
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        previousText = self.text ?? ""
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    @objc func textFieldDidChange() {
        guard let currentText = self.text else { return }

        if let previousValue = previousText as String? , let currentValue = currentText as String?
        {
            if currentValue > previousValue {
                print("New text is greater than the previous text.")
            } else if currentValue < previousValue {
                print("New text is less than the previous text.")
                
            } else {
                print("New text is equal to the previous text.")
            }
        }
        else
        {
            print("Text comparison is not possible (text may not be a number).")
        }

        // Update previousText to the current text after comparison
        previousText = currentText
    }
}


enum DateError: Error {
    case invalidDay
    case invalidMonth
}

func formatDate(day: Int, month: Int) throws -> String {
    // Validate the day and month
    guard day > 0 && day <= 31 else {
        throw DateError.invalidDay
    }
    
    guard month > 0 && month <= 12 else {
        throw DateError.invalidMonth
    }
    
    // Format the day and month with leading zeros if needed
    let dayString = String(format: "%02d", day)
    let monthString = String(format: "%02d", month)
    
    return "\(dayString)-\(monthString)"
}




protocol CustomTextFieldDelegate: AnyObject {
    func didPressDeleteKey(in textField: CustomTextField)
}


class ViewController: UIViewController ,  UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource
{
    
    @IBOutlet weak var theContainer: UIView!
    @IBOutlet var entrada:UISegmentedControl!
    @IBOutlet var labelTotalCircle:UILabel!
    @IBOutlet var labelTotalVowelsCircle:UILabel!
    @IBOutlet var labelTotalConstantsCircle:UILabel!
    @IBOutlet var labelTotal:UILabel!
    @IBOutlet var labelTotalVowels:UILabel!
    @IBOutlet var labelTotalConstants:UILabel!
    @IBOutlet var ViewText:UIView!
    @IBOutlet var UicoolectionView:UICollectionView!

    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var CheldreanLabel: UILabel!
    @IBOutlet weak var PhythogoreusLabel: UILabel!

    @IBOutlet weak var toolbar: UIToolbar!
    var appDel = UIApplication.shared.delegate as! AppDelegate

    private var selectedDay: String = "01"
    private var selectedMonth: String = "01"
    private var selectedYear: String = "2023"
    private var name: String = ""
    private var IsShowDatePicker: Bool = false
    var previousText: String = ""
    var ValueChalrean: String = ""
    var ValueChalreanArray: [Dictionary<String, String>] = []
    var ValuePhytogireanArray: [Dictionary<String, String>] = []
    var Valuephytogorean: String = ""
    var ValuephytogoreanArray: [String] = [""]

        
    private var pickerData: [String] = []
    private var datePickerMode: DatePickerMode = .none
    
    @IBOutlet weak var firstView_Height: NSLayoutConstraint!
    @IBOutlet weak var firstView_Weight: NSLayoutConstraint!

    @IBOutlet weak var SecondView_Height: NSLayoutConstraint!
    @IBOutlet weak var SecondView_Weight: NSLayoutConstraint!
    
    var Items:[Int] = []

    var Items1: [[String: Any]] = [[:]]
    var theme: SambagTheme = .light
    var hasDayOfWeek: Bool = false
    var individualValue:String = ""
    enum DatePickerMode {
            case day, month, year, none
        }
    var meanValuesArray : [String] = ["","","0","0","0","1","1","",""]

    
    override func viewDidLoad() 
    {
        toolbar.isHidden = true
        pickerView.isHidden = true
        previousText = self.nameTextField.text ?? ""
        UicoolectionView.isHidden = true
         super.viewDidLoad()
                yearTextField.delegate = self
                nameTextField.delegate = self
                ViewText.isHidden = true
                // Initialize Picker
                nameTextField.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), for: .editingChanged)
                
                toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker))
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
           
    }
  

    
    // MARK: - Button Actions
        @objc func donePicker() {
            // Handle the done button action
            toolbar.isHidden = true
            pickerView.isHidden = true
            print("Done button pressed")
            self.view.endEditing(true) // Dismiss the picker
        }
        
        @objc func cancelPicker() 
        {
            // Handle the cancel button action
            print("Cancel button pressed")
            toolbar.isHidden = true
            pickerView.isHidden = true
            self.view.endEditing(true) // Dismiss the picker
        }
    
    @objc func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

//            let childView = UIHostingController(rootView: DatePickerDialogeVC())
//            addChild(childView)
//            childView.view.frame = theContainer.bounds
//            theContainer.addSubview(childView.view)
//            childView.didMove(toParent: self)
//            print("is clicked")
   
        
        return true
    }
  

    @objc func textFieldDidChange(_ textField: UITextField) {

        let calculator = NumerologyCalculator()
        name = nameTextField.text ?? "0"
        let chaldeanNumber = calculator.chaldeanNumerology(for: name)
        let pythagoreanNumber = calculator.pythagoreanNumerology(for: name)
        
        let chaldeanCounts = calculator.chaldeanVowelsAndConsonants(for: name)
        let pythagoreanCounts = calculator.pythagoreanVowelsAndConsonants(for: name)

        
        labelTotalCircle.text = String(chaldeanNumber)
        CheldreanLabel.text = String(chaldeanNumber)
        print("Numerology Number for John Doe: \(chaldeanNumber)")
       // drawBlackBorder(view: lbl, ColourName: .blue)
        
        drawBlackBorder(view: labelTotalCircle, ColourName: .blue)
        drawBlackBorder(view: labelTotalVowelsCircle, ColourName: .green)
        drawBlackBorder(view: labelTotalConstantsCircle, ColourName: .red)

        if entrada.selectedSegmentIndex == 0
        {
            let chaldeanCounts = calculator.chaldeanVowelsAndConsonants(for: name)
            labelTotalVowelsCircle.text = "\(chaldeanCounts.vowels)"
            labelTotalConstantsCircle.text = "\(chaldeanCounts.consonants)"
            
            // Update previousText to the current text after comparison
           
            UicoolectionView.isHidden = false
            guard let currentText = textField.text else { return }

            if let previousValue = previousText as String? , let currentValue = currentText as String?
            {
                if currentValue > previousValue {
                    print("New text is greater than the previous text.")
                    ValueChalreanArray.append(["Name":appDel.individualName,"Value":appDel.individualValu ])
                    UicoolectionView.reloadData()


                } else if currentValue < previousValue {
                    print("New text is less than the previous text.")
                    if ValueChalreanArray.count > 0
                    {
                        ValueChalreanArray.remove(at:ValueChalreanArray.count - 1 )
                        UicoolectionView.reloadData()
                        print(ValueChalreanArray)
                    }
                } else {
                    print("New text is equal to the previous text.")
                }
            }
            else
            {
                print("Text comparison is not possible (text may not be a number).")
            }

            previousText = currentText
        }
        else if entrada.selectedSegmentIndex == 1
        {
            let pythagoreanCounts = calculator.pythagoreanVowelsAndConsonants(for: name)
            labelTotalVowelsCircle.text = "\(pythagoreanCounts.vowels)"
            labelTotalConstantsCircle.text = "\(pythagoreanCounts.consonants)"

            UicoolectionView.isHidden = false
            guard let currentText = textField.text else { return }

            if let previousValue = previousText as String? , let currentValue = currentText as String?
            {
                if currentValue > previousValue {
                    print("New text is greater than the previous text.")
                    ValuePhytogireanArray.append(["Name":appDel.individualName,"Value":appDel.individualValu ])
                    UicoolectionView.reloadData()


                } else if currentValue < previousValue {
                    print("New text is less than the previous text.")
                    
//                    ValueChalreanArray.removeLast()
                    if ValuePhytogireanArray.count > 0
                    {
                        ValuePhytogireanArray.remove(at:ValuePhytogireanArray.count - 1 )
                        UicoolectionView.reloadData()
                        print(ValuePhytogireanArray)
                    }
                } else {
                    print("New text is equal to the previous text.")
                }
            }
            else
            {
                print("Text comparison is not possible (text may not be a number).")
            }

            
        }
        else
        {
            let pythagoreanCounts = calculator.pythagoreanVowelsAndConsonants(for: name)
            labelTotalVowelsCircle.text = "\(pythagoreanCounts.vowels)"
            labelTotalConstantsCircle.text = "\(pythagoreanCounts.consonants)"
            
            do {
                let formattedDate = try formatDate(day: 9, month: 8)
                print(formattedDate)  // Output: "09-08"
            } catch DateError.invalidDay {
                print("Error: Day is invalid")
            } catch DateError.invalidMonth {
                print("Error: Month is invalid")
            } catch {
                print("Unexpected error: \(error)")
            }
//            ValueChalreanArray.append(["Name":appDel.individualName,"Value":appDel.individualValu ])
//            UicoolectionView.isHidden = false
//            UicoolectionView.reloadData()
        }
        
       
    }
    
    func drawBlackBorder(view: UILabel, ColourName:UIColor)
    {
        view.layer.borderColor = ColourName.cgColor
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = view.frame.size.width/2.0
        view.backgroundColor = UIColor.clear
    }
     
    override func viewWillAppear(_ animated: Bool) 
    {
        entrada.setTitle("Chaldean", forSegmentAt: 0)
        entrada.setTitle("Pythagorean", forSegmentAt: 1)
        entrada.setTitle("Date", forSegmentAt: 2)
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
    )
        ConstrintsZero()
        labelTotalCircle.layer.masksToBounds = true
        labelTotalCircle.layer.cornerRadius = 5
        labelTotalCircle.layer.shadowColor = UIColor.blue.cgColor
        labelTotalVowelsCircle.layer.masksToBounds = true
        labelTotalVowelsCircle.layer.cornerRadius = 5
        labelTotalCircle.layer.shadowColor = UIColor.green.cgColor
        labelTotalConstantsCircle.layer.masksToBounds = true
        labelTotalConstantsCircle.layer.cornerRadius = 5
        labelTotalCircle.layer.shadowColor = UIColor.red.cgColor

    }
    
    @IBAction func buttonDate_Clicked(_ sender: UIButton)
    {
        let childView = UIHostingController(rootView: DatePickerDialogeVC())
        addChild(childView)
        childView.view.frame = theContainer.bounds
        theContainer.addSubview(childView.view)
        yearTextField.text = appDel.selectedDate

        // theContainer.showDatePicker.toggle()
        childView.didMove(toParent: self)
        print("is clicked")
    }
    
    @IBAction func methodSegment(_ sender: UISegmentedControl)
    {
        print("Hello")
        if entrada.selectedSegmentIndex == 0
        {
            pickerView.isHidden = true
            ViewText.isHidden = true
            toolbar.isHidden = true
            ConstrintsZero()
            let calculator = NumerologyCalculator()
            let chaldeanNumber = calculator.chaldeanNumerology(for: name)
            labelTotalCircle.text = String(chaldeanNumber)
            CheldreanLabel.text = String(chaldeanNumber)

            let chaldeanCounts = calculator.chaldeanVowelsAndConsonants(for: name)
            labelTotalVowelsCircle.text = "\(chaldeanCounts.vowels)"
            labelTotalConstantsCircle.text = "\(chaldeanCounts.consonants)"
            drawBlackBorder(view: labelTotalCircle, ColourName: .blue)
            drawBlackBorder(view: labelTotalVowelsCircle, ColourName: .green)
            drawBlackBorder(view: labelTotalConstantsCircle, ColourName: .red)
        }
        else if entrada.selectedSegmentIndex == 1
        {
            pickerView.isHidden = true
            toolbar.isHidden = true
            IsShowDatePicker = false
            ViewText.isHidden = true
            ConstrintsZero()
            let calculator = NumerologyCalculator()
            let pythagoreanNumber = calculator.pythagoreanNumerology(for: name)
            labelTotalCircle.text = String(pythagoreanNumber)
            PhythogoreusLabel.text = String(pythagoreanNumber)
            let pythagoreanCounts = calculator.pythagoreanVowelsAndConsonants(for: name)
            labelTotalVowelsCircle.text = "\(pythagoreanCounts.vowels)"
            labelTotalConstantsCircle.text = "\(pythagoreanCounts.consonants)"
            drawBlackBorder(view: labelTotalCircle, ColourName: .blue)
            drawBlackBorder(view: labelTotalVowelsCircle, ColourName: .green)
            drawBlackBorder(view: labelTotalConstantsCircle, ColourName: .red)

            
        }
        else
        {
            pickerView.isHidden = true
            IsShowDatePicker = true
            toolbar.isHidden = true
            ViewText.isHidden = false
            ConstrintsGreter()
            
            drawBlackBorder(view: labelTotalCircle, ColourName: .blue)
            drawBlackBorder(view: labelTotalVowelsCircle, ColourName: .green)
            drawBlackBorder(view: labelTotalConstantsCircle, ColourName: .red)

        }
    }
    
    
    func ConstrintsZero()  
    {
        firstView_Height.constant = 0
        firstView_Weight.constant = 0
        SecondView_Height.constant = 0
        SecondView_Weight.constant = 0
    }
    
    
    func ConstrintsGreter() 
    {
        firstView_Height.constant = 50
        firstView_Weight.constant = 50
        SecondView_Height.constant = 50
        SecondView_Weight.constant = 50

    }
    
    
       @IBAction func dayTextFieldTapped(_ sender: UITextField) 
        {
           showPicker(for: .day)
        }
       
       @IBAction func monthTextFieldTapped(_ sender: UITextField) 
        {
           showPicker(for: .month)
       }
       
       @IBAction func yearTextFieldTapped(_ sender: UITextField) {
           showPicker(for: .year)
       }
       
       @IBAction func doneButtonTapped(_ sender: UIButton) 
        {
           pickerView.isHidden = true
           toolbar.isHidden = true
           validateDate()
       }
       
       @IBAction func cancelButtonTapped(_ sender: UIButton) 
        {
           pickerView.isHidden = true
           toolbar.isHidden = true
        }
       
       // PickerView Data Source and Delegate Methods
       func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return pickerData.count
       }
       
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return pickerData[row]
       }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           switch datePickerMode {
           case .day:
               selectedDay = pickerData[row]
           case .month:
               selectedMonth = pickerData[row]
           case .year:
               selectedYear = pickerData[row]
               yearTextField.text = selectedYear
           default:
               break
           }
       }
       
       // Show Picker for Day, Month, or Year
       private func showPicker(for mode: DatePickerMode) 
    {
           datePickerMode = mode
           pickerData = getPickerData()
           pickerView.reloadAllComponents()
           pickerView.isHidden = false
           toolbar.isHidden = false
     }
       
       // Validation Functions
       private func validateDay() -> Bool 
        {
           if let dayInt = Int(selectedDay), dayInt >= 1 && dayInt <= 31 {
               errorLabel.text = ""
               return true
           } else {
               errorLabel.text = "Invalid day"
               return false
           }
       }
       
       private func validateMonth() -> Bool {
           if let monthInt = Int(selectedMonth), monthInt >= 1 && monthInt <= 12 {
               errorLabel.text = ""
               return true
           } else {
               errorLabel.text = "Invalid month"
               return false
           }
       }
       
       private func validateYear() -> Bool {
           if let yearInt = Int(selectedYear), yearInt >= 1 && yearInt <= 9999 {
               errorLabel.text = ""
               return true
           } else {
               errorLabel.text = "Invalid year"
               return false
           }
       }
       
       private func validateDate() {
           if validateDay() && validateMonth() && validateYear() {
               errorLabel.text = ""
           } else {
               errorLabel.text = "Invalid date"
           }
       }
       
       // Picker Data
       private func getPickerData() -> [String] {
           switch datePickerMode {
           case .day:
               return Array(1...31).map { String(format: "%02d", $0) }
           case .month:
               return Array(1...12).map { String(format: "%02d", $0) }
           case .year:
               return Array(1900...2024).map { String($0) }
           default:
               return []
           }
       }


    
    @IBAction func didChangeDayOfWeek() {
        hasDayOfWeek = !hasDayOfWeek
    }
    
    @IBAction func didChangeTheme() {
        switch theme {
        case .light: theme = .dark
        case .dark: theme = .light
        default: break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if entrada.selectedSegmentIndex == 0
        {
            return self.ValueChalreanArray.count
            
        }
        else if entrada.selectedSegmentIndex == 1
        {
            return self.ValuePhytogireanArray.count
        }
        else
        {
            return self.ValueChalreanArray.count
        }

         
      }
      
      // make a cell for each cell index path
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          
          // get a reference to our storyboard cell
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dataCollectionCell", for: indexPath as IndexPath) as! dataCollectionCell
          
          cell.View_CollectionCell.layer.cornerRadius = 20
          if entrada.selectedSegmentIndex == 0
          {
              let dicData = ValueChalreanArray[indexPath.row]
              cell.LblName_Innput.text = dicData["Name"]
              cell.LblNameValue_Innput.text = dicData["Value"]
          }
          else if entrada.selectedSegmentIndex == 1
          {
              let dicData = ValuePhytogireanArray[indexPath.row]
              cell.LblName_Innput.text = dicData["Name"]
              cell.LblNameValue_Innput.text = dicData["Value"]
          }
          else
          {
              let dicData = ValueChalreanArray[indexPath.row]
              cell.LblName_Innput.text = dicData["Name"]
              cell.LblNameValue_Innput.text = dicData["Value"]
          }
          
          // Use the outlet in our custom class to get a reference to the UILabel in the cell
         // cell.myLabel.text = self.items[indexPath.row] // The row value is the same as the index of the desired text within the array.
          //cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
          
          return cell
      }
      
      // MARK: - UICollectionViewDelegate protocol
      
      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          // handle tap events
          print("You selected cell #\(indexPath.item)!")
      }
}


class NumerologyCalculator {
    
    var appDel = UIApplication.shared.delegate as! AppDelegate

    func chaldeanNumerology(for name: String) -> Int {
        let letterToNumber: [Character: Int] = [
            "A": 1, "I": 1, "J": 1, "Q": 1, "Y": 1,
            "B": 2, "K": 2, "R": 2,
            "C": 3, "G": 3, "L": 3, "S": 3,
            "D": 4, "M": 4, "T": 4,
            "E": 5, "H": 5, "N": 5, "X": 5,
            "U": 6, "V": 6, "W": 6,
            "O": 7, "Z": 7,
            "F": 8, "P": 8
        ]
        
        return calculateSingleDigitNumerology(for: name, using: letterToNumber)
    }

    // Function to calculate numerology number using the Pythagorean system
    func pythagoreanNumerology(for name: String) -> Int {
        let letterToNumber: [Character: Int] = [
            "A": 1, "J": 1, "S": 1,
            "B": 2, "K": 2, "T": 2,
            "C": 3, "L": 3, "U": 3,
            "D": 4, "M": 4, "V": 4,
            "E": 5, "N": 5, "W": 5,
            "F": 6, "O": 6, "X": 6,
            "G": 7, "P": 7, "Y": 7,
            "H": 8, "Q": 8, "Z": 8,
            "I": 9, "R": 9
        ]
        
        return calculateSingleDigitNumerology(for: name, using: letterToNumber)
    }
    
    // Generalized function to calculate numerology number and reduce it to a single digit
    func calculateSingleDigitNumerology(for name: String, using letterToNumber: [Character: Int]) -> Int {
        let uppercasedName = name.uppercased()
        var sum = 0
        
        for character in uppercasedName {
            if let value = letterToNumber[character] {
                sum += value
                appDel.individualValu = "\(value)"
                appDel.individualName = "\(character)"
            }
        }
        
        // Reduce the sum to a single digit unless it's 11 or 22 (master numbers)
        sum = reduceToSingleDigit(sum)

        return sum
    }

    // Helper function to reduce the sum to a single digit
    func reduceToSingleDigit(_ number: Int) -> Int {
        var number = number
        
        while number > 9 && number != 11 && number != 22 {
            number = sumDigits(number)
        }
        
        return number
    }

    // Helper function to sum the digits of a number
    func sumDigits(_ number: Int) -> Int {
        var sum = 0
        var number = number
        
        while number > 0 {
            sum += number % 10
            number /= 10
        }
        
        return sum
    }
    
    func chaldeanVowelsAndConsonants(for name: String) -> (vowels: Int, consonants: Int) {
        let vowelsSet: Set<Character> = ["A", "E", "I", "O", "U"]
        return countVowelsAndConsonants(for: name, usingVowelSet: vowelsSet)
    }

    // Function to count vowels and consonants in the name using Pythagorean numerology
    func pythagoreanVowelsAndConsonants(for name: String) -> (vowels: Int, consonants: Int) {
        let vowelsSet: Set<Character> = ["A", "E", "I", "O", "U"]
        return countVowelsAndConsonants(for: name, usingVowelSet: vowelsSet)
    }

    // Generalized function to count vowels and consonants
    func countVowelsAndConsonants(for name: String, usingVowelSet vowelsSet: Set<Character>) -> (vowels: Int, consonants: Int) {
        let uppercasedName = name.uppercased()
        var vowelCount = 0
        var consonantCount = 0
        
        for character in uppercasedName {
            if vowelsSet.contains(character) {
                vowelCount += 1
            } else if character.isLetter {
                consonantCount += 1
            }
        }
        
        return (vowels: vowelCount, consonants: consonantCount)
    }
    
}

extension ViewController: SambagTimePickerViewControllerDelegate {
    
    func sambagTimePickerDidSet(_ viewController: SambagTimePickerViewController, result: SambagTimePickerResult) {
        resultLabel.text = "\(result)"
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func sambagTimePickerDidCancel(_ viewController: SambagTimePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    
}

extension ViewController: SambagMonthYearPickerViewControllerDelegate {

    func sambagMonthYearPickerDidSet(_ viewController: SambagMonthYearPickerViewController, result: SambagMonthYearPickerResult) {
        resultLabel.text = "\(result)"
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func sambagMonthYearPickerDidCancel(_ viewController: SambagMonthYearPickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: SambagDatePickerViewControllerDelegate {
    
    func sambagDatePickerDidSet(_ viewController: SambagDatePickerViewController, result: SambagDatePickerResult) {
        var text = result.description
        if viewController.hasDayOfWeek, let dayOfWeek = result.dayOfWeek {
            text = "\(dayOfWeek) " + text
        }
        resultLabel.text = text
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func sambagDatePickerDidCancel(_ viewController: SambagDatePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
   
    
    
    
}

