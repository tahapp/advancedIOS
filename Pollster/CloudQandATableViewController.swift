//
//  ViewController.swift
//  Pollster
//
//  Created by ben hussain on 2/13/24.
//

import UIKit
import CloudKit
class CloudQandATableViewController: QandATableViewController
{
    /* define the model, public api. we want to make our model non-optional, but because we don't have any value yet swift initalizer rules will prevent us from doing so.
     as a result , we make our public api get set property that gets the data from our optional internal API*/
    var ckQandARecord: CKRecord
    {
        get
        {
            if _ckQandARecord == nil
            {
                _ckQandARecord = CKRecord(recordType: Cloud.Entity.QandA)
            }
            return _ckQandARecord!
        }
        set
        {
            // because externally we deal with this propery, we have to make sure that what we set this property we must set the interanl API
            _ckQandARecord = newValue
        }
    }
    // define the internal model. the internal API is the one that sets our database
    private var _ckQandARecord:CKRecord?
    {
        didSet
        {
            let question = ckQandARecord[Cloud.Attribute.Question] as? String ?? "" // cast it
            let answers = ckQandARecord[Cloud.Attribute.Answers] as? [String] ?? []
            // interaction with the super class model
            qanda = QandA(question: question, answers: answers)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        asking = false
        //ckQandARecord = CKRecord(recordType: Cloud.Entity.QandA)

        
    }
    
    // how we would write what we write to the cloud 
    override func textViewDidEndEditing(_ textView: UITextView) {
        super.textViewDidEndEditing(textView)
        icloudUpdate()
        
    }
    private func saveToCloud(record:CKRecord)
    {
        DataBase.database.save(record) { record, error in
            guard let cloudError = error as? CKError else {return}
            if cloudError.code == .serverRecordChanged{}
            if let retryPeriod = cloudError.userInfo[CKErrorRetryAfterKey] as? TimeInterval
            {
                /* An NSNumber that contains the number of seconds until you can retry a request. CloudKit adds this key to the error’s userInfo dictionary when the error code is CKError.Code.serviceUnavailable or CKError.Code.requestRateLimited.*/
                DispatchQueue.main.async { [weak self] in
                    // because timer is used to update an element that are neccessary for the UI, we push it onto the main thread 
                    Timer.scheduledTimer(withTimeInterval: retryPeriod, repeats: false) { _ in
                        self?.icloudUpdate()
                    }
                }

                
            }
        }
    }
    private func icloudUpdate()
    {
        if qanda.isNotEmpty
        {
            ckQandARecord[Cloud.Attribute.Question] = qanda.question
            ckQandARecord[Cloud.Attribute.Answers] = qanda.answers
            saveToCloud(record: ckQandARecord)
        }
    }
}

