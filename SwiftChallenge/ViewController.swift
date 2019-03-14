//
//  ViewController.swift
//  SwiftChallenge
//
//  Created by Kyler Jensen on 4/10/18.
//  Copyright © 2018 InMoment, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var enterTermTextField: UITextField!
    @IBOutlet var findDefinitionButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var definitionTextView: UITextView!
    @IBOutlet var currentPageIndexLabel: UILabel!
    @IBOutlet var currentTermIndexLabel: UILabel!
    @IBOutlet var currentTermLabel: UILabel!
    @IBOutlet var pagesExaminedLabel: UILabel!
    @IBOutlet var termsExaminedLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var activityIndicatorLabel: UILabel!
    
    private lazy var robot: Robot = RobotImpl(uiDelegate: self)
    private var cancelled = false
    private var busy: Bool = false {
        didSet {
            self.setBusy(busy)
        }
    }
    private lazy var search: Search = SearchImpl(uiDelegate: self,robot : robot)
    private lazy var binarySearch: BinarySearch = BinarySearchImpl(uiDelegate: self,robot: robot)
    
    /**
     This method instructs the robot to find the definition for a given search term.
     
     This method should:
       - Retrieve a search term term from the `enterTermTextField` text field.
       - Leverage `robot` to find the definition for the given search term.
       - Update the `definitionTextView` text view with the term's definition once it is found.
       - Call `completion` once the term's definition has been found.
       - Frequently check the status of `isCancelled` and call `completion` immediately if it is 'true'.
       - Ensure that all operations are performed on the right thread (queue).
       - Gracefully handle any errors or bad user input; feel free to use dialogs or get creative.
     
     You will receive bonus points for any of the following:
       - Your algorithm is particularly efficient.
       - You modify the UI in some way to make it more visually appealing.
       - You leverage some feature of Kotlin that is not available to Java.
       - You do something extra creative.
     
     */
    func findDefinition(words: String, completion: @escaping () -> Void) {
        //self.search.findWordWithRobot(wordToFind: self.enterTermTextField.text!.lowercased())
        DispatchQueue.global(qos: .background).async {
            self.binarySearch.findWordWithRobot(wordToFind:words.lowercased())
        }
    }
}

extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelled = false
        busy = false
        enterTermTextField.delegate = self
        enterTermTextField.returnKeyType=UIReturnKeyType.search
        self.hideKeyboardWhenTappedAround()
        cancelButton.layer.cornerRadius = 5
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.gray.cgColor
    }
    
    @IBAction func didTapFindDefinition(_ sender: Any) {
        definitionTextView.text = "The term's definition should appear here when found."
        busy = true
        self.enterTermTextField.resignFirstResponder()
        guard let words = self.enterTermTextField.text, !words.isEmpty else { self.busy = false; return }
        self.findDefinition(words: words, completion: {
            print("searching...")
            self.busy = false
            self.cancelled = false
        })
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        cancelled = true
        busy = false
    }
    
    private func setBusy(_ busy: Bool) {
        DispatchQueue.main.async {
            self.findDefinitionButton.isEnabled = !busy
            self.enterTermTextField.isEnabled = !busy
            self.cancelButton.isEnabled = busy
            self.activityIndicatorLabel.isHidden = !busy
            busy ? self.activityIndicator.startAnimating()
                 : self.activityIndicator.stopAnimating()
        }
    }
}

extension ViewController: RobotUserInterfaceDelegate {
    func updateUI(_ pageIndex: Int, _ termIndex: Int, _ pagesExamined: Int, _ termsExamined: Int, _ currentTerm: String?) {
        DispatchQueue.main.async {
            self.currentPageIndexLabel.text = pageIndex.description
            self.currentTermIndexLabel.text = termIndex.description
            self.currentTermLabel.text = currentTerm
            self.pagesExaminedLabel.text = pagesExamined.description
            self.termsExaminedLabel.text = termsExamined.description
        }
    }
    
    func updateBusyText(_ busyText: String?) {
        DispatchQueue.main.async {
            self.activityIndicatorLabel.text = busyText ?? "Robot is idle"
        }
    }
}

extension ViewController: SearchUserInterfaceDelegate {
    func showDefinition(_ definition: String?) {
        DispatchQueue.main.async {
            self.definitionTextView.text = definition
            self.busy = false
        }
    }
    
    func showWordNotFound(){
        let alert = UIAlertController(title: "Error", message: "Word Not Found. Please Try Again", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            self.busy = false
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        definitionTextView.text = "The term's definition should appear here when found."
        busy = true
        self.enterTermTextField.resignFirstResponder()
        guard let words = textField.text, !words.isEmpty else { self.busy = false; return false }
        self.findDefinition(words: words, completion: {
            print("searching...")
            self.busy = false
            self.cancelled = false
        })
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text!)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


