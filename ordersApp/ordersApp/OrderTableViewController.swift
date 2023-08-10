//
//  OrderTableViewController.swift
//  ordersApp
//
//  Created by Asmaa Mohamed on 09/08/2023.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    /*@IBAction func unwindToOrderList(segue: UIStoryboardSegue) {
    
    }*/
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem

        NotificationCenter.default.addObserver(tableView!,
            selector: #selector(UITableView.reloadData),
            name: MenuController.orderUpdatedNotification, object: nil)
       
    }
    
    var minutesToPrepareOrder = 0


    @IBSegueAction func confirmOrder(_ coder: NSCoder) -> OrderConfirmationViewController? {
        return OrderConfirmationViewController(coder: coder, minutesToPrepare: minutesToPrepareOrder)
        
        
        
    }
    
    @IBAction func unwindToOrderList(segue: UIStoryboardSegue) {
        if segue.identifier == "dismissConfirmation" {
            MenuController.shared.order.menuItems.removeAll()
        }
    }
    

    
    

    
    @IBAction func submitTapped(_ sender: Any) {
        let orderTotal =
           MenuController.shared.order.menuItems.reduce(0.0)
           { (result, menuItem) -> Double in
            return result + menuItem.price
        }

        let formattedTotal = orderTotal.formatted(.currency(code: "usd"))
    
        let alertController = UIAlertController(title: "Confirm Order", message: "You are about submit your order with a total of \(formattedTotal)", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Submit",
           style: .default, handler: { _ in
            self.uploadOrder()
        }))
    
        alertController.addAction(UIAlertAction(title: "Cancel",
           style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    func uploadOrder() {
        let menuIds = MenuController.shared.order.menuItems.map { $0.id }
        Task.init {
            do {
                let minutesToPrepare = try await
                   MenuController.shared.submitOrder(forMenuIDs: menuIds)
                minutesToPrepareOrder = minutesToPrepare
                performSegue(withIdentifier: "confirmOrder", sender: nil)
            } catch {
                displayError(error, title: "Order Submission Failed")
            }
        }
    }
    
    func displayError(_ error: Error, title: String) {
        guard let _ = viewIfLoaded?.window else { return }
        let alert = UIAlertController(title: title, message:
           error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default,
           handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MenuController.shared.order.menuItems.count
        

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Order", for: indexPath)
        configure(cell, forItemAt: indexPath)
        return cell
    }
    func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath){
        let menuItem = MenuController.shared.order.menuItems[indexPath.row]
        var content = cell.defaultContentConfiguration()
            content.text = menuItem.name
            content.secondaryText = menuItem.price.formatted(.currency(code: "usd"))
            content.image = UIImage(systemName: "photo.on.rectangle")
        
            cell.contentConfiguration = content
       
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MenuController.shared.order.menuItems.remove(at: indexPath.row)

            //tableView.deleteRows(at: [indexPath], with: .fade)
        } /*else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        } */
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
