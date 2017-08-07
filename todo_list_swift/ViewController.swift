//
//  ViewController.swift
//  todo_list_swift
//
//  Created by Nick Bouldien on 8/6/17.
//  Copyright © 2017 Nick Bouldien. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var table: UITableView!

    var data: [String] = []
    var file: String!
    var selectedRow:Int = -1
    var newRowText:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Notes"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        let docsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        file = docsDir[0].appending("notes.txt")
        
        load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedRow == -1 {
            return
        }
        data[selectedRow] = newRowText
        if newRowText == "" {
            data.remove(at: selectedRow)
        }
        table.reloadData()
        save()
    }
    
    func addNote() {
        if table.isEditing {
            return
        }
        let name: String = "Row \(data.count + 1)"
        data.insert(name, at: 0)
        let indexPath: IndexPath = IndexPath(row: 0, section: 0)
        table.insertRows(at: [indexPath], with: .fade)
        table.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        performSegue(withIdentifier: "detail", sender: nil)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.setEditing(editing, animated: animated)
        save()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView:DetailViewController = segue.destination as! DetailViewController
        let selected = table.indexPathForSelectedRow!.row
        detailView.masterView = self
        detailView.setText(t: data[selected])
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        data.remove(at: indexPath.row)
        table.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(data[indexPath.row])
        performSegue(withIdentifier: "detail", sender: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! //UITableViewCell()
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func save() {
//        UserDefaults.standard.set(data, forKey: "notes")
//        UserDefaults.standard.synchronize()
        
        let newData: NSArray = NSArray(array: data)
        newData.write(toFile: file, atomically: true)
    }
    
    func load() {
//        if let loadedData = UserDefaults.standard.value(forKey: "notes") as? [String] {
//            data = loadedData
//            table.reloadData()
//        }
//        
        if let loadedData = NSArray(contentsOfFile:file) as? [String] {
            data = loadedData
            table.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

