import Foundation

class Common: NSObject {

        static func isValidName(_ input: String) -> Bool {
            let nameRegex = "^[a-zA-Z]{2,20}$"
            return NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: input)
        }

        static func isValidEmail(_ input: String) -> Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,60}"
            return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: input)
        }

        static func isValidPhone(_ input: String) -> Bool {
            let phoneRegex = "^5[/0-9]{2}[\\s]{0,1}[/0-9]{3}[\\s]{0,1}[/0-9]{2}[\\s]{0,1}[/0-9]{2}$"
            return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: input)
        }

    }



