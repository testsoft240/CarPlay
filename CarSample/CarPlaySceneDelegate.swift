//
//  CarPlaySceneDelegate.swift
//  CarPlay
//
//  Created by MAC240 on 18/10/21.

import UIKit
// CarPlay App Lifecycle

import CarPlay

class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
    var interfaceController: CPInterfaceController?

    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene,
            didConnect interfaceController: CPInterfaceController) {


        //Creating the tab sections
        let tabFav = CPListItem(text: "Favorites", detailText: "Subtitle For Favourites")
        let tabRecent = CPListItem(text: "Most Recent", detailText: "Subtitle For Most Recent")
        let tabHistory = CPListItem(text: "History", detailText: "Subtitle For History")
        let tabSearch = CPListItem(text: "Search", detailText: "Subtitle For Search")
        
        //adding the above tabs in section
        let sectionItemsA = CPListSection(items: [tabFav,tabRecent,tabHistory,tabSearch])
        let sectionItemsB = CPListSection(items: [tabFav,tabHistory])
        
        let listTemplate = CPListTemplate(title: "", sections: [sectionItemsA])
        let listTemplateA = CPListTemplate(title: "", sections: [sectionItemsB])
        let listTemplateB = CPListTemplate(title: "", sections: [sectionItemsA])
        let listTemplateC = CPListTemplate(title: "", sections: [sectionItemsB])
        
        //Creating Tabs
        let tabA: CPListTemplate = listTemplate
        tabA.tabSystemItem = .favorites
        tabA.showsTabBadge = false
        
        let tabB: CPListTemplate = listTemplateA
        tabB.tabSystemItem = .mostRecent
        tabB.showsTabBadge = true
        
        let tabC: CPListTemplate = listTemplateB
        tabC.tabSystemItem = .history
        tabC.showsTabBadge = false
        
        let tabD: CPListTemplate = listTemplateC
        tabD.tabSystemItem = .search
        tabD.showsTabBadge = false
        
        let tabBarTemplate = CPTabBarTemplate(templates: [tabA,tabB,tabC,tabD])
        interfaceController.setRootTemplate(tabBarTemplate, animated: true, completion: nil)
    }

    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didDisconnectInterfaceController interfaceController: CPInterfaceController) {
        self.interfaceController = nil
    }
}
