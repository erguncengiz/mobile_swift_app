//
//  CardCell.swift
//  mobil_odev_contact_app
//
//  Created by Ergün Yunus Cengiz on 19.01.2021.
//

import UIKit

class CardCell: UITableViewCell {
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var personPhoneLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var personEmailLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var note: UILabel!

    ///Prototip cell'in hazırlanması
    func configure(personName : String, personPhoneNumber : String, personBirthday: String, personEmail: String, personNote: String) {
        personNameLabel.text = personName
        personPhoneLabel.text = personPhoneNumber
        birthdayLabel.text = personBirthday
        personEmailLabel.text = personEmail
        personPhoneLabel.text = personPhoneNumber
        noteLabel.text = personNote


        noteLabel.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        noteLabel.layer.borderWidth = 1
        noteLabel.layer.cornerRadius = 8
        noteLabel.backgroundColor = .systemGray2
        
    }

    
}
