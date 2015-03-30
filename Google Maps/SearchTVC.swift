//
//  SearchTVC.swift
//  Google Maps
//
//  Created by Teddy Wyly on 1/22/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit


class SearchTVC: AbstractSearchTVC, RoundedSectionTableViewCellDelegate {
    
    //MARK: - Public API
    internal var suggestion: Place?

    internal func fetchPlaces(text: String, coordinate: Coordinate) {
        Place.fetchNearbyPlaces(text, coordinate: coordinate, completion: { [weak self] places, failReason in
            println("Places are \(places)")
            if !places.isEmpty {
                let lastIndex = places.count > 10 ? 9 : places.count-1
                self?.places = Array(places[0...lastIndex])
                self?.reloadDataWithPossibleAnimation()
            } else {
                self?.places = [Place]()
                self?.reloadDataWithPossibleAnimation()
            }
        })
    }
    
    //MARK: - Types
    private struct MainStoryboard {
        struct CellIdentifiers {
            static let searchCell = "SearchCell"
        }
    }
    
    private struct TableViewData {
        static let tangibleResults = "tangibleResults"
        static let suggestionResult = "suggestionResult"
    }
    
    //MARK: - Properties
    private var places = [Place]()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTestLabels()
    }
    
    //Mark: - Tests
    func setupTestLabels() {
        tableView.isAccessibilityElement = true
        tableView.accessibilityIdentifier = "Search Table View"
    }

    // MARK: - UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sug = suggestion {
            return 2
        } else {
            return 1
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sug = suggestion {
            if section == 0 {
                return 2
            } else {
                return places.count
            }
        } else {
            return places.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MainStoryboard.CellIdentifiers.searchCell, forIndexPath: indexPath) as! SearchResultTableViewCell
        configureCell(cell, path: indexPath)
        return cell
    }
    
    private func configureCell(cell: SearchResultTableViewCell, path: NSIndexPath) {
        
        cell.prepareShadowsAndCorners(tableView, path: path)
        cell.delegate = self
        if let sug = suggestion {
            if path.section == 0 {
                
            } else {
                let place = places[path.row]
                cell.iconImageView.image = UIImage(named: "compass.png")
                cell.majorLabel.text = place.name
                cell.minorLabel.text = nil
            }
        } else {
            let place = places[path.row]
            cell.iconImageView.image = UIImage(named: "compass.png")
            cell.majorLabel.text = place.name
            cell.minorLabel.text = nil
        }
    }
    
    //MARK: - RoundedSectionTableViewCellDelegate
    func touchUpRecognizedOnCell(view: RoundedSectionShadowTableViewCell) {
        if let path = tableView.indexPathForCell(view) {
            if let sug = suggestion {
                if path.section == 0 {
                    
                } else {
                    let place = places[path.row]
                    place.saveToRecentHistory()
                    self.delegate?.searchTVCDidSelectPlace(self, place: place)
                }
            } else {
                let place = places[path.row]
                place.saveToRecentHistory()
                self.delegate?.searchTVCDidSelectPlace(self, place: place)
            }
        }
    }
    
    
    
}
