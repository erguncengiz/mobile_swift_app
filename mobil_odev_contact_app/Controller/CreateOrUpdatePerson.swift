//
//  CreateOrUpdatePerson.swift
//  mobil_odev_contact_app
//
//  Created by Ergün Yunus Cengiz on 20.01.2021.
//

import UIKit
import RAGTextField
import DatePicker
import CoreData
import SDCAlertView

class CreateOrUpdatePersonViewController : UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UITextViewDelegate{
    @IBOutlet weak var scrollInnerView: UIView!
    @IBOutlet weak var emailTextField: RAGTextField!
    @IBOutlet weak var nameTextField: RAGTextField!
    @IBOutlet weak var surnameTextField: RAGTextField!
    @IBOutlet weak var dateTextField: RAGTextField!
    @IBOutlet weak var phoneTextField: RAGTextField!
    @IBOutlet weak var createUpdateScrollView: UIScrollView!

    @IBOutlet weak var userNoteField: UITextView!
    
    @IBOutlet weak var createAndUpdateButton: UIButton!
    @IBOutlet weak var popButtonForUpdateAndCreate: UIButton!

    @IBOutlet weak var noteHintLabel: UILabel!

    let vc = ViewController()

    var offsetY:CGFloat = 0

    let alert = UIAlertController(title: "Kayıt Başarılı", message: nil, preferredStyle: .alert)

    var timer: Timer?
    var timeLeft = 1

    var tmpPersonHolderCU : NSManagedObject!
    var tmpIndexHolderCU : Int!


    override func viewWillAppear(_ animated: Bool) {
        if tmpPersonHolderCU != nil {
            nameTextField.text = tmpPersonHolderCU.value(forKey: "name") as? String
            surnameTextField.text = tmpPersonHolderCU.value(forKey: "surname") as? String
            phoneTextField.text = tmpPersonHolderCU.value(forKey: "phone") as? String
            emailTextField.text = tmpPersonHolderCU.value(forKey: "email") as? String
            dateTextField.text = tmpPersonHolderCU.value(forKey: "date") as? String
            userNoteField.text = tmpPersonHolderCU.value(forKey: "note") as? String
        }
    }


    override func viewDidLoad() {
        dateTextField.delegate = self
        nameTextField.delegate = self
        phoneTextField.delegate = self
        emailTextField.delegate = self
        createUpdateScrollView.delegate = self
        userNoteField.delegate = self


        nameTextField.placeholderAnimationDuration = 0.3
        nameTextField.layer.cornerRadius = 8
        nameTextField.placeholderScaleWhenEditing = 0.82
        nameTextField.textPaddingMode = .textAndPlaceholder

        surnameTextField.placeholderAnimationDuration = 0.3
        surnameTextField.layer.cornerRadius = 8
        surnameTextField.placeholderScaleWhenEditing = 0.82
        surnameTextField.textPaddingMode = .textAndPlaceholder

        dateTextField.placeholderAnimationDuration = 0.3
        dateTextField.layer.cornerRadius = 8
        dateTextField.placeholderScaleWhenEditing = 0.82
        dateTextField.textPaddingMode = .textAndPlaceholder

        emailTextField.placeholderAnimationDuration = 0.3
        emailTextField.layer.cornerRadius = 8
        emailTextField.placeholderScaleWhenEditing = 0.82
        emailTextField.textPaddingMode = .textAndPlaceholder

        phoneTextField.placeholderAnimationDuration = 0.3
        phoneTextField.layer.cornerRadius = 8
        phoneTextField.placeholderScaleWhenEditing = 0.82
        phoneTextField.textPaddingMode = .textAndPlaceholder

        userNoteField.layer.cornerRadius = 8

        popButtonForUpdateAndCreate.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        createAndUpdateButton.applyGradient(colors: [CGColor.init(red: 143/255, green: 103/255, blue: 232/255, alpha: 1),CGColor.init(red: 99/255, green: 87/255, blue: 204/255, alpha: 1)])

        createUpdateScrollView.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height)


        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
            view.addGestureRecognizer(tap)

    }

    @objc private func didTapButton(){
        tmpPersonHolderCU = nil
        dismiss(animated: true, completion: nil)
    }

    func isAllFieldsValid() -> Bool {
        var validName = true
        var validSurname = true
        var validPhone = true
        var validEmail = true
        var validDate = true
        var validNote = true

        if Common.isValidName(nameTextField.text!) == false {
            nameTextField.hintColor = .red
            nameTextField.hint = "Lütfen geçerli bir isim giriniz."
            validName  = false
        }else{
            nameTextField.hint = nil
        }
        if Common.isValidName(surnameTextField.text!) == false{
            surnameTextField.hintColor = .red
            surnameTextField.hint = "Lütfen geçerli bir soyisim giriniz."
             validSurname  = false
        }else{
            surnameTextField.hint = nil
        }
        if Common.isValidPhone(phoneTextField.text!) == false{
            phoneTextField.hintColor = .red
            phoneTextField.hint = "Lütfen geçerli bir telefon numarası giriniz."
             validPhone  = false
        }else{
            phoneTextField.hint = nil
        }
        if Common.isValidEmail(emailTextField.text!) == false {
            emailTextField.hintColor = .red
            emailTextField.hint = "Lütfen geçerli bir eposta giriniz."
             validEmail  = false
        }else{
            emailTextField.hint = nil
        }
        if dateTextField.text == ""{
            dateTextField.hintColor = .red
            dateTextField.hint = "Lütfen bir tarih seçiniz."
            validDate  = false
        }else{
            dateTextField.hint = nil
        }
        if userNoteField.text.count > 100 {
            noteHintLabel.textColor = .red
            noteHintLabel.text = "Notunuz 100 karakterden fazla olamaz."
            validNote = false
        }else{
            noteHintLabel.textColor = .none
        }

        if validName && validDate && validPhone && validEmail && validSurname && validNote{
            return true
        }else{
            return false
        }

    }

    func successAlert(){
        alert.setTitle(font: UIFont.boldSystemFont(ofSize: 19), color: .white)
        self.present(alert, animated: true, completion:  nil)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.timeLeft != 0 {
                    self.timeLeft -= 1
                } else {
                    self.dismissAlertView()
                    timer.invalidate()
                }
            }
            let imageView = UIImageView(frame: CGRect(x: 200, y: 20, width: 22, height: 22))
            imageView.image = UIImage.init(named: "success.svg")
            alert.view.addSubview(imageView)

                let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
            subview.layer.cornerRadius = 1
                subview.backgroundColor = UIColor(red: (62/255.0), green: (200/255.0), blue: (188/255.0), alpha: 1.0)
    }

    @IBAction func createAndUpdateButton(_ sender: Any) {
        if isAllFieldsValid() {
            if tmpIndexHolderCU != nil {
                updateData()
                successAlert()
            }else{
                let tmpPerson = Person()
                tmpPerson.createPersonInfo(pName: nameTextField.text!, pSurname: surnameTextField.text!, pDate: dateTextField.text!, pEmail: emailTextField.text!, pPhone: phoneTextField.text!, pNote: userNoteField.text ?? " ")
                self.save(name: tmpPerson.personName, surname: tmpPerson.personSurname, date: tmpPerson.date, email: tmpPerson.email, phone: tmpPerson.phone, note: tmpPerson.note)
                successAlert()
            }
        }else{
        }
    }

    func updateData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let tmpEmail = tmpPersonHolderCU.value(forKey: "email") as? String
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName:"People")
        fetchRequest.predicate = NSPredicate(format: "email = %@" , tmpEmail!)
        do{
            let test = try managedContext.fetch(fetchRequest)

            let objectUpdate = test[0] as! NSManagedObject
            objectUpdate.setValue(nameTextField.text, forKey: "name")
            objectUpdate.setValue(surnameTextField.text, forKey: "surname")
            objectUpdate.setValue(emailTextField.text, forKey: "email")
            objectUpdate.setValue(phoneTextField.text, forKey: "phone")
            objectUpdate.setValue(dateTextField.text, forKey: "date")
            objectUpdate.setValue(userNoteField.text, forKey: "note")
            do{
                try managedContext.save()
            }catch{
                print(error)
            }
        }catch{
            print(error)
        }
    }

    func save(name: String, surname: String, date: String, email: String, phone: String, note: String) {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      let managedContext = appDelegate.persistentContainer.viewContext
      let entity = NSEntityDescription.entity(forEntityName: "People", in: managedContext)!
      let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(name, forKey: "name")
        person.setValue(surname, forKey: "surname")
        person.setValue(date, forKey: "date")
        person.setValue(email, forKey: "email")
        person.setValue(phone, forKey: "phone")
        person.setValue(note, forKey: "note")
      do {
        try managedContext.save()
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func dismissAlertView() {
        alert.dismiss(animated: true, completion: nil)
    }

    @IBAction func didBeginEditingTextDate(_ sender: Any) {
        self.dateTextField.endEditing(true)
            let minDate = DatePickerHelper.shared.dateFrom(day: 01, month: 01, year: 1900)!
                    let maxDate = DatePickerHelper.shared.dateFrom(day: 31, month: 12, year: 2021)!
                    let today = Date()
                    // Create picker object
                    let datePicker = DatePicker()
                    // Setup
                    datePicker.setup(beginWith: today, min: minDate, max: maxDate) { (selected, date) in
                        if selected, let selectedDate = date {
                            self.dateTextField.text = ("\(selectedDate.day())/\(selectedDate.month())/\(selectedDate.year())")
                        }
                    }
                    // Display
            datePicker.show(in: self, on: sender as? UIView)
    }
}

extension UIButton {
    func applyGradient(colors: [CGColor]) {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = self.frame.height/2

        gradientLayer.shadowColor = UIColor.darkGray.cgColor
        gradientLayer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        gradientLayer.shadowRadius = 5.0
        gradientLayer.shadowOpacity = 0.3
        gradientLayer.masksToBounds = false

        self.layer.insertSublayer(gradientLayer, at: 0)
        self.contentVerticalAlignment = .center
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        self.titleLabel?.textColor = UIColor.white
    }
}

extension UIAlertController {
    func setTitle(font: UIFont?, color: UIColor?) {
            guard let title = self.title else { return }
            let attributeString = NSMutableAttributedString(string: title)//1
            if let titleFont = font {
                attributeString.addAttributes([NSAttributedString.Key.font : titleFont],//2
                                              range: NSMakeRange(0, title.utf16.count))
            }

            if let titleColor = color {
                attributeString.addAttributes([NSAttributedString.Key.foregroundColor : titleColor],//3
                                              range: NSMakeRange(0, title.utf16.count))
            }
            self.setValue(attributeString, forKey: "attributedTitle")//4
        }
}


