//
//  AllQandATableViewController.swift
//  Pollster
//
//  Created by ben hussain on 3/6/24.
//

import UIKit
import CloudKit
fileprivate struct Constants
{
    static let identifier = "question"
    static let segue = "presentAnswers"
}
class AllQandATableViewController: UITableViewController
{
    var allQandA : [CKRecord] = []
    {
        didSet
        {
            tableView.reloadData()
        }
    }
    
    
    private let subscribitionID = "all QandA creation and deleting"
    private var icloudObserver:NSObjectProtocol?
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        fetchAllQandA()
        iCloudSubscribeToQandAs()
//        let unmanaged = Unmanaged.passUnretained(self)
//        let address = unmanaged.toOpaque()
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unsubscribe()
    }
    private func fetchAllQandA()
    {
        let predicate = NSPredicate(format:"TRUEPREDICATE") //this is a special predicate that means all
        let query = CKQuery(recordType: Cloud.Entity.QandA, predicate: predicate)
        
        // sort the result based on their question in the ascending order.
        query.sortDescriptors = [NSSortDescriptor(key: Cloud.Attribute.Question, ascending: true)]
        DataBase.database.perform(query, inZoneWith: nil) { [weak self] records, error in
            if records != nil && error == nil
            {
                if records!.count > 0
                {
                    DispatchQueue.main.async {
                        self?.allQandA = records! //because 'allQandA' has a ui element, tableView.reloadData()
                    }

                }
            }else
            {
                print(error?.localizedDescription ?? "no error was found")
            }
        }
        
        
    }
    private func iCloudSubscribeToQandAs()
    {
        let predicate = NSPredicate(format: "TRUEPREDICATE")
        // subcription watches icloud database for changes and notify the user for chjagens through notifications
        let subscribtion = CKQuerySubscription(recordType: Cloud.Entity.QandA, predicate: predicate, subscriptionID: subscribitionID,options: [.firesOnRecordCreation,
                                                                                                                                               .firesOnRecordDeletion])
        //subscribtion.notificationInfo == ... this can be used to say what happens when notifications comes, does show something does it play certain sound
        DataBase.database.save(subscribtion) { savedsubscribtion, error  in
            guard let cloudError = error as? CKError else {return}
            if cloudError.code == .serverRejectedRequest
            {
                // subscription lives on the app no matter if you rebuild the app again. so this error may occurs  when
                // you run the app and stop it in the middle, then run it  again. here cloud kit will recieve two subscription request
                // which may result in an error. 
                //ignore
            }else
            {
                //report
            }
        }
        
        icloudHandleSubscription()
        
    }
    // you must always delete subscription when the view is off-screen
    private func unsubscribe()
    {
        Task
        {
            do
            {
                try await DataBase.database.deleteSubscription(withID:self.subscribitionID)
            }catch
            {
                print(error.localizedDescription)
            }

        }
        if icloudObserver != nil
        {
            NotificationCenter.default.removeObserver(icloudObserver!)
        }
        
    }
    private func icloudHandleSubscription()
    {
        let notificationSender = UIApplication.shared.delegate as? AppDelegate
        
        icloudObserver = NotificationCenter.default.addObserver(forName: .init(CloudKitNotifications.NotificationReceived),
                                                                object: notificationSender, queue: .main, using: { [weak self] notification in
            if let ckqn = notification.userInfo?[CloudKitNotifications.NotificationKey] as? CKQueryNotification
            {
                if ckqn.subscriptionID == self?.subscribitionID
                {
                    /* you might have a lot of vc that gets pushing notification from cloudkit, so you have to make sure that
                     you responding to subscription that matches this view controller. */
                    if let recordID = ckqn.recordID
                    {
                        let record = CKRecord(recordType: Cloud.Entity.QandA, recordID: recordID)
                        switch ckqn.queryNotificationReason { // this tells me the reason that subscription was triggered
                        case .recordCreated:
                            // a record could be created by another user, and i need to display it in my UI,
                            // so i need to fetch it first.
                            DataBase.database.fetch(withRecordID: recordID) { newlyCreatedRecord, error in
                                if newlyCreatedRecord != nil
                                {
                                    DispatchQueue.main.async {
                                        // the new record was soreted by the database in an ascending order, now we have to
                                        // mirror the database sorting organzation to the arrray
                                        let sortedQandA =  self?.allQandA.sorted(by: { (record1, record2) in
                                            
                                            if let Q1  = record1[Cloud.Attribute.Question] as? String, let Q2 = record2[Cloud.Attribute.Question] as? String
                                            {
                                                return Q1 < Q2
                                            }else
                                            {
                                                return false
                                            }
                                            
                                        })
                                        self?.allQandA = sortedQandA ?? []
                                        
                                    }
                                }
                            }
                            
                        case .recordUpdated:
                            DispatchQueue.main.async {
                                if let index = self?.allQandA.firstIndex(of: record)
                                {
                                    self?.allQandA[index] = record
                                }
                            }

                        case .recordDeleted:
                            DispatchQueue.main.async {
                                if let index = self?.allQandA.firstIndex(of: record)
                                {
                                    self?.allQandA.remove(at: index)
                                }
                            }

                        @unknown default:
                            print("")
                        }
                    }
                }
            }
            
        })
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allQandA.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifier, for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = allQandA[indexPath.row][Cloud.Attribute.Question] as? String ?? ""
        cell.contentConfiguration = config
        return cell
    }
    
    
    @IBAction func showAnswers(_ sender: UIBarButtonItem) 
    {
        let cloudQandATVC = CloudQandATableViewController()
        // if the + button is pressed, create a new entity
        cloudQandATVC.ckQandARecord = CKRecord(recordType: Cloud.Entity.QandA)
        navigationController?.pushViewController(cloudQandATVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) 
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let cloudQandATVC = CloudQandATableViewController()
        // if cell was cliked show the answers for the question
        cloudQandATVC.ckQandARecord = allQandA[indexPath.row]
        navigationController?.pushViewController(cloudQandATVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return allQandA[indexPath.row].wasCreatedByThisUser
        // only allow questions added by the current user and not anyone else
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        if editingStyle == .delete
        {
            /*tableView.deleteRows(at: [indexPath], with: .left) no need to call this inside
             a delegate deleting method. this will cause a double deleting behavior which is more prone to changes*/
            DataBase.database.delete(withRecordID: allQandA[indexPath.row].recordID) { id, error in
                //handle errors
            }
            allQandA.remove(at: indexPath.row)
            
        }
        
    }
    
}
