//
//  ViewController.swift
//  CircleTimer
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var circleTimer: CircleTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.text ?? "")
        if let text = textField.text, let time = CFTimeInterval(text) {
            circleTimer.startTimer(duration: time)
        }
        return true
    }


}

