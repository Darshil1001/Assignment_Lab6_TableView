//
//  ViewController.swift
//  Assignment_Lab6_TableView
//
//  Created by user238116 on 2/18/24.
//

import UIKit

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBAction func addButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
                alert.addTextField { (textField) in
                    textField.placeholder = "Write an Item"
                }
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {[weak alert](_) in
                    alert?.dismiss(animated: true)
                }))
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                    let textField = alert?.textFields![0]
                    self.items.append(textField!.text!)
                    UserDefaults.standard.set(self.items, forKey: "savedItems")
                    UserDefaults.standard.synchronize()
                    self.myTableView.beginUpdates()
                    self.myTableView.insertRows(at: [IndexPath(row: self.items.count-1, section: 0)], with: .automatic)
                    self.myTableView.endUpdates()
                }))
                self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var myTableView: UITableView!
    var items: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self
        
        let savedItems: [String] = UserDefaults.standard.array(forKey: "savedItems") as? [String] ?? []
        if !savedItems.isEmpty{
            self.items = savedItems
        }
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
            if editingStyle == .delete {
                self.items.remove(at: indexPath.row)
                UserDefaults.standard.set(self.items, forKey: "savedItems")
                UserDefaults.standard.synchronize()
                self.myTableView.deleteRows(at: [indexPath], with: .automatic)
            }
    }
    

}

