
import UIKit
extension UIView
{
    func fourWayConstraints()
    {
        guard let parentView = superview else {return}
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parentView.topAnchor),
            leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
        ])
        
    }
    
}
