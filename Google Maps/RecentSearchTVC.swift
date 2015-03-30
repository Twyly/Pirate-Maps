//
//  RecentSearchTVC.swift
//  Google Maps
//
//  Created by Teddy Wyly on 1/28/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

class RecentSearchTVC: AbstractSearchTVC, RoundedSectionTableViewCellDelegate {
    
    
    //MARK: - PublicAPI
    internal func fetchData() {
        sections = loadSectionData()
        reloadDataWithPossibleAnimation()
    }
    
    var currentCoordinate: Coordinate?
    
    //MARK: - Types
    private enum Section {
        case RecentHistory([Place])
        case ExploreNearby
        case NearbyHistory([Place])
        case Services([Service])
    }
    
    private struct MainStoryboard {
        struct CellIdentifiers {
            static let resultCell = "ResultCell"
            static let sectionHeaderCell = "HeaderCell"
            static let sectionFooterCell = "FooterCell"
        }
    }
    
    private var sections = [Section]()
    
    private func loadSectionData() -> [Section] {
        
        var mySections = [Section]()
        
        let recentlyVisited = Place.recentlyVisitedPlaces()
        if !recentlyVisited.isEmpty {
            mySections.append(Section.RecentHistory(recentlyVisited))
        }
        
        mySections.append(Section.ExploreNearby)
        
        let services = Service.allServices()
        if !services.isEmpty {
            let lastIndex = services.count > 4 ? 3 : services.count
            let truncatedServices = Array(services[0...lastIndex])
            mySections.append(Section.Services(truncatedServices))
        }
        
        if let cord = currentCoordinate {
            let nearby = Place.nearbyAndLocalPlaces(cord)
            if !nearby.isEmpty {
                mySections.append(Section.NearbyHistory(nearby))
            }
        }

        
        return mySections
    }
    
    // Sections
    private var recentHistory: [Place] = [Place]()
    private var services: [Service] = [Service]()
    private var nearbyHistory: [Place] = [Place]()
    
    
    //MARK: - LifeCycle
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    

    //MARK: - UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch (section) {
        case .RecentHistory(let places):
            return places.count+1
        case .ExploreNearby:
            return 1
        case .Services(let services):
            return services.count+1
        case .NearbyHistory(let places):
            return places.count+2
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let section = sections[indexPath.section]
        switch (section) {
            
        case .RecentHistory(let places):
            if indexPath.row < places.count {
                let cell = tableView.dequeueReusableCellWithIdentifier(MainStoryboard.CellIdentifiers.resultCell, forIndexPath: indexPath) as! SearchResultTableViewCell
                let place = places[indexPath.row]
                configureCellForPlace(cell, place: place)
                cell.delegate = self
                cell.prepareShadowsAndCorners(tableView, path: indexPath)
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(MainStoryboard.CellIdentifiers.sectionFooterCell, forIndexPath: indexPath) as! SearchSectionFooterTableViewCell
                configureRecentHistoryFooterCell(cell)
                cell.delegate = self
                cell.prepareShadowsAndCorners(tableView, path: indexPath)
                return cell
            }
        case .ExploreNearby:
            let cell = tableView.dequeueReusableCellWithIdentifier(MainStoryboard.CellIdentifiers.resultCell, forIndexPath: indexPath) as! SearchResultTableViewCell
            configureExploreNearbyCell(cell)
            cell.delegate = self
            cell.prepareShadowsAndCorners(tableView, path: indexPath)
            return cell
        case .Services(let services):
            if indexPath.row < services.count {
                let cell = tableView.dequeueReusableCellWithIdentifier(MainStoryboard.CellIdentifiers.resultCell, forIndexPath: indexPath) as! SearchResultTableViewCell
                let service = services[indexPath.row]
                configureCellForService(cell, service: service)
                cell.delegate = self
                cell.prepareShadowsAndCorners(tableView, path: indexPath)
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(MainStoryboard.CellIdentifiers.sectionFooterCell, forIndexPath: indexPath) as! SearchSectionFooterTableViewCell
                configureServiceFooterCell(cell)
                cell.delegate = self
                cell.prepareShadowsAndCorners(tableView, path: indexPath)
                return cell
            }
        case .NearbyHistory(let places):
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(MainStoryboard.CellIdentifiers.sectionHeaderCell, forIndexPath: indexPath) as! SearchSectionHeaderTableViewCell
                configureNearbyHistoryHeaderCell(cell)
                cell.delegate = self
                cell.prepareShadowsAndCorners(tableView, path: indexPath)
                return cell
            } else if indexPath.row <= places.count {
                let cell = tableView.dequeueReusableCellWithIdentifier(MainStoryboard.CellIdentifiers.resultCell, forIndexPath: indexPath) as! SearchResultTableViewCell
                let place = places[indexPath.row-1]
                configureCellForPlace(cell, place: place)
                cell.delegate = self
                cell.prepareShadowsAndCorners(tableView, path: indexPath)
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(MainStoryboard.CellIdentifiers.sectionFooterCell, forIndexPath: indexPath) as! SearchSectionFooterTableViewCell
                configureNearbyHistoryFooterCell(cell)
                cell.delegate = self
                cell.prepareShadowsAndCorners(tableView, path: indexPath)
                return cell
            }
        }

    }
    
    // Recent History
    private func configureCellForPlace(cell: SearchResultTableViewCell, place: Place) {
        cell.majorLabel.text = place.name
        cell.minorLabel.text = place.vicinity
        cell.iconImageView.image = UIImage(named: "anchor.png")
    }
    
    private func configureRecentHistoryFooterCell(cell: SearchSectionFooterTableViewCell) {
        cell.majorLabel.text = "MORE FROM RECENT HISTORY"
    }
    
    // Explore Nearby
    private func configureExploreNearbyCell(cell: SearchResultTableViewCell) {
        cell.majorLabel.text = "Explore nearby"
        cell.minorLabel.text = nil
        cell.iconImageView.image = UIImage(named: "compass.png")
    }
    
    // Services
    private func configureCellForService(cell: SearchResultTableViewCell, service: Service) {
        cell.majorLabel.text = service.name
        cell.minorLabel.text = nil
        cell.iconImageView.image = UIImage(named: "fish.png")
    }
    
    private func configureServiceFooterCell(cell: SearchSectionFooterTableViewCell) {
        cell.majorLabel.text = "MORE"
    }
    
    // Nearby History
    private func configureNearbyHistoryHeaderCell(cell: SearchSectionHeaderTableViewCell) {
        cell.majorLabel.text = "Nearby from your history"
    }
    
    private func configureNearbyHistoryFooterCell(cell: SearchSectionFooterTableViewCell) {
        cell.majorLabel.text = "MORE FROM YOUR HISTORY"
    }
    
    
    //MARK: - RoundedSectionTableViewCellDelegate
    func touchUpRecognizedOnCell(view: RoundedSectionShadowTableViewCell) {
        if let path = tableView.indexPathForCell(view) {
            let section = sections[path.section]
            switch (section) {
            case .RecentHistory(let places):
                if path.row < places.count {
                    let place = places[path.row]
                    place.saveToRecentHistory()
                    self.delegate?.searchTVCDidSelectPlace(self, place: place)
                } else {
                    // Push More From Recent History
                }
            case .ExploreNearby:
                print("")
                // Push Explore Nearby
            case .Services(let services):
                if path.row < services.count {
                    let service = services[path.row]
                    self.delegate?.searchTVCDidSelectService(self, service: service)
                } else {
                    // Push Show All Services
                }
            case .NearbyHistory(let places):
                if path.row == 0 {
                    // Nothing
                } else if path.row <= places.count {
                    let place = places[path.row-1]
                    place.saveToRecentHistory()
                    self.delegate?.searchTVCDidSelectPlace(self, place: place)
                } else if path.row == places.count {
                    // Push More From Your History
                }
            }
        }
    }
}
