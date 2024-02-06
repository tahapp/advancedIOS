//
//  ViewController.swift
//  Smashtag
//
//  Created by ben hussain on 9/5/23.
//

import UIKit

class TweetTableViewController: UITableViewController, UITextFieldDelegate
{
    // MARK: - properties
    var contents = [TableViewCellContents]()
    var searchArray = [TableViewCellContents]()
    var searchText : String?
    {
        didSet
        {
            let filterData = contents.filter{ cellContent in
                return cellContent.title.contains(searchText!)
            }
            
            if !filterData.isEmpty
            {
                
                updateTableContent(with: filterData)
            }
            
        }
        
    }
    lazy var textField : UITextField = {
        
        let tf = UITextField(frame: .init(origin: .zero, size: .init(width: 0, height: 50)))
        // you have to soecifiy the height -most importantly-  when embedding a UIView to a tableHeaderView
        tf.delegate = self
        tf.placeholder = "Search"
        tf.borderStyle = .none
        searchText = tf.text // that's where we get the string from
        
        //tf.keyboardType = .twitter
        tf.clearButtonMode = .always
        return tf
    }()
    // MARK: - ViewController life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadTableContents()
        tableView.tableHeaderView = textField
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        /* when UIRefreshControll is not in tableview you have to treat it like other controlls, add it to subview */
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .edit, target: self, action: #selector(showCount))
        
    }
    // MARK: - contents modifiers
    func updateTableContent(with data: [TableViewCellContents])
    {
        self.contents = data
        print(contents.count)
        self.tableView.reloadData()
        
    }
    func loadTableContents()
    {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            if let rawData  = try? Data(contentsOf: URL(string:"https://jsonplaceholder.typicode.com/photos")!)
            {
                let decoder = JSONDecoder()
                if var finishedData = try? decoder.decode([TableViewCellContents].self, from: rawData)
                {
                    finishedData.removeLast(4900)
                    self?.contents = finishedData
                    self?.searchArray = finishedData
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    //self?.updateTableContent(with: finishedData)
                }
            }
        }
        
       
        
    }
    
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return contents.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tweet", for: indexPath) as? TweetTableViewCell else {return UITableViewCell()}
        cell.tweets =  contents[indexPath.row]
        return cell

    }
    // MARK: - TextField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        return true
    }
    // MARK: - Action Methods
    @objc func refresh(sender: UIRefreshControl)
    {
        sender.beginRefreshing() // you have to call it
        textField.text = ""
        if self.contents.count < 100
        {
            updateTableContent(with: searchArray)
        }
            
        sender.endRefreshing()
    }
    
    @objc func showCount()
    {
        let ac = UIAlertController(title: "\(contents.count)", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "ok", style: .cancel))
        present(ac, animated: true)
        
    }
}

