//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by ben hussain on 9/10/23.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    var tweets : TableViewCellContents? // public api instead of using my view
    {
        didSet
        {
            title.text = tweets?.title
            url.text = tweets?.url
            imageURL = URL(string: tweets!.url)
        }
    }
    private let title = UILabel()
    private let url =  UILabel()
    private var viewImage = UIImageView()
  
    private var imageURL : URL?
    {
        didSet
        {
            DispatchQueue.global(qos:.userInteractive).async {
                if let imageData = try? Data(contentsOf: self.imageURL!)
                {
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        self.viewImage.image = image
                    }
                    
                }
            }
            
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setUpViews()
    }
    
    func setUpViews()
    {
        title.font = .preferredFont(forTextStyle: .headline) /* in general when you have a custom ui, or you want an adaptive ui, always choose
                                                          methods with "estimated" or "prefered"*/
        title.numberOfLines = 0
        url.font = .preferredFont(forTextStyle: .body)
        url.numberOfLines = 0
        
        title.translatesAutoresizingMaskIntoConstraints = false
        url.translatesAutoresizingMaskIntoConstraints = false
        viewImage.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(title)
        contentView.addSubview(url)
        contentView.addSubview(viewImage)
        
        NSLayoutConstraint.activate([
            viewImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            viewImage.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            viewImage.widthAnchor.constraint(equalToConstant: 48),
            viewImage.heightAnchor.constraint(equalToConstant: 48),
            
            title.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            title.leadingAnchor.constraint(equalTo: viewImage.trailingAnchor),
            title.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            //title.heightAnchor.constraint(equalToConstant: 48),
            
            url.topAnchor.constraint(equalTo: title.safeAreaLayoutGuide.bottomAnchor),
            url.leadingAnchor.constraint(equalTo: viewImage.trailingAnchor),
            url.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            url.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
