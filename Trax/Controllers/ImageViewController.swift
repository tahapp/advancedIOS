//
//  ImageViewController.swift
//  Trax
//
//  Created by ben hussain on 11/5/23.
//

import UIKit

class ImageViewController: UIViewController {
    
   
    var imageURL: URL?
    {
        didSet
        {
            fetch()
        }
    }
    var image: UIImage?
    {
        didSet
        {
            imageView.image = image
            imageView.sizeToFit()
            scrollView.contentSize = imageView.bounds.size
        }
    }
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    override func loadView() {
        
        scrollView = UIScrollView() //either here or in viewdidLoad but you must specifiy the size
        view = scrollView
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imageView = UIImageView()
        scrollView.addSubview(imageView)
    }
 
    func fetch()
    {
   
        if let url = self.imageURL
        {
//            DispatchQueue.global(qos: .background).async
//            {
//                if let data = try? Data(contentsOf: url)
//                {
//                    let image = UIImage(data: data)
//                    DispatchQueue.main.async { [weak self] in
//                   
//                        self?.image = image
//                    }
//                    
//                }
//            }
            URLSession.shared.dataTask(with: .init(url: url)) { [weak self] data, response, error in // recomended for over the internet
                if error != nil
                {
                    print(error!)
                }
                if let data = data
                {
                   
                    let image = UIImage(data: data)
                    DispatchQueue.main.async{
                        
                        self?.image = image
                    }
                }
            }.resume()

        }
    }
}
