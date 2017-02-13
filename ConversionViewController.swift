//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Samantha Selleck on 1/29/17.
//  Copyright © 2017 CSC. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate
{
    
    /* var celsiusLabel: UILabel!   //definition ends with a !
       is declaring that you have a UILabel variable that may be empty (Optional), but you can
       access it pretending as if it will not - usually that means it would be an IBOutlet that 
       would be set by the interface storyboard on load, before you tried to use the label.
    */
    @IBOutlet var celsiusLabel: UILabel!
    
    @IBOutlet var textField: UITextField!
    
    // fahrenheitValue - optional because the user may not enter a value
    var fahrenheitValue: Measurement<UnitTemperature>?
    {
        didSet {
            updateCelsiusLabel()
        }
    }

    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits=0
        nf.maximumFractionDigits=1
        return nf
    }()
    
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField)
    {
        if let text = textField.text, let number = numberFormatter.number(from: text) {
            fahrenheitValue = Measurement(value: number.doubleValue, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
    }
    
    
    var celsiusValue: Measurement<UnitTemperature>?
    {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    
    //Function will either convert the number to the correct number or will display question marks
    func updateCelsiusLabel()
    {
        if let celsiusValue = celsiusValue {
            //celsiusLabel.text = "\(celsiusValue.value)"
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        } else {
            celsiusLabel.text = "???"
        }
    }
    
   
    //Function will ignore any characters or any new decimals other than numbers.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //Atempt to type in multiple decimal separators
        let currentLocale = Locale.current
        let decimalSeparator = currentLocale.decimalSeparator ?? "."
        let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
        let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
        
        let replacementTextHasLetter = string.rangeOfCharacter(from: NSCharacterSet.letters)
        
        //If there is an invalid character, return false
        if replacementTextHasLetter != nil {
            return false
        }
        
        //If the string already has a decimal, and the user inputs a new decimal,
        //reject the latest decimal
        if existingTextHasDecimalSeparator != nil, replacementTextHasDecimalSeparator != nil {
            return false
        }
        //If it is in the correct format than it will return true and continue
        return true
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer)
    {
        textField.resignFirstResponder()
    }
    
    //Silver Challenge Chp. 5, will change the map background color to the time of day.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendar  = Calendar.current
        let timeComponents = calendar.component(.hour, from: Date())
        let hour = timeComponents
        
        let colors = ["Morning": UIColor.init(red:0.961,  green:0.957,  blue:0.945, alpha:1),
                      "Afternoon" :UIColor.init(red:0.884,  green:0.884,  blue:0.888, alpha:1),
                      "Evening" : UIColor.init(red:0.784,  green:0.784,  blue:0.788, alpha:1)]
        switch hour {
        case  8...12:
            view.backgroundColor = colors["Morning"]
        case 12...18:
            view.backgroundColor = colors["Afternoon"]
        case 19...23:
            fallthrough
        case 0...7:
            view.backgroundColor = colors ["Evening"]
        default:
            view.backgroundColor = UIColor.white
        }
    }
}
