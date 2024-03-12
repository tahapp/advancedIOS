//
//  TextTableViewController.swift
//  Pollster
//
//  Created by ben hussain on 2/13/24.
//

import UIKit


class TextTableViewController: UITableViewController, UITextViewDelegate
{
    var data: [[String]]? = [[""],[""]]
    var textViewHeight:CGFloat?
    var cellIndexPath:IndexPath?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "edit", style: .done, target: self, action: #selector(toggleEdittingMode))
        tableView.separatorColor = .black
        tableView.separatorStyle = .singleLine
        tableView.register(CloudQandATableViewCell.self, forCellReuseIdentifier: "poll")
        //tableView.fillerRowHeight = UITableView.automaticDimension // it shows table view separator lines,instead of a blank screen,
        
    }
    
    // MARK: user
    @objc func toggleEdittingMode()
    {
       
        
        tableView.isEditing.toggle()
        if tableView.isEditing
        {
            disableTextViewEditing(false)
            navigationItem.rightBarButtonItem?.title = "done"
        }else
        {
            disableTextViewEditing(true)
            navigationItem.rightBarButtonItem?.title = "edit"
        }
        
    }
    @discardableResult
    func disableTextViewEditing(_ isEnabled:Bool) ->[UITextView]
    {
        let views = tableView.visibleCells.map({ $0.contentView}).map{ $0.subviews}
        let textViews = views.flatMap({$0.compactMap({$0 as? UITextView})})
        textViews.forEach{$0.isUserInteractionEnabled = isEnabled}
        return textViews
    }
    @objc func hideKeyboard(_ gesture:UITapGestureRecognizer)
    {
        let location = gesture.location(in: tableView)
        if let _ = tableView.indexPathForRow(at: location){
            print("inside")
            
        }
        else
        {
            tableView.endEditing(false)
            print("outside")
            /* This method looks at the current view and its subview hierarchy for the text field that is currently the first responder. If it finds one, it asks that text field to resign as first responder. If the force parameter is set to true, the text field is never even asked; it is forced to resign.
             the return value detemines whether it hides the keyboard or it did not
             */
            /* UIView.endEditing(_: Bool):
             
             For example, you might use it when the user taps outside of any text field to dismiss the keyboard.
             resignFirstResponder():
           
             For example, you might use it when the user taps a "Done" button next to a text field to dismiss the keyboard.*/
        }
    }
    //MARK: Data source
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        
        data?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        data?[section].count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "poll", for: indexPath) as? CloudQandATableViewCell else{
            return UITableViewCell()
        }
        
        let text = data?[indexPath.section][indexPath.row]
        cell.configure(with: text)
        textViewHeight = cell.textView.contentSize.height
        cell.textView.delegate = self
        
        return cell
    }
    //MARK: delegate
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing
        {
            return .delete
        }else
        {
            return .none
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        
        if sourceIndexPath.section == destinationIndexPath.section
        {
            
            //**for case sections are the same
            var reordedSection = data?[sourceIndexPath.section]
            let sourceIndex = sourceIndexPath.row
            let destinationIndex = destinationIndexPath.row
            reordedSection?.swapAt(destinationIndex, sourceIndex)
            self.data?[sourceIndexPath.section] = reordedSection!
            
            
        }else
        {
            var sourceSection = data?[sourceIndexPath.section]
            var destinationSection = data?[destinationIndexPath.section]
            
            let destinationElement = destinationSection?[destinationIndexPath.row]
            let sourceElement = sourceSection?[sourceIndexPath.row]
            
            destinationSection?.remove(at: destinationIndexPath.row)
            destinationSection?.insert(sourceElement!, at: destinationIndexPath.row)
            //print(destination)
            sourceSection?.remove(at: sourceIndexPath.row)
            sourceSection?.insert(destinationElement!, at: sourceIndexPath.row)
            
            self.data?[sourceIndexPath.section] = sourceSection!
            self.data?[destinationIndexPath.section] = destinationSection!
            
            
            
        }
    }
   
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        //this remves the padding from the table view when the editing mode is off
        true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            data?[indexPath.section].remove(at:indexPath.row)
        }
    }
    
    
    
   
    
    //MARK: TextDelegate
    func cellForTextView(textView:UITextView)->UITableViewCell?
    {
        var cellView = textView.superview
        while cellView != nil && !(cellView is UITableViewCell)
        {
            cellView = cellView?.superview as? UITableViewCell
        }
        return cellView as? UITableViewCell
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if let cell = cellForTextView(textView: textView),let indexPath = self.tableView.indexPath(for: cell)
        {
            self.cellIndexPath = indexPath
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count == 0 && data![cellIndexPath!.section].count > 1
        {
            if textView.text == "\n"
            {
                data![cellIndexPath!.section].remove(at: cellIndexPath!.row)
                tableView.deleteRows(at: [cellIndexPath!], with: .left)
            }
           
        }
        
    }
    // if it return true means apply the changes to  the text in the textview
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"
        {
            // if the user enter \n do not add it to the textview in cell (return false) and resignFirstResponser.
            textView.resignFirstResponder()
            return false
        }else
        {
            
            return true
        }
        
    }
    func textViewDidEndEditing(_ textView: UITextView)
    {
        
        guard data != nil ,cellIndexPath != nil, !textView.text.isEmpty else {return}
        var answers =  data![cellIndexPath!.section]
        if textView.text != answers[cellIndexPath!.row]
        {
            if answers[cellIndexPath!.row].isEmpty
            {
                answers.insert(textView.text, at: cellIndexPath!.row)
                data![cellIndexPath!.section] = answers
                tableView.reloadData()
            }else
            {
                data![cellIndexPath!.section].remove(at: cellIndexPath!.row)
                data![cellIndexPath!.section].insert(textView.text, at: cellIndexPath!.row)
                tableView.reloadData()
            }
            
        }
        
    }
  
}
