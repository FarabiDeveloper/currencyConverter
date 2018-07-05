//
//  ConverterViewController.swift
//  Currency Converter
//
//  Created by User on 24.06.2018.
//  Copyright © 2018 FarabiCorporation. All rights reserved.
//

import UIKit
import Moya

class ConverterViewController: UIViewController {
    
    @IBOutlet weak var firstCurrencyKeyTF: UITextField!
    @IBOutlet weak var firstCurrencyValueTF: UITextField!
    @IBOutlet weak var secondCurrencyKeyTF: UITextField!
    @IBOutlet weak var secondCurrencyValueTF: UITextField!
    
    var activeTF: UITextField?
    var firstTFValue: Double?
    var secondTFValue: Double?
    var firstKey: Double?
    var secondKey: Double?
    
    var rates = [Rate]()
    var convert = Convert() {
        didSet {
            self.rates = self.convert.rates.map { (key, value) -> Rate in
                return Rate(title: key, value: value)
            }.sorted { $0.title < $1.title }
            
            self.firstCurrencyValueTF.text = "1.0"
            self.firstTFValue = 1.0
            self.firstCurrencyKeyTF.text = self.convert.base
            self.firstKey = 1.0
            
            self.secondCurrencyKeyTF.text = self.rates.first?.title ?? ""
            self.secondCurrencyValueTF.text = self.rates.first?.value.description ?? ""
            self.secondTFValue = self.rates.first?.value
            self.secondKey = self.rates.first?.value
        }
    }
    let convertProvider = MoyaProvider<Api>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstCurrencyKeyTF.delegate = self
        self.secondCurrencyKeyTF.delegate = self
        self.firstCurrencyValueTF.delegate = self
        self.secondCurrencyValueTF.delegate = self
        self.createCurrencyPicker()
        self.createToolbar()
        self.getRequest()
        
        self.firstCurrencyValueTF.addTarget(self, action: #selector(firstValTFDidChange(_:)), for: .editingChanged)
        self.secondCurrencyValueTF.addTarget(self, action: #selector(secondValTFDidChange(_:)), for: .editingChanged)
    }

    @objc func firstValTFDidChange(_ textField: UITextField) {
        self.firstTFValue = Double(self.firstCurrencyValueTF.text!)
        guard let key = self.secondCurrencyKeyTF.text,
            let secondCurKey = self.convert.rates[key],
            let firstActive = self.firstTFValue,
            let fKey = self.firstKey
            else {
                return
        }
        self.secondCurrencyValueTF.text =
            ((secondCurKey * firstActive) / fKey ).description
    }
    
    @objc func secondValTFDidChange(_ textField: UITextField) {
        self.secondTFValue = Double(self.secondCurrencyValueTF.text!)
        self.firstTFValue = Double(self.firstCurrencyValueTF.text!)
        guard let key = self.firstCurrencyKeyTF.text,
            let firstCurKey = self.convert.rates[key],
            let secondActive = self.secondTFValue,
            let sKey = self.secondKey
            else {
                return
        }
        self.firstCurrencyValueTF.text =
            ((firstCurKey * secondActive) / sKey ).description
    }
    
    func getRequest() {
        self.convertProvider.request(.latest()) { (result) in
            if let error = result.error {
                self.showAlert(error.localizedDescription)
                return
            }
            switch result {
            case .success(let response):
                do {
                    let convertResponse = try JSONDecoder().decode(Convert.self, from: response.data)
                    self.convert = convertResponse
                } catch let error {
                    print("error: \(error)")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func showAlert(_ alertMessage: String)  {
        let alert = UIAlertController.init(title: nil, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func createCurrencyPicker() {
        let currencyPicker = UIPickerView()
        currencyPicker.delegate = self
        
        self.firstCurrencyKeyTF.inputView = currencyPicker
        self.secondCurrencyKeyTF.inputView = currencyPicker
    }
    
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        toolbar.barTintColor = .black
        toolbar.tintColor = .white
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self,
                                         action : #selector(ConverterViewController.dismissKeyboard))
        
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        self.secondCurrencyKeyTF.inputAccessoryView = toolbar
        self.firstCurrencyKeyTF.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

extension ConverterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return self.rates.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return self.rates[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
                    inComponent component: Int) {
        if activeTF == firstCurrencyKeyTF {
            self.firstCurrencyKeyTF.text = self.rates[row].title
            self.firstTFValue = Double(self.firstCurrencyValueTF.text!)
            
            guard let key = self.secondCurrencyKeyTF.text,
            let secondCurKey = self.convert.rates[key],
            let firstActive = self.firstTFValue
                else {
                    return
            }
            self.firstKey = self.rates[row].value
            self.secondCurrencyValueTF.text =
                ((secondCurKey * firstActive) / self.rates[row].value).description
        } else if activeTF == secondCurrencyKeyTF {
            self.secondCurrencyKeyTF.text = self.rates[row].title
            self.secondTFValue = Double(self.secondCurrencyValueTF.text!)
            guard let key = self.firstCurrencyKeyTF.text,
                let firstCurKey = self.convert.rates[key],
                let secondActive = self.secondTFValue
                else {
                    return
            }
            self.secondKey = self.rates[row].value
            
            self.firstCurrencyValueTF.text =
                (( firstCurKey * secondActive ) / self.rates[row].value ).description
        }
    }
}

extension ConverterViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.activeTF = textField
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard CharacterSet(charactersIn: "0123456789,.").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        return true
    }
}

