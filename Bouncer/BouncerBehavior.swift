//
//  BouncerBehavior.swift
//  Bouncer
//
//  Created by ben hussain on 10/23/23.
//

import UIKit

class BouncerBehavior: UIDynamicBehavior
{
    // step one is to create a behaviors
    lazy var collider : UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        lazilyCreatedCollider.translatesReferenceBoundsIntoBoundary = true

        return lazilyCreatedCollider
    }()
    let gravity  = UIGravityBehavior()
    lazy var blockBehavior: UIDynamicItemBehavior =
    {
        let lazyBlockBehavior = UIDynamicItemBehavior()
        lazyBlockBehavior.allowsRotation = false // does not allow object to roll of the edge and fall
        lazyBlockBehavior.elasticity = 0.85 // determine the bounce upon collision 0: nothing 1:super elastic
        lazyBlockBehavior.friction = 0
        lazyBlockBehavior.resistance = 0
        return lazyBlockBehavior
    }()
    
   
    // step two is add them to dynamic animator
    override init() {
        super.init()
        addChildBehavior(collider)
        addChildBehavior(gravity)
        addChildBehavior(blockBehavior)
    }
        
      
    
    // step three is to add the view to the behavior.
    func addBlock(block:UIView)
    {
        dynamicAnimator?.referenceView?.addSubview(block) // instead of doing them in multiple places do them in single place.
        gravity.addItem(block)
        collider.addItem(block)
        blockBehavior.addItem(block)
    }
    
    func removeBlock(_ block:UIView)
    {
        gravity.removeItem(block)
        collider.removeItem(block)
        blockBehavior.removeItem(block)
        
        block.removeFromSuperview()
    }
    
    // this function will draw a circle in the middle of the view.
    func addBarrier(path : UIBezierPath, name:NSString)
    {
        collider.removeBoundary(withIdentifier: name) //remove any old path, we don't want unused path in our way
        collider.addBoundary(withIdentifier: name, for: path) // create a new boundary path, circle,line,...
    }
}
