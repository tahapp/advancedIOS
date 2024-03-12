//
//  CloudQandATableViewCell.swift
//  Pollster
//
//  Created by ben hussain on 2/13/24.
//

import UIKit

class CloudQandATableViewCell: UITableViewCell {

    
     let textView:UITextView = {
        let text = UITextView(frame: .zero)
         text .returnKeyType = .done
         text.autocorrectionType = .no
        
        return text
    }()
    var size:CGSize
    {
        return frame.size
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textView)
    }
  
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textView)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textView.sizeToFit()
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(lessThanOrEqualTo: contentView.topAnchor,constant: 0),
            textView.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor,constant: 0),
            textView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            textView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
    }
    
    override func prepareForReuse()
    {
        textView.text = nil
    }
    
    func configure(with text:String?)
    {
     
        guard text != nil else
        {
            
            return
        }
        
        let attributtedText = NSAttributedString(string: text!, attributes: [.font: UIFont.systemFont(ofSize: 20)])
        textView.attributedText = attributtedText
    }
}
/* textView.frame = contentView.bounds: This option sets the frame of the textView to match the bounds of the cell's contentView. This is the most appropriate choice for positioning the textView within the cell's content area. It ensures that the textView is correctly sized and positioned relative to the cell's content area.
 
 textView.bounds = contentView.frame: This option sets the bounds of the textView to match the frame of the cell's contentView. This operation would not produce the desired result, as it adjusts the internal coordinate system of the textView without affecting its position or size within the cell.
 
 textView.frame = contentView.frame This sets the frame of the textView to match the bounds of the cell's contentView. While it may work depending on the context, it doesn't consider the origin of the contentView frame relative to the cell itself, which might cause the textView to be positioned incorrectly within the cell.
 

 
 textView.bounds = contentView.bounds: This option adjusts the internal coordinate system of the textView to match the bounds of the cell's contentView. Similar to option 2, it does not directly affect the position or size of the textView within the cell.*/
