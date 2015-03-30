//
//  MapViewController.swift
//  Google Maps
//
//  Created by Teddy Wyly on 1/6/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, SearchViewControllerDelegate, UIViewControllerTransitioningDelegate, SideMenuViewControllerDelegate, BubbleTouchViewDelegate {
    
    //MARK: - Types
    struct MainStoryboard {
        struct ViewControllerIdentifiers {
            //static let sideMenuController = "sideMenuController"
        }
        
        struct SegueIdentifiers {
            static let seeMenu = "seeMenu"
            static let seeVoice = "seeVoice"
            static let seeSearch = "seeSearch"
            static let getDirections = "getDirections"
        }
    }
    
    enum OrientationMode {
        case Unoriented
        case CenteredOnLocation
        case TrackPerspective
    }
    
    
    //MARK: - Properties
    @IBOutlet weak var leftSearchButton: UIButton!
    @IBOutlet weak var rightSearchButton: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var mapSearchView: MapSearchView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var orientationButtonView: CircularShadowButtonView!
    @IBOutlet weak var directionsButtonView: CircularShadowButtonView!
    @IBOutlet weak var zoomDistanceView: MapZoomDistanceView!
    
    var orientationMode: OrientationMode = .Unoriented
    var sideMenuInteractiveAnimator: SideMenuAnimator?
    let locationManager = CLLocationManager()
    var currentCoordinate: Coordinate?

    
    //MARK: - ViewControllerLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView.stopAnimating()

        orientationButtonView.addTarget(self, action: "orientationButtonPressed:", forControlEvents: .TouchUpInside)
        orientationButtonView.button.setImage(UIImage(named: "wheel.png"), forState: .Normal)
        orientationButtonView.backgroundColor = UIColor.whiteColor()
        orientationButtonView.button.imageEdgeInsets = UIEdgeInsetsMake(9, 9, 9, 9)
        directionsButtonView.addTarget(self, action: "directionsButtonPressed:", forControlEvents: .TouchUpInside)
        directionsButtonView.button.setImage(UIImage(named: "white_map.png"), forState: .Normal)
        directionsButtonView.backgroundColor = UIColor.applicationColor()
        directionsButtonView.button.imageEdgeInsets = UIEdgeInsetsMake(14, 14, 14, 14)
        
        mapSearchView.bubbleView?.delegate = self
        
        let screenEdgeRecognizer  = UIScreenEdgePanGestureRecognizer(target: self, action: "leftEdgePanRecognized:")
        screenEdgeRecognizer.edges = .Left
        view.addGestureRecognizer(screenEdgeRecognizer)
        
        var camera = GMSCameraPosition.cameraWithLatitude(-33.86,
            longitude: 151.20, zoom: 6)
        mapView.myLocationEnabled = true
        mapView.delegate = self
        mapView.settings.compassButton = true
        mapView.padding = UIEdgeInsetsMake(mapSearchView.frame.origin.y + mapSearchView.frame.size.height,0,0,0)
        
        var marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
    }
        
    //MARK: - IBActions
    func orientationButtonPressed(sender: UIButton) {
        
        switch orientationMode {
        case .Unoriented:
            orientationMode = .CenteredOnLocation
            orientationButtonView.button.setImage(UIImage(named: "blue_wheel.png"), forState: .Normal)
        case .CenteredOnLocation:
            orientationMode = .TrackPerspective
            orientationButtonView.button.setImage(UIImage(named: "blue_compass.png"), forState: .Normal)
        case .TrackPerspective:
            orientationMode = .Unoriented
            orientationButtonView.button.setImage(UIImage(named: "wheel.png"), forState: .Normal)
        }
        
        if let cord = currentCoordinate {
            CATransaction.setValue(1, forKey: kCATransactionAnimationDuration)
            mapView.animateToLocation(CLLocationCoordinate2D(latitude: cord.latitude, longitude: cord.longitude))
        }
        
    }
    func directionsButtonPressed(sender: UIButton) {
        performSegueWithIdentifier(MainStoryboard.SegueIdentifiers.getDirections, sender: nil)
    }
    
    @IBAction func leftSearchButtonPressed(sender: UIButton) {
        performSegueWithIdentifier(MainStoryboard.SegueIdentifiers.seeMenu, sender: nil)
    }
    
    @IBAction func rightSearchButtonPressed(sender: UIButton) {
        performSegueWithIdentifier(MainStoryboard.SegueIdentifiers.seeVoice, sender: nil)
    }
    
    @IBAction func unwindToViewController(sender: UIStoryboardSegue){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func leftEdgePanRecognized(sender: UIScreenEdgePanGestureRecognizer){
        
        let location = sender.locationInView(view)
        let velocity = sender.velocityInView(view)

        if (sender.state == .Began) {
            
            self.sideMenuInteractiveAnimator = SideMenuAnimator(presenting: true)
            performSegueWithIdentifier(MainStoryboard.SegueIdentifiers.seeMenu, sender: nil)
            
        } else if (sender.state == .Changed) {
            
            let ratio: CGFloat = location.x / CGRectGetWidth(view.bounds)
            self.sideMenuInteractiveAnimator?.updateInteractiveTransition(ratio)
            
        } else if (sender.state == .Ended) {
            if velocity.x > 0 {
                self.sideMenuInteractiveAnimator?.finishInteractiveTransition()
            } else {
                self.sideMenuInteractiveAnimator?.cancelInteractiveTransition()
            }
            sideMenuInteractiveAnimator = nil
        } else if (sender.state == .Cancelled) {
            sideMenuInteractiveAnimator = nil
        }
    }
    
    //MARK: - GMSMapViewDelegate
    var initialZoom: Float?
    
    func mapView(mapView: GMSMapView!, willMove gesture: Bool) {
        initialZoom = mapView.camera.zoom
    }
    
    func mapView(mapView: GMSMapView!, didChangeCameraPosition position: GMSCameraPosition!) {
        if let iZoom = initialZoom {
            let delta: Float = 0.2
            if abs(mapView.camera.zoom - iZoom)  > delta {
                let metersPerPoint = metersPerPointForZoom(mapView.camera.zoom, coordinate: position.target, start:1, end:2000000)
                self.zoomDistanceView.metersPerPoint = metersPerPoint
                let cord = mapView.camera.target
            }
        }
    }
    
    //Between 0 and 2,000,000 // Binary search - under 20 operations
    func metersPerPointForZoom(zoom: Float, coordinate: CLLocationCoordinate2D, start:Double, end: Double) -> Double {
        var meterEstimate: Double = (start+end)/2
        let testZoom = GMSCameraPosition.zoomAtCoordinate(coordinate, forMeters: meterEstimate, perPoints: 1)
        if abs(testZoom-zoom) < 1 {
            return meterEstimate
        } else if testZoom > zoom {
            return metersPerPointForZoom(zoom, coordinate: coordinate, start: meterEstimate+1, end: end)
        } else {
            return metersPerPointForZoom(zoom, coordinate: coordinate, start: start, end: meterEstimate-1)
        }
    }
    
    func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
        initialZoom = nil
    }
    
    
    //MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            currentCoordinate = Coordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            //mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
        
    
    //MARK: - SideMenuViewControllerDelegate
    func dismissSideMenuController(controller: SideMenuViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    var panTranslation: CGFloat = 0
    
    func panRecognized(controller: SideMenuViewController, sender: UIPanGestureRecognizer) {
        
        let location = sender.locationInView(view)
        let velocity = sender.velocityInView(view)
        let translation = sender.translationInView(view)
        
        if (sender.state == .Began) {
            
            self.sideMenuInteractiveAnimator = SideMenuAnimator(presenting: false)
            dismissViewControllerAnimated(true, completion: nil)
            
        } else if (sender.state == .Changed) {
            
            // Only update positive pan if location is within panelWidth
            let targetPanTranslation = panTranslation + translation.x
            let ratio: CGFloat = -targetPanTranslation / controller.panelWidth
            if (0...1 ~= ratio) {
                panTranslation = targetPanTranslation
                self.sideMenuInteractiveAnimator?.updateInteractiveTransition(ratio)
            }
            sender.setTranslation(CGPointZero, inView: view)
            
        } else if (sender.state == .Ended) {
            if velocity.x < 0 {
                self.sideMenuInteractiveAnimator?.finishInteractiveTransition()
            } else {
                self.sideMenuInteractiveAnimator?.cancelInteractiveTransition()
            }
            sideMenuInteractiveAnimator = nil
            panTranslation = 0
        } else if (sender.state == .Cancelled) {
            sideMenuInteractiveAnimator = nil
            panTranslation = 0
        }
    }
    
    //MARK: - SearchViewControllerDelegate
    
    func searchViewControllerDidSelectPlace(controller: SearchViewController, place: Place) {
                
        controller.animatedDismissal { [weak self] () -> () in
            self?.loadingView.startAnimating()
            let delayInSeconds = 10.0
            let startTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
            dispatch_after(startTime, dispatch_get_main_queue()) {
                print("")
                self?.loadingView.stopAnimating()
            }
        }
    }
    
    func searchViewControllerDidSelectService(controller: SearchViewController, service: Service) {
        controller.animatedDismissal { [weak self] () -> () in
            self?.loadingView.startAnimating()
            let delayInSeconds = 10.0
            let startTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
            dispatch_after(startTime, dispatch_get_main_queue()) {
                print("")
                self?.loadingView.stopAnimating()
            }
        }
    }
    
    
    //MARK: - BubbleTouchViewDelegate
    func touchUpRecognizedOnBubbleView(view: BubbleTouchView) {
        performSegueWithIdentifier(MainStoryboard.SegueIdentifiers.seeSearch, sender: nil)
    }
    
    
    //MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == MainStoryboard.SegueIdentifiers.seeMenu {
            let targetVC = segue.destinationViewController as! SideMenuViewController
            targetVC.transitioningDelegate = self
            targetVC.delegate = self
            targetVC.modalPresentationCapturesStatusBarAppearance = true
        } else if segue.identifier == MainStoryboard.SegueIdentifiers.seeVoice {
            let targetVC = segue.destinationViewController as! VoiceViewController
            targetVC.transitioningDelegate = self
        } else if segue.identifier == MainStoryboard.SegueIdentifiers.seeSearch {
            let targetVC = segue.destinationViewController as! SearchViewController
            targetVC.delegate = self
            targetVC.currentCoordinate = currentCoordinate
            targetVC.transitioningDelegate = self
        } else if segue.identifier == MainStoryboard.SegueIdentifiers.getDirections {
            let targetVC = segue.destinationViewController as! DirectionsViewController
            targetVC.transitioningDelegate = self
            targetVC.modalPresentationCapturesStatusBarAppearance = true
        }
    }
    
    //MARK: - UIViewControllerTransitioningDelegate
    
    // Using Introspection here - if we can transition to multiple viewcontrollers of the same class, than we would need to check the presented viewcontroller explicitly
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let targetVC = presented as? SideMenuViewController {
            return SideMenuAnimator(presenting: true)
        } else if let targetVC = presented as? VoiceViewController {
            return VoiceAnimator(presentFromRect: rightSearchButton.frame)
        } else if let targetVC = presented as? SearchViewController {
            return CrossFadeAnimator(presenting: true)
        } else if let targetVC = presented as? DirectionsViewController {
            return CoverVerticalAnimator(presenting: true)
        } else {
            return nil
        }
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let targetVC = dismissed as? SideMenuViewController {
            return SideMenuAnimator(presenting: false)
        } else if let targetVC = dismissed as? VoiceViewController {
            return VoiceAnimator(presenting: false)
        } else if let targetVC = dismissed as? SearchViewController {
            return CrossFadeAnimator(presenting: false)
        } else if let targetVC = dismissed as? DirectionsViewController {
            return CoverVerticalAnimator(presenting: false)
        } else {
            return nil
        }
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return sideMenuInteractiveAnimator
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return sideMenuInteractiveAnimator
    }
    
    //MARK: - Status Bar
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    

}
