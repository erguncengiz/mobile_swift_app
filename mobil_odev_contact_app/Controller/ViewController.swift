//
//  ViewController.swift
//  mobil_odev_contact_app
//
//  Created by Ergün Yunus Cengiz on 19.01.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addPersonButton: UIButton!
    @IBOutlet weak var personInfosTableView: UITableView!

    var people: [NSManagedObject] = []
    var tmpPersonHolder : NSManagedObject!
    var tmpIndexHolder : Int!
    var list = ["A","B","C","Ç","D","E","F","G","H","I","İ","J","K","L","M","N","O","P","Q","R","S","Ş","T","U","Ü","V","W","X","Y","Z"];

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
       return list
   }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            fetchingFilteredSortedData(searchText: searchText)
        }else{
            fetchinSortedAllData()
        }
        personInfosTableView.reloadData()
    }

    func fetchingFilteredSortedData(searchText : String){
        var predicate: NSPredicate = NSPredicate()
        predicate = NSPredicate(format: "name contains[c] '\(searchText)'")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"People")
        let sort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = predicate
        do {
            people = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch. \(error)")
        }
    }

    func fetchinSortedAllData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "People")
        let sort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        do {
          people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        self.personInfosTableView.reloadData()
    }


    override func viewDidLoad() {

        searchBar.delegate = self
        personInfosTableView.delegate = self
        personInfosTableView.dataSource = self


        searchBar.layer.backgroundColor = .none
        personInfosTableView.rowHeight = UITableView.automaticDimension
        personInfosTableView.estimatedRowHeight = UITableView.automaticDimension

        //personInfosTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        super.viewDidLoad()
        self.personInfosTableView.contentInsetAdjustmentBehavior = .never

        addPersonButton.backgroundColor = UIColor.white
        addPersonButton.layer.cornerRadius = 10.0

    }
    @IBAction func toCreateOrUpdateButton(_ sender: Any) {
        self.shouldPerformSegue(withIdentifier: "toCreateOrUpdate", sender: self)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    /// Kaç adet satır döneceğini belirten method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }


    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delete(id: indexPath.row)
            people.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tmpPersonHolder = people[indexPath.row]
        tmpIndexHolder = indexPath.row
        self.performSegue(withIdentifier: "toCreateOrUpdate", sender: self)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreateOrUpdate" {

            let destinationVC = segue.destination as! CreateOrUpdatePersonViewController
            destinationVC.tmpPersonHolderCU = tmpPersonHolder
            destinationVC.tmpIndexHolderCU = tmpIndexHolder
            tmpPersonHolder = nil
        }
    }


    func delete(id : Int){
        let delegate = UIApplication.shared.delegate as! AppDelegate
             let context =  delegate.persistentContainer.viewContext
             let data = people[id]
             context.delete(data)
             do {
                 try context.save()
                 print("Silindi!")
             } catch {
                 print(error)
             }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchinSortedAllData()
    }
}

extension ViewController : UITableViewDataSource{
    ///Hangi Cell'lerin kullanıldığını tanımlayan method .
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let person = people[indexPath.row]
        let cell : CardCell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! CardCell
        cell.birthdayLabel.text = person.value(forKey: "date") as? String
        cell.personNameLabel.text = ((person.value(forKey: "name") as! String) + " " + (person.value(forKey: "surname") as! String))
        cell.personEmailLabel.text = person.value(forKey: "email") as? String
        cell.personPhoneLabel.text = person.value(forKey: "phone") as? String
        cell.noteLabel.text = person.value(forKey: "note") as? String
        cell.selectionStyle = .none

        return cell
    }
}


