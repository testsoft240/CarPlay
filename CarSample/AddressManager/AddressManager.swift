//
//  AddressManager.swift
//  CarSample
//
//  Created by Krima Shah on 10/11/21.
//

import Foundation
import Contacts

class BaseAddress: CNPostalAddress {
	override var country: String {
		return "US"
	}
	
	override var city: String {
		return "San Francisco"
	}
	
	override var state: String {
		return "CA"
	}
	
	override var postalCode: String {
		return "94102"
	}
}

class CityHall: BaseAddress {
	override var street: String {
		return "1 Dr. Carlton B Goodlett Pl"
	}
}

class TheBridge: BaseAddress {
	override var street: String {
		return "Golden Gate Bridge Plaza"
	}
	
	override var postalCode: String {
		return "94129"
	}
}
