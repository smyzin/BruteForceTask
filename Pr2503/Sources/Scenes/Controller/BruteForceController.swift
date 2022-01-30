//
//  BruteForceController.swift
//  Pr2503
//
//  Created by Sergey Myzin on 24.01.2022.
//

import UIKit

class BruteForceController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var generate: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var resultLabel: UILabel!
    
    // MARK: - Actions
    @IBAction func onBut(_ sender: Any) {
        isBlack.toggle()
    }
    @IBAction func GenAndBrut(_ sender: Any) {
        let password = generatePassword(length: 3)
        textField.text = password
        bruteForce(passwordToUnlock: password)
    }
    
    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
                resultLabel.textColor = .white
            } else {
                self.view.backgroundColor = .white
                resultLabel.textColor = .black
            }
        }
    }
    
    // MARK: - Setup elements view
    public func setupButton(state: UIControl.State = .normal) {
        generate.isEnabled = state == .normal
        generate.backgroundColor = state == .normal ? .systemOrange : .systemGray
        generate.layer.cornerRadius = Constants.cornerRadius
        generate.setTitleColor(.white, for: .normal)
        generate.setTitle(state == .normal ? "Generate" : "Brute Forcing ... ", for: state)
    }
    
    public func setupDefault() {
        indicator.isHidden = true
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.layer.borderColor = UIColor.orange.cgColor
        textField.isSecureTextEntry = true
        resultLabel.textColor = isBlack ? .white : .black
        resultLabel.text = "Click \"Generate\" to start magic"
    }
    
    public func hydrateProcess(state: ProcessState) -> Void {
        state == .forcing ? indicator.startAnimating() : indicator.stopAnimating()
        setupButton(state: state == .forcing ? .disabled : .normal)
        indicator.isHidden = state == .normal
        textField.isSecureTextEntry = state == .forcing
        resultLabel.text = "Forced password is \(state == .forcing ? "***" : textField.text ?? "Empty")"
    }
    
    // MARK: - Init after load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupDefault()
    }
    
    func bruteForce(passwordToUnlock: String) {
        let queue = DispatchQueue(label: "BruteForcing", qos: .background)
        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }
        
        var password: String = ""
        print("| Start brute force process (password is \(passwordToUnlock)) |")
        DispatchQueue.main.async {
            self.hydrateProcess(state: .forcing)
        }
        
        queue.async {
            while password != passwordToUnlock {
                password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
                print(password)
            }
            DispatchQueue.main.async {
                print("Complete brute forcing. The password is \(password)")
                self.hydrateProcess(state: .normal)
            }
        }
    }
}
