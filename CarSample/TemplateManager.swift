//
//  TemplateManager.swift
//  CarSample
//
//  Created by MAC240 on 20/10/21.
//

import Foundation
import CarPlay
import os

class TemplateManager: NSObject {
    
    static let shared = TemplateManager()
    let viewController = ViewController()
    
    let mapViewcontroller = MKMapViewController()
    
    private var carplayInterefaceController: CPInterfaceController?
    private var carWindow: UIWindow?
    var sessionConfiguration: CPSessionConfiguration!

	private var carplayScene: CPTemplateApplicationScene?
	private let locationManager = CLLocationManager()
	var boundingRegion: MKCoordinateRegion = MKCoordinateRegion(.world)
	
	var currentLocationAuthorizationStatus: CLAuthorizationStatus?

    override init() {
        super.init()
     
    }

	func interfaceController(_ interfaceController: CPInterfaceController, didConnectWith window: CPWindow? = nil, scene: CPTemplateApplicationScene? = nil) {
		self.carplayInterefaceController = interfaceController
		self.carWindow = window
		self.carplayScene = scene ?? window?.templateApplicationScene
		self.carplayInterefaceController?.delegate = self
		self.sessionConfiguration = CPSessionConfiguration(delegate: self)
		self.locationManager.delegate = self
		self.requestLocation()
		self.setupTabbar()//self.setupMap()
    }

    func interfaceController(_ interfaceController: CPInterfaceController, didDisconnectWith window: CPWindow) {
		self.carplayInterefaceController = nil
		self.carWindow?.isHidden = true
    }
    
	private func requestLocation() {
		self.currentLocationAuthorizationStatus = self.locationManager.authorizationStatus
		
		guard CLLocationManager.locationServicesEnabled() else {
			print("Please enable location services.")
			return
		}
		if self.locationManager.authorizationStatus == .authorizedWhenInUse ||
			self.locationManager.authorizationStatus == .authorizedAlways {
			self.locationManager.startUpdatingLocation()
		} else {
			self.locationManager.requestWhenInUseAuthorization()
		}
	}
	
	func setupTabbar() {
		var tabTemplates = [CPTemplate]()
		tabTemplates.append(getPointOfInterestTemplate())
		tabTemplates.append(getFilterTemplate())
		tabTemplates.append(getChargerTemplate())
		tabTemplates.append(getFavouriteTemplate())
		self.carplayInterefaceController?.setRootTemplate(CPTabBarTemplate(templates: tabTemplates), animated: true, completion: nil)
	}
    
	private func getDirection(place: CPPointOfInterest) {
		// Try directions or a phone number as the secondary button.
		if let address = place.summary,
		   let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics),
		   let lon = place.location.placemark.location?.coordinate.longitude,
		   let lat = place.location.placemark.location?.coordinate.latitude,
		   let url = URL(string: "maps://?q=\(encodedAddress)&ll=\(lon),\(lat)") {
//			place.secondaryButton = CPTextButton(title: "Directions", textStyle: .normal, handler: { (button) in
				print("Opening Maps with \(address).")
				self.carplayScene?.open(url, options: nil, completionHandler: nil)
//			})
		} else if let phoneNumber = place.subtitle, let url = URL(string: "tel://" + phoneNumber.replacingOccurrences(of: " ", with: "")) {
//			place.secondaryButton = CPTextButton(title: "Call", textStyle: .normal, handler: { (button) in
				print("Calling \(phoneNumber).")
				self.carplayScene?.open(url, options: nil, completionHandler: nil)
//			})
		}
	}
}

// MARK: - Display templates and alerts
extension TemplateManager {
	func showGridTemplate() {
		let gridTemp = CPGridTemplate.favouriteGridTemplate(compatibleWith: viewController.traitCollection) { [weak self] (btn) in
			guard let self = self else { return }
			self.showListTemplate(title: btn.titleVariants.first ?? "Favorites")
		}
		self.carplayInterefaceController?.pushTemplate(gridTemp, animated: true) { (_, _) in }
	}

	func showListTemplate(title: String) {
		let listTemplate = CPListTemplate.searchResultsListTemplate(compatibleWith: viewController.traitCollection, title: title, interfaceController: carplayInterefaceController)
		self.carplayInterefaceController?.pushTemplate(listTemplate, animated: true) { (_, _) in }
	}
	
	func dismissAlertAndPopToRootTemplate(completion: (() -> Void)? = nil) {
		carplayInterefaceController?.dismissTemplate(animated: true, completion: { [weak self] (done, error) in
			guard let self = self else { return }
			if self.handleError(error, prependedMessage: "Error dismissing alert") == false {
				self.carplayInterefaceController?.popToRootTemplate(animated: true) { (done, error) in
					self.handleError(error, prependedMessage: "Error popping to root template")
					if let completion = completion {
						completion()
					}
				}
			}
		})
	}
	
	@discardableResult
	func handleError(_ error: Error?, prependedMessage: String) -> Bool {
		if let error = error {
			print("\(prependedMessage): \(error.localizedDescription).")
		}
		return error != nil
	}
}

// MARK: - CPMapTemplate creation
extension TemplateManager {
	// MARK: - Map CPPointOfInterestTemplate creation
	private func getPointOfInterestTemplate() -> CPPointOfInterestTemplate {
		let mapitem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 23.030357, longitude: 72.517845), postalAddress: TheBridge()))
		mapitem.name = "San Francisco"
		let mapitem1 = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 21.764473, longitude: 72.151932), postalAddress: CityHall()))
		mapitem1.name = "CP QA UK IES OCPP TEST"
		
		let poi = CPPointOfInterest(location: mapitem, title: "Cove Road", subtitle: "5003.9 mi away", summary: "", detailTitle: "Cove Road", detailSubtitle: "San Francisco", detailSummary: "Available $4" , pinImage: UIImage(named: "charging-station"))
		
		let button = CPTextButton(title: "Details", textStyle: .normal, handler: { (button) in
			self.showDetailTemplate()
		})
		poi.primaryButton = button
		
//        poi.primaryButton?.title = "Details"
//        poi.secondaryButton?.title = "Detail"
		let poi1 = CPPointOfInterest(location: mapitem1, title: "CP QA UK IES OCPP TEST", subtitle: "5022.83 mi away", summary: "", detailTitle: "", detailSubtitle: "", detailSummary: "", pinImage: UIImage(named: "charging-station"))
		let mapTemplate = CPPointOfInterestTemplate(title: "EV Stations", pointsOfInterest: [poi, poi1], selectedIndex: NSNotFound)
   
		mapTemplate.tabTitle = "Map"
		mapTemplate.tabImage = UIImage(systemName: "map")
		mapTemplate.pointOfInterestDelegate = self
	
		return mapTemplate
	}
   
	// MARK: - Detail CPInformationItem creation
	func showDetailTemplate() {
		let cpinfo = CPInformationItem(title: "Starbucks cove Road Services, Hampsire", detail: "GU51 2SH")
		let cpinfo1 = CPInformationItem(title: "Cost", detail: "$0.4/kwh (Parking Charges may apply)")
		
		let chargeButton = CPTextButton(title: "Start Charge", textStyle: .confirm) { (btn) in
			print("start charging")
		}
		
		let stopchargeButton = CPTextButton(title: "Stop Charge", textStyle: .cancel) { (btn) in
			print("stop charging")
			let mapitem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 23.030357, longitude: 72.517845)))
			let poi = CPPointOfInterest(location: mapitem, title: "Cove Road", subtitle: "5003.9 mi away", summary: "", detailTitle: "Cove Road", detailSubtitle: "San Francisco", detailSummary: "Available $4" , pinImage: UIImage(named: "charging-station"))
			self.getDirection(place: poi)
		}
	  
		let detailTemplate = CPInformationTemplate(title: "Cove Road", layout: .twoColumn, items: [cpinfo,cpinfo1], actions: [chargeButton,stopchargeButton])
		carplayInterefaceController?.pushTemplate(detailTemplate, animated: true) { (_, _) in }
	}
	
	// MARK: - Filter CPGridTemplate creation
	private func getFilterTemplate() -> CPGridTemplate {
		let gridTemp = CPGridTemplate.favouriteGridTemplate(compatibleWith: viewController.traitCollection) { (btn) in
			self.showListTemplate(title: btn.titleVariants.first ?? "Favorites")
		}
		carplayInterefaceController?.pushTemplate(gridTemp, animated: true) { (_, _) in }
		let cpinfo = CPInformationItem(title: "Distance", detail: "Less than 10 miles")
			   let cpinfo1 = CPInformationItem(title: "Status", detail: "Availale")
			   let cpinfo2 = CPInformationItem(title: "Current Type", detail: "DC")
			   let cpinfo3 = CPInformationItem(title: "Networks", detail: "Instvolt")
			   let template = CPInformationTemplate(title: "", layout: .twoColumn, items: [cpinfo,cpinfo1,cpinfo2,cpinfo3], actions: [])
		gridTemp.tabTitle = "Filters"
		gridTemp.tabImage = UIImage(systemName: "line.horizontal.3.decrease.circle")
		return gridTemp
	}
	
	// MARK: - Charger CPListTemplate creation
	private func getChargerTemplate() -> CPListTemplate {
		let reggae = CPListItem(text: "COVE ROAD", detailText: "5358.44 mi away")
		
		reggae.handler = { item, completion in
			self.showDetailTemplate()
		}
		
		let jazz = CPListItem(text: "KEITH", detailText: "8.02 mi away")
		let alternative = CPListItem(text: "CASTLEBAY", detailText: "4993.53 mi away")
		let hipHop = CPListItem(text: "ARKLESTON", detailText: "5022.83 mi away")
		let songCharts = CPListItem(text: "UNIVERSE", detailText: "5033.18 mi away")
	  
//        songCharts.handler = { item, completion in
//            AppleMusicAPIController.sharedController.searchSongCharts(completion: { items in
//                if let items = items {
//                    MemoryLogger.shared.appendEvent("Chart count \(items.count).")
//                    if items.count > 1 {
//                        self.createListFromCharts(charts: items)
//                    } else if let firstSet = items.first?.data {
//                        self.currentQueue = firstSet
//                        AppleMusicAPIController.playWithItems(items: firstSet.compactMap({ (song) -> String in
//                            return song.identifier
//                        }))
//                    }
//                } else {
//                    MemoryLogger.shared.appendEvent("Song count 0.")
//                }
//                completion()
//            })
//        }
		let template = CPListTemplate(title: "Charger", sections: [CPListSection(items: [reggae, jazz, alternative, hipHop, songCharts])])
		template.tabImage = UIImage(systemName: "bolt.fill.batteryblock")
		return template
	}
	
	// MARK: - Favourite CPListTemplate creation
	private func getFavouriteTemplate() -> CPListTemplate {
//        let reggae = CPListItem(text: "Reggae", detailText: "Relax and feel good.")
//        let jazz = CPListItem(text: "Jazz", detailText: "How about some smooth jazz.")
//        let alternative = CPListItem(text: "Alternative", detailText: "Catch a vibe.")
//        let hipHop = CPListItem(text: "Hip-Hop", detailText: "Play the latest jams.")
		let jazz = CPListItem(text: "KEITH", detailText: "8.02 mi away")
		
		jazz.handler = { item, completion in
			self.showDetailTemplate()
		}
		
		let alternative = CPListItem(text: "CASTLEBAY", detailText: "4993.53 mi away")
		
//        let songCharts = CPListItem(text: "Check the Top Song Charts", detailText: "See what's trending.")
//        songCharts.setImage(UIImage(systemName: "chart.bar.fill")!)
//        songCharts.handler = { item, completion in
//            AppleMusicAPIController.sharedController.searchSongCharts(completion: { items in
//                if let items = items {
//                    MemoryLogger.shared.appendEvent("Chart count \(items.count).")
//                    if items.count > 1 {
//                        self.createListFromCharts(charts: items)
//                    } else if let firstSet = items.first?.data {
//                        self.currentQueue = firstSet
//                        AppleMusicAPIController.playWithItems(items: firstSet.compactMap({ (song) -> String in
//                            return song.identifier
//                        }))
//                    }
//                } else {
//                    MemoryLogger.shared.appendEvent("Song count 0.")
//                }
//                completion()
//            })
//        }
		let template = CPListTemplate(title: "Favourites", sections: [CPListSection(items: [jazz, alternative])])
		template.tabImage = UIImage(systemName: "heart")
		return template
	}
}

extension TemplateManager: CPInterfaceControllerDelegate, CPSessionConfigurationDelegate {
	
}

extension TemplateManager: CPPointOfInterestTemplateDelegate {
	func pointOfInterestTemplate(_ pointOfInterestTemplate: CPPointOfInterestTemplate, didChangeMapRegion region: MKCoordinateRegion) {
		print("printed")
	}
	
	func pointOfInterestTemplate(_ pointOfInterestTemplate: CPPointOfInterestTemplate, didSelectPointOfInterest pointOfInterest: CPPointOfInterest) {
		print("Point of interest \(pointOfInterest.title)")
//        showDetailTemplate()
	}
}

extension TemplateManager: CLLocationManagerDelegate {
	/// - Tag: location
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		switch manager.authorizationStatus {
		case .denied, .restricted, .notDetermined:
			let alert = CPAlertTemplate(titleVariants: ["Please enable location services."], actions: [
				CPAlertAction(title: "Ok", style: .default, handler: { [weak self] (action) in
					guard let self = self else { return }
					self.carplayInterefaceController?.setRootTemplate(
						CPTabBarTemplate(templates: []), animated: false, completion: { (done, error) in
							print("Error setting root template.")
						}
					)
				})
			])
			// Check for a presented template and dismiss it for this important message.
			if self.carplayInterefaceController?.presentedTemplate != nil {
				dismissAlertAndPopToRootTemplate {
					self.carplayInterefaceController?.presentTemplate(alert, animated: false, completion: { [weak self] (done, error) in
						guard let self = self else { return }
						self.handleError(error, prependedMessage: "Error presenting \(alert.classForCoder)")
					})
				}
			} else {
				self.carplayInterefaceController?.presentTemplate(alert, animated: false, completion: { [weak self] (done, error) in
					guard let self = self else { return }
					self.handleError(error, prependedMessage: "Error presenting \(alert.classForCoder)")
				})
			}
		default:
			dismissAlertAndPopToRootTemplate { [weak self] in
				guard let self = self else { return }
//				self.setupMap()
//				self.setupTabbar()
				if self.currentLocationAuthorizationStatus != manager.authorizationStatus {
					print("Location authorization status changed")
					self.currentLocationAuthorizationStatus = manager.authorizationStatus
					self.setupTabbar()
				} else {
					print("No change in location authorization status")
				}
			}
			return
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else { return }
		boundingRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 12_000, longitudinalMeters: 12_000)
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Location Error: \(error.localizedDescription).")
	}
}
