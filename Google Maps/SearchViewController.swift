//
//  SearchViewController.swift
//  Google Maps
//
//  Created by Teddy Wyly on 1/22/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

protocol SearchViewControllerDelegate: class {
    func searchViewControllerDidSelectPlace(controller: SearchViewController, place: Place)
    func searchViewControllerDidSelectService(controller: SearchViewController, service: Service)
}

class SearchViewController: UIViewController, AbstractSearchTVCDelegate, UITextFieldDelegate, UIViewControllerTransitioningDelegate {
    
    //MARK: - PublicAPI
    var currentCoordinate: Coordinate?
    weak var delegate: SearchViewControllerDelegate?

    
    //MARK: - Types
    private struct MainStoryboard {
        struct SegueIdentifiers {
            static let embedSearchTVC = "embedSearchTVC"
            static let embedRecentSearchTVC = "embedRecentSearchTVC"
            static let seeVoice = "seeVoice"

        }
    }

    //MARK: - Properties
    private var recentSearchTVC: RecentSearchTVC?
    private var searchTVC: SearchTVC?
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var mapSearchView: MapSearchView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var rightVoiceButton: UIButton!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        searchContainerView.hidden = true
        textField.becomeFirstResponder()
        mapSearchView.excludeEdges = .None
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        initialAnimatedFetchWithChild()
    }
    
    private func initialAnimatedFetchWithChild() {
        if textField.text.isEmpty {
            searchTVC?.firstFetchPerformed = true
            recentSearchTVC?.fetchData()
        } else {
            if let cord = currentCoordinate {
                recentSearchTVC?.firstFetchPerformed = true
                searchTVC?.fetchPlaces(textField.text, coordinate: cord)
            }
        }
        mapSearchView.excludeEdges = .Bottom
    }
    
    
    //MARK: - IBActions
    @IBAction func backButtonPressed(sender: UIButton) {
        animatedDismissal(completion: nil)
    }
    
    func animatedDismissal(completion: (() -> ())? = nil) {
        textField.resignFirstResponder()
        mapSearchView.excludeEdges = .None
        if textField.text.isEmpty {
            recentSearchTVC?.withdrawVisableCells({ () -> () in
                self.dismissViewControllerAnimated(true, completion: completion)
            })
        } else {
            searchTVC?.withdrawVisableCells({ () -> () in
                self.dismissViewControllerAnimated(true, completion: completion)
            })
        }
        
    }

    @IBAction func rightButtonPressed(sender: UIButton) {
        performSegueWithIdentifier(MainStoryboard.SegueIdentifiers.seeVoice, sender: nil)
        //searchTVC?.fetch()
    }
    
    //MARK: - UITextFieldDelegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        searchContainerView.hidden = newString.isEmpty
        if !newString.isEmpty {
            if let cord = currentCoordinate {
                searchTVC?.fetchPlaces(newString, coordinate: cord)
            }
        }
        return true
    }
    
    //MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == MainStoryboard.SegueIdentifiers.embedSearchTVC {
            let targetVC = segue.destinationViewController as! SearchTVC
            targetVC.delegate = self
            searchTVC = targetVC
        } else if segue.identifier == MainStoryboard.SegueIdentifiers.embedRecentSearchTVC {
            let targetVC = segue.destinationViewController as! RecentSearchTVC
            targetVC.currentCoordinate = currentCoordinate
            targetVC.delegate = self
            recentSearchTVC = targetVC
        } else if segue.identifier == MainStoryboard.SegueIdentifiers.seeVoice {
            let targetVC = segue.destinationViewController as! VoiceViewController
            targetVC.transitioningDelegate = self
        }
    }
    
    //MARK: - AbstractSearchTVCDelegate
    func searchTVCDidScroll(controller: AbstractSearchTVC, scrollView: UIScrollView) {
        textField.resignFirstResponder()
        adjustSearchViewShadow(scrollView.contentOffset.y)
    }
    
    func adjustSearchViewShadow(offSet: CGFloat) {
        if offSet == -1 {
            mapSearchView.excludeEdges = .Bottom
        } else {
            mapSearchView.excludeEdges = .None
        }
    }
    
    func searchTVCDidSelectPlace(controller: AbstractSearchTVC, place: Place) {
        delegate?.searchViewControllerDidSelectPlace(self, place: place)
    }
    
    func searchTVCDidSelectService(controller: AbstractSearchTVC, service: Service) {
        delegate?.searchViewControllerDidSelectService(self, service: service)
    }
    
    func searchTVCFinishedAnimatedCellDispaly(controller: AbstractSearchTVC) {
        //
    }
    
    //MARK: - UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let targetVC = presented as? VoiceViewController {
            return VoiceAnimator(presentFromRect: rightVoiceButton.frame)
        } else {
            return nil
        }
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let targetVC = dismissed as? VoiceViewController {
            return VoiceAnimator(presenting: false)
        } else {
            return nil
        }
    }

    //MARK: - Status Bar
    override func prefersStatusBarHidden() -> Bool {
        return false
    }

}
