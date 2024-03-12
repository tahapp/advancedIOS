//
//  QandATableViewController.swift
//  Pollster
//
//  Created by ben hussain on 2/13/24.
//

import UIKit
struct QandA
{
    let question:String
    let answers : [String]
    
    var isNotEmpty:Bool
    {
        return !(question.isEmpty || answers.isEmpty)
    }
}
class QandATableViewController: TextTableViewController {
    var qanda:QandA
    {
        get
        {
            var answers = [String]()
            if data?.count ?? 0  > 1
            {
                for answer in data?.last ?? []
                {
                    if !answer.isEmpty
                    {
                        answers.append(answer)
                    }
                }
            }
            return QandA(question: data?.first?.first ?? " ", answers: answers)
        }
        set
        {
            var arr = newValue.answers
            arr.append("")
            data = [[newValue.question],arr]
            tableView.reloadData()
            //manageEmptyRow() to be inspected
        }
    }
//    var asking = false
//    {
//        didSet
//        {
//            if asking != oldValue // if newValue is different than the oldvalue then run
//            {
//                tableView.isEditing = asking
//                if view.window != nil
//                {
//                    disableTextViewEditing(asking)
//                }
//                
//            }
//        }
//    }
    var asking :Bool = false
    var answering:Bool
    {
        return !asking
    }
    struct Section
    {
        static let Questions = 0
        static let Answer = 1
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        disableTextViewEditing(answering)
        
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section
        {
        case 0:
            return "Question"
        case 1:
            return "Answers"
        default:
            return "unknown"
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        //cell.selectionStyle = (indexPath.section == Section.Answer) ? .gray : .none
        //cell.separatorInset = 
        return cell
    }
    /* // Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:*/
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        asking && indexPath.section == Section.Answer
    }
    //--- notes below
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        return indexPath.section == Section.Answer ? indexPath : nil
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
    }
    
    /* Together, these methods are used to control the selection behavior of rows in the table view. The willSelectRowAt method filters out certain rows based on their indexPath.section, while the didSelectRowAt method deselects the row to provide visual feedback to the user. This pattern might be used, for example, to prevent selection of certain rows or to enforce specific behavior when certain rows are selected*/
}
