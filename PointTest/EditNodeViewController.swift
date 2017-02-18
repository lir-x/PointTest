//
//  EditNodeViewController.swift
//  PointTest
//
//  Created by Lir-x on 18.02.17.
//  Copyright © 2017 Lir-x. All rights reserved.
//

import UIKit


class EditNodeViewController: UIViewController, UITextFieldDelegate {
    
    struct Constants {
        static let namePlaceholder = "Name"
        static let xPositionPlaceholder = "X Position"
        static let yPositionPlaceholder = "Y Position"
    }
    
    var node:Node!
    
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var xPositionField: UITextField!
    @IBOutlet weak var yPositionField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAction(sender:)) )
        
        self.nameField.placeholder = Constants.namePlaceholder
        self.xPositionField.placeholder = Constants.xPositionPlaceholder
        self.yPositionField.placeholder = Constants.yPositionPlaceholder
        
        self.nameField.becomeFirstResponder()
        
        for field in [self.nameField, self.xPositionField, self.yPositionField] {
            
            field?.delegate = self
            
            if field == self.nameField || field == self.xPositionField {
                field?.returnKeyType = .next
            }
            
            if field == self.xPositionField || field == self.yPositionField {
                field?.keyboardType = .numbersAndPunctuation
            }
        }
        
        self.nameField.text = node.name
        
        self.xPositionField.text = "\(node.position.x)"
        self.yPositionField.text = "\(node.position.y)"
    
    }
    
    func saveAction(sender: UIBarButtonItem) {
        self.save()
    }
    
    func save() {
        
        if let name = self.nameField.text {
            self.node.name = name
        }
        if let xText = self.xPositionField.text {
            if let x = Float(xText) {
                self.node.position.x = CGFloat(x)
            }
        }
        
        if let yText = self.yPositionField.text {
            if let y = Float(yText) {
                self.node.position.y = CGFloat(y)
            }
        }
        
        _ = self.navigationController?.popViewController(animated: true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: -UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nameField{
            self.xPositionField.becomeFirstResponder()
        } else if textField == self.xPositionField {
            self.yPositionField.becomeFirstResponder()
        } else if textField == self.yPositionField {
            self.save()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.xPositionField || textField == self.yPositionField {
            if let s = textField.text {
                let nsString = s as NSString
                let newString = nsString.replacingCharacters(in: range, with: string) as NSString
                do {
                    //let pattern = "^([0-9]+)?(\\. ?([0-9]{1,2})?)?$"
                    let pattern = "^([0-9]{1,3}+)?(\\. ?([0-9]{1,2})?)?$"
                   // let pattern = "^(([0-9]+(?:\.[0-9]+)?)|([0-9]*(?:\.[0-9]+)?))$"
                    let regExp = try NSRegularExpression(pattern: pattern as String, options: .caseInsensitive)
                    let numberOfMatches = regExp.numberOfMatches(in: newString as String, options: [], range: NSMakeRange(0, newString.length))
                    if numberOfMatches == 0 {
                        return false
                    }
                    
                } catch {
                    
                }
            }
            
        
        }
        return true
    }


}
