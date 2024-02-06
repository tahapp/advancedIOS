//
//  DropitBehavior.swift
//  DropIt
//
//  Created by ben hussain on 9/19/23.
//

import UIKit

class DropitBehavior: UIDynamicAnimator
{
    // step one is to create a behaviors
    lazy var collider : UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        lazilyCreatedCollider.translatesReferenceBoundsIntoBoundary = true

        return lazilyCreatedCollider
    }()
    let gravity  = UIGravityBehavior()
    lazy var dropBehavior: UIDynamicItemBehavior =
    {
        let lazyDropBehavior = UIDynamicItemBehavior()
        lazyDropBehavior.allowsRotation = false // does not allow object to roll of the edge and fall
        lazyDropBehavior.elasticity = 0.5 // determine the bounce upon collision 0: nothing 1:super elastic
        return lazyDropBehavior
    }()
    
   
    // step two is add them to dynamic animator
    override init(referenceView view: UIView) {
        super.init(referenceView: view)
        addBehavior(collider)
        addBehavior(gravity)
        addBehavior(dropBehavior)
    }
    // step three is to add the view to the behavior.
    func addDrop(drop:UIView)
    {
        referenceView?.addSubview(drop) // instead of doing them in multiple places do them in single place.
        gravity.addItem(drop)
        collider.addItem(drop)
        dropBehavior.addItem(drop)
    }
    
    func removeDrop(_ drop:UIView)
    {
        gravity.removeItem(drop)
        collider.removeItem(drop)
        dropBehavior.removeItem(drop)
        
        drop.removeFromSuperview()
    }
    
    // this function will draw a circle in the middle of the view.
    func addBarrier(path : UIBezierPath, name:NSString)
    {
        collider.removeBoundary(withIdentifier: name) //remove any old path, we don't want unused path in our way
        collider.addBoundary(withIdentifier: name, for: path) // create a new boundary path, circle,line,...
    }
}
