//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Sky Pro on 26/02/20.
//  Copyright © 2020 Sky Pro. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
   // var dataArray:NSMutableArray!

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Employee> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()

        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)

        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()
    
    private func updateView() {
         var hasQuotes = false

           if let quotes = fetchedResultsController.fetchedObjects {
               hasQuotes = quotes.count > 0
           }

        tableView.isHidden = !hasQuotes
        messageLabel.isHidden = hasQuotes
        
        activityIndicatorView.stopAnimating()
    }
    private func setupView() {
        setupMessageLabel()

        updateView()
    }
    private func setupMessageLabel() {
        messageLabel.text = "You don't have any quotes yet."
    }
    
    // MARK: - Init
    static func initViewController() -> ViewController {
      let sb = UIStoryboard(name: "Main", bundle: nil)
      guard let controller = sb.instantiateViewController(withIdentifier: "ViewController") as? ViewController else{
        return UIViewController() as! ViewController
      }
      return controller
    }
    
     // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }

        self.updateView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        // Do any additional setup after loading the view.
    }
    // MARK: - Notification Handling

    @objc func applicationDidEnterBackground(_ notification: Notification) {
        do {
            try AppDelegate.appDelegate.persistentContainer.viewContext.save()
        } catch {
            print("Unable to Save Changes")
            print("\(error), \(error.localizedDescription)")
        }
    }
   
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationViewController = segue.destination as? AddDataController else { return }

        if let indexPath = tableView.indexPathForSelectedRow, segue.identifier == "SegueEditData" {
            // Configure View Controller
            destinationViewController.employee = fetchedResultsController.object(at: indexPath)
        }
    }
   
}
extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()

        updateView()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? DetailCell {
                configure(cell, at: indexPath)
            }
            break;
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
        default:
            print("...")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

    }
}

extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let employeeData = fetchedResultsController.fetchedObjects else { return 0 }
        return employeeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell:DetailCell = tableView.dequeueReusableCell(withIdentifier: DetailCell.reuseIdentifier, for: indexPath) as? DetailCell else {
            fatalError("Unexpected Index Path")
        }
        
//        let dictData:NSDictionary = dataArray.object(at: indexPath.row) as! NSDictionary
//
//        cell.lblName.text = dictData.value(forKey: "name") as? String
//        cell.lblCity.text = dictData.value(forKey: "city") as? String
//        cell.lblOrder.text = "\(dictData.value(forKey: "orderCnt") as! Int)"
        
//        // Fetch employee data
//        let employeeData = fetchedResultsController.object(at: indexPath)
//
//        // Configure Cell
//        cell.lblName.text = employeeData.name
//        cell.lblCity.text = employeeData.city
//        cell.lblOrder.text = "\(employeeData.orderCnt)"
        
        // Configure Cell
        configure(cell, at: indexPath)
        
        return cell
    }
    
    func configure(_ cell: DetailCell, at indexPath: IndexPath) {
       // Fetch employee data
        let employeeData = fetchedResultsController.object(at: indexPath)

        // Configure Cell
        cell.lblName.text = employeeData.name
        cell.lblCity.text = employeeData.city
        cell.lblOrder.text = "\(employeeData.orderCnt)"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Fetch Quote
            let employeeData = fetchedResultsController.object(at: indexPath)

            // Delete Quote
            employeeData.managedObjectContext?.delete(employeeData)
        }else if editingStyle == .insert{
            
        }
    }
}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
