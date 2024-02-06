//
//  Parser.swift
//  Smashtag
//
//  Created by ben hussain on 9/9/23.
//

import Foundation

class Parser
{
    var cellData = [TableViewCellContents]()
    init()
    {
        cellData = cellContens()
    }
    func cellContens() ->[TableViewCellContents]
    {
        var contentData = [TableViewCellContents]()
        if let data = try? Data(contentsOf: JSONurl)
        {
            let decoder = JSONDecoder()
            if let content = try? decoder.decode([TableViewCellContents].self, from: data)
            {
                contentData = content.dropLast(4900)
                
            }
        }
        
        return contentData
    }
    
    
}
