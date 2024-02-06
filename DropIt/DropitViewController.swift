//
//  ViewController.swift
//  DropIt
//
//  Created by ben hussain on 9/19/23.
//

import UIKit

func *(lhs:CGSize,rhs: CGFloat) ->CGSize
{
    return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
}
class DropitViewController: UIViewController ,UIDynamicAnimatorDelegate
{
    //MARK: - start
    var dropsPerRow  = 10 // how many boxes will drop from y = 0
    var dropSize: CGSize // computed instead of hardcoded
    {
        let size = view.bounds.size.width / CGFloat(dropsPerRow)
        return .init(square: size)
    }
    var tapGesture : UITapGestureRecognizer!
    var pangesture : UIPanGestureRecognizer!
    var animator : DropitBehavior!
    var dropedViews = [UIView]()
    let mainView = BezierPathView()
    var attachment: UIAttachmentBehavior? {// we only need it when we pan
        willSet
        {
            if let oldAttachment = attachment
            {
                animator.removeBehavior(oldAttachment)
                mainView.setPath(path: nil, name: PathNames.attachmentPath)
            }
            
        }
        didSet
        {
            if let newAttachment = attachment
            {
                print("called")
                animator.addBehavior(newAttachment)
                // draw attachment path
                
                attachment?.action = { [unowned self] in
                    if let attachedView = self.attachment?.items.first as? UIView
                    {
                        let path = UIBezierPath()
                        path.move(to: newAttachment.anchorPoint)
                        path.addLine(to: attachedView.center)
                        self.mainView.setPath(path: path, name: PathNames.attachmentPath)
                        /* this code will run once so, it will draw one line. to make a uikit keep drawing a line we have to call a method
                         that is always active, whihc is action closur.*/
                    }
                }
            }
        }
    }
    var lastDropedView: UIView!
    override func loadView() {
        
        
        mainView.backgroundColor = .systemBackground
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        animator = DropitBehavior(referenceView: self.view)
        animator.delegate = self
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dropGesture))
        pangesture = UIPanGestureRecognizer(target: self, action: #selector(attachPan))
        view.addGestureRecognizer(pangesture)
        view.addGestureRecognizer(tapGesture)
    }
    struct PathNames
    {
        static let middleBarrier : NSString = "MiddleBarrier"
        static let attachmentPath:NSString = "attachmentPath"
    }
    // to make the barrier always on the center, this is step 2 after the function
    override func viewDidLayoutSubviews() {
        let barrierSize = dropSize
        /* center it , it will place the top left corner at the center of the view so we offset it using
        barrierSize.width/2 and barrierSize.height/2 */
        let barrierOrigin = CGPoint(x: view.frame.midX - barrierSize.width/2, y: view.frame.midY - barrierSize.height/2)
        let path = UIBezierPath(ovalIn: CGRect(origin: barrierOrigin, size: barrierSize * 1 ))
        animator.addBarrier(path: path, name: PathNames.middleBarrier)
        mainView.setPath(path: path, name: PathNames.middleBarrier)
    }
    // MARK: - Drop
    @objc func dropGesture() //drop using gesture
    {
        drop()
    }
    @objc func attachPan(gesture: UIPanGestureRecognizer)
    {
        let point = gesture.location(in: mainView)
        
        switch gesture.state
        {
        case .began:
            attachment = UIAttachmentBehavior(item: lastDropedView, attachedToAnchor: point) // attach it to our finger instead of the barrier
            //lastDropedView = nil
        case .changed:
            attachment?.anchorPoint = point
        case .ended:
            attachment = nil
        default:
            break
            
        }
    }
    func drop() // drop programmatically
    {
        var frame = CGRect(origin: .zero, size: dropSize)
        frame.origin.x =  CGFloat.random(max: dropsPerRow) * dropSize.width
        let dropView = UIView(frame: frame)
        dropView.backgroundColor = .random
        lastDropedView = dropView
        dropedViews.append(dropView)
        //view.addSubview(dropView) substiuted by DropitBehavior
        animator.addDrop(drop: dropView)
    } 
  
    // MARK: - UIDynamicAnimatorDelegate
   
    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        
        guard let dropItAnimator = animator as? DropitBehavior else {return}
       // let views = dropItAnimator.items(in: self.view.frame) // because barrier will part of that items,we only want UIView that's why we reverted to use array.
        
        var boxesToDelete = [UIView]()
        let rowValue : CGFloat = 880.00
        
        for dropView  in dropedViews
        {
//            if let dropView = v as? UIView
//            {
                
                if dropView.frame.origin.y > rowValue
                {
                    boxesToDelete.append(dropView)
                    
                }
           // }
        }
        

        if boxesToDelete.count >= 9
        {
            for b in boxesToDelete
            {
                dropItAnimator.removeDrop(b)

            }

            boxesToDelete.removeAll(keepingCapacity: true)
        }
    }
    /* if you drop 5 boxes it is going to capture the last one. */
    

}

// MARK: - extension
private extension UIColor // this means that this extension will only work inside DropitViewcontroller
{
    static var random:UIColor
    {
        switch arc4random() % 5
        {
        case 0 : return .green
        case 1 : return .blue
        case 2 : return .orange
        case 3 : return .red
        case 4 : return .purple
        default : return .black
        }
    }
}

private extension CGFloat
{
    static func random(max:Int) ->CGFloat
    {
        return CGFloat(arc4random() % UInt32(max)) /* uses this insterad to increase the uniformty of the poisition
                                                    frame.origin.x = CGFloat.random(in: 1...dropsPerRow) * dropSize.width will result in
                                                    a lot of 3 but a few 2 which would cause a tower. you know what i mean.
                                                    */
    }
}

private extension CGSize
{
    init(square:CGFloat)
    {
        self.init(width: square, height: square)
    }
}
