//
//  ViewController.swift
//  Trax
//
//  Created by ben hussain on 10/14/23.
//

import UIKit
import MapKit
/*  UIView.top > UITextField.bottom this means that
 UIView.top should be below UITextField.bottom

 UIView.trailingAnchor > UITextField.leadingAnchor means that
 UIView.trailingAnchor should be to the left side of the UITExtField
 horizontaly below UITextField*/
class GPXViewController: UIViewController, MKMapViewDelegate,UIPopoverPresentationControllerDelegate
{
    
    let parser = GPXParser()
    var longPress : UILongPressGestureRecognizer!
    var gpxURL: URL?{ // public api
        didSet
        {
            clearWayPoints()
            if let url = gpxURL
            {
                parser.startParsin(url: url)
                do
                {
                    try handleWayPoints(parser.wayPoints)
                }catch let AllErrors.castFail(reason)
                {
                    print(reason)
                }catch
                {
                    print("UIKit error thrown from handleWayPoints ")
                }
                
            }
        }
    }
 
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    {
        didSet
        {
            
            mapView.mapType = .satellite
            mapView.delegate = self
        }
    }
    // MARK: - lifeCycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
       // presentationController?.delegate = self
        
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(addPin))
        view.addGestureRecognizer(longPress)
        
    }
   
    override func viewDidAppear(_ animated: Bool) { // we did it in viewDidAppear because that's when the windowScence is avaialbe in the controller life cycle
        super.viewDidAppear(animated)
        
        
        guard let window = view?.window?.windowScene?.delegate as? SceneDelegate else // that's how you get to the sceneDelegate
        {
            fatalError("falied to cast")

        }
        let center = NotificationCenter.default
        center.addObserver(forName: Notification.Name(GPXKey.notification), object: window  , queue: .main){[weak self] notification in
            
            if let url = notification.userInfo?[GPXKey.key] as? URL
            {
                self?.openFile(url: url)
                
            }else
            {
                fatalError("no data")
            }
            
        }
    }
    // MARK: - user defined
    func openFile(url:URL)
    {
        if url.startAccessingSecurityScopedResource()
        {
            defer {
                url.stopAccessingSecurityScopedResource()
                /* this when defer is useful. before i was thinking that what is the point in putting code in defer when
                 i can manualy place that code  at the end of the function? but when a function calls other functions there are chains
                 of function calling, for example here if i put 'stopAccessingSecurityScopedResource()' at the end it will stop giving my
                 app a permission to read the file while i am in a different thread needs that permission. */
            }
            gpxURL = url
        }
        
    }
    
    private func clearWayPoints()
    {
        if mapView?.annotations != nil
        {
            mapView.removeAnnotations(mapView.annotations)
        }
        
    }
    @objc func addPin(_ gesture: UILongPressGestureRecognizer)
    {
        if gesture.state == .began // if longpress is determined and not just a touch
        {
            let location = gesture.location(in: mapView)
           
            let coordiate = mapView.convert(location, toCoordinateFrom: mapView)
            /*this method above convert (x,y) points in the corrdinate system into actual and real map coordinates */
            let waypoint = EditableWayPoint(lat: coordiate.latitude, lon: coordiate.longitude, name: "unkown", desc: "random")
            waypoint.links = [Link(href: URL(string: "http://cs193p.stanford.edu/Images/HelicopterLanding.jpg")!, type: "large")]
            mapView.addAnnotation(waypoint)
            
            
        }
    }
    private func handleWayPoints(_ wayPoints: [MKAnnotation?]) throws
    {
        guard let wayPointsAnnotations = wayPoints as? [MKAnnotation] else{
            throw AllErrors.castFail("failed to cast from wayPoint to MKAnnotation ")
        }
        
        mapView.addAnnotations( wayPointsAnnotations  )
        mapView.showAnnotations(wayPointsAnnotations , animated: true)
    }
   
    // MARK: - mapView delgate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is WayPoint else{
           
            return nil
        }
        let identifier  = "wayPoint"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil
        {
         
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            //annotationView?.glyphImage = .init(systemName: "mappin.and.ellipse")
            //annotationView?.image = .init(systemName: "note")
            //the mistake is i used MKAnnotation instead of MKPin -currently- MKMarker.
            annotationView?.canShowCallout = true
        }else
        {
            
            annotationView?.annotation = annotation
        }
        /* this is step two to make pin draggable
         this does two things in one, first it sets draggable to true if its only editablewaypoint
         . so it returns a boolean value and make sure that we are draggin editableWayPoint instance
         annotationView?.isDraggable = annotation is EditableWayPoint*/
       
        
        /* you mmust give an inital value (nil or something) before assign in it actual value*/
        annotationView?.leftCalloutAccessoryView = UIButton(frame: .init(x: 0, y: 0, width: 50, height: 50))
        if annotation is EditableWayPoint
        {
            annotationView?.isDraggable = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView?.leftCalloutAccessoryView = nil
        }
        
        
        // downloading in the wrong method
//        downloader.getImageURL(of:Constants.thumbnail){ res in
//            if let image = try? res.get()
//            {
//                
//                DispatchQueue.main.async
//                {
//                    let imageView =
//                    imageView.image = image
//                    
//                }
//
//            }
//        }
        
       return annotationView
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let wayPoint = view.annotation as? WayPoint else
        {
            return
        }
      
        if let thumbnailView = view.leftCalloutAccessoryView as? UIButton //which i did in line 26
        {
            if wayPoint.thumbnailURL != nil
            {
//                DispatchQueue.global(qos: .background).async
//                {
//                    if let data = try? Data(contentsOf: wayPoint.thumbnailURL!) data is not recomended for netwrok request
//                    {
//                        let image = UIImage(data: data)
//                        DispatchQueue.main.async {
//                            thumbnailView.setImage(image, for: .normal)
//                        }
//                        
//                    }
//                }
                URLSession.shared.dataTask(with: .init(url: wayPoint.thumbnailURL!)) {  data, response, error in // recomended for over the internet
                    if error != nil
                    {
                        print(error!)
                    }
                    if let data = data
                    {
                        let image = UIImage(data: data)
                        DispatchQueue.main.async{
                            thumbnailView.setImage(image, for: .normal)
                        }
                    }
                }.resume()
                
               
            }
            
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // now we have two UIButton callout controls, one type is disclosureIndicator adn the other is frame , so we to distinguis
        if (control  as? UIButton)?.buttonType == .detailDisclosure
        {
            /* here above was the problem. after i edited the pin in the popover and i press done, the
             same info was showing that's because it still showing the old data, but if i click on it again
             causing the callout to show again it will show the new data. the deselect method does not update, rather
             it hide the pin data which force to clik the pin and see the new data. */
            mapView.deselectAnnotation(view.annotation, animated: true)
            
            /* if there is only one view controller in a naviagtion controller then just give the storyboard id to the view controller only because modall presentaion will fail if you try to present any view controller that i already in naviagtion stack.*/
            
            if let editVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.viewControllerID) as? EditWayPointViewController
            {
               
                if let wayPoint = view.annotation as? EditableWayPoint
                 {
                    editVC.modalPresentationStyle = .popover
                     editVC.modalTransitionStyle = .coverVertical
                    editVC.popoverPresentationController!.delegate = self
                     if let popover = editVC.popoverPresentationController
                     {
                         // this will onlu run when its an ipad. 
                         let _ = mapView.convert(wayPoint.coordinate, toPointTo: mapView)
                         popover.sourceView = view
                         popover.sourceRect = view.bounds
                         /* for popover you must specifit view and recr or just button */
                         
                         /*
                          it would be cool if we let UIKit help us return the sammlest/largest size possible
                          UIView.layoutFittingExpandedSize -> maximum size avaialbe
                          UIView.layoutFittingCompressedSize -> minimum size avaialbe
                          */
                          let minimumSize = editVC.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                          /*however we want the width to be as much as constatn but the height to be changed  */
                          editVC.preferredContentSize = CGSize(width: 320, height: minimumSize.height)


                     }
                     
                     editVC.wayPointToEdit = wayPoint
                 }
                 present(editVC,animated: true)
            }
         
            //performSegue(withIdentifier: Constants.modalSegue, sender: view)
            // that was the mistake, i send the sender as the mapView then try to cast it as MKAnnotaionView

            
        }
        else if view.annotation is WayPoint
        {
            performSegue(withIdentifier: Constants.segueIdentifier, sender: view) // check the sender
        }
        
    }
    //MARK: - segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier
        {
        case Constants.segueIdentifier:
            if let sender = (sender as? MKAnnotationView)?.annotation as? WayPoint
            {
                if let imageVC = segue.destination as? WaypointImageViewController
                {
                    if sender.largeURL != nil
                    {
                        imageVC.wayPoint = sender
                    }
                }
            }
        //case Constants.modalSegue:
            
            /* it will get pushed regrdless whether you handle it here. it just
             what you want to do when this view is pushed*/
//            if let wayPoint = (sender as? MKAnnotationView)?.annotation as? EditableWayPoint
//            {
//               
//                if let editVC = segue.destination  as? EditWayPointViewController
//                {
//                    // this was the second mistake, navVC.topViewController as? EditWayPointViewController
//                    // presentaion controller can not be embeded iside another controlles
//                    
//                    if let popover = editVC.popoverPresentationController
//                    {
//
//                        popoverPresentationController!.delegate = self
//                        popover.sourceView = (sender as! MKAnnotationView)
//                        popover.sourceRect = (sender as! MKAnnotationView).bounds
//
//                        
//                    }
//                    editVC.wayPointToEdit = wayPoint
//                    // here is a reference
//                    
//                }else
//                {
//                    fatalError("error2")
//                }
//            }else
//            {
//                fatalError("error")
//            }
        default:
            break 
        }
       
    }
    
    // MARK: - PopoverDelegate
    /* after we made the changes to the ipad we lost modal presentaion for iphone
     ( it is not white as before its clear or black, it's overfullscreen similar to alert style , not the presentaion)
     and because we set it in storybaord it is hard to configure it to make its presentaion fullscren. even if its full screen
     it would be black with white views. this behavior happends because of adaptation. iphone does not have popovers so the system
     trys his best to configure the style. to customize the adaptation, we use the UIPopoverPresentationControllerDelegate */
    
    
    //func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
      //  .overFullScreen
       //since the system already choose overFullScreen, i don't have to implement this deleagate mehod
    //}
    /* because it was hard to present modally or as popover with navigation controler embeded in it, and also the background is either
     fully visible or black, we can use this method to add the backbutton ( embed the EditWayPointViewcontroller to its original naviagtion controller
     and add some visual effects on the presentaion controller.
     so basically this is saying give a view controller to display this thing when trying to adapt*/
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        //controller = the controller that adopts the delegate
        /* so this code here says return navigation controller with  view controller that GPXViewController is trying to
         present and embed it in naviagtion controller */
       
        let nav =  UINavigationController(rootViewController: controller.presentedViewController)
        let visualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        visualEffect.frame = nav.view.bounds
        nav.view.insertSubview(visualEffect, at: 0)
        return nav
    }
  
}


/*
 <key>NSAppTransportSecurity</key>
 <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
 </dict>
 this is a key for downloading images
 */

/* if your presentaion VC is alternationg between popover(ipad) and modal(iphone) implement using code and not through story board. */
