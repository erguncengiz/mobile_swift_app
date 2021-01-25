//
//  Person.swift
//  mobil_odev_contact_app
//
//  Created by Ergün Yunus Cengiz on 21.01.2021.
//

import Foundation

class Person{
    var personName:String = ""
    var personSurname:String = ""
    var date:String = ""
    var email:String = ""
    var phone:String = ""
    var note:String = ""

    func createPersonInfo(pName : String, pSurname : String, pDate : String ,pEmail : String, pPhone : String, pNote: String ){
        personName = pName
        personSurname = pSurname
        date = pDate
        email = pEmail
        phone = pPhone
        note = pNote
    }

}
