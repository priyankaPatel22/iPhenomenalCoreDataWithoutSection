//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Sky Pro on 25/02/20.
//  Copyright © 2020 Sky Pro. All rights reserved.
//

import UIKit
import CoreData

class AddDataController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtOrder: UITextField!
    
    // MARK: -

    var employee: Employee?
    
    // MARK: - Init
    static func initViewController() -> AddDataController {
      let sb = UIStoryboard(name: "Main", bundle: nil)
      guard let controller = sb.instantiateViewController(withIdentifier: "AddDataController") as? AddDataController else{
        return UIViewController() as! AddDataController
      }
      return controller
    }
    
    

       // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add employee data"
        
        if let employee = employee {
            txtName.text = employee.name
            txtCity.text = employee.city
            txtOrder.text = "\(employee.orderCnt)"
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        txtName.becomeFirstResponder()
    }
    
     // MARK: - Actions
    @IBAction func saveButtonClicked(_ sender: UIBarButtonItem) {
        
        let name = txtName.text
        if name == ""{
            print("name is empty")
            return
        }
        
        let city = txtCity.text
        if city == ""{
            print("city is empty")
            return
        }
        
        let order = txtOrder.text
        if order == ""{
             print("order is empty")
                       return
        }
       
       let context = AppDelegate.appDelegate.persistentContainer.viewContext
        
        if employee == nil {
            // Create Quote
            let newEmployee = Employee(context: context)
            
//            newEmployee.name = name
//            newEmployee.city = city
//            newEmployee.orderCnt = Int16(order ?? "0")!
            
            // Configure Quote
           // newQuote.createdAt = Date().timeIntervalSince1970
            
            // Set Quote
            employee = newEmployee
        }
        
        if let employee = employee {
            employee.name = name
            employee.city = city
            employee.orderCnt = Int16(order ?? "0")!
        }
        
        // Pop View Controller
        navigationController?.popViewController(animated: true)
        
//        do {
//            try context.save()
//            navigationController?.popViewController(animated: true)
//            
//        } catch {
//            print("Failed saving")
//        }
        
    }
    
}

