//
//  CarPlaySceneDelegate.swift
//  CarPlay
//
//  Created by MAC240 on 18/10/21.

import UIKit
import CarPlay


class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
   
    
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene,
                                  didConnect interfaceController: CPInterfaceController, to window:  CPWindow) {
        TemplateManager.shared.interfaceController(interfaceController, didConnectWith: window)
    }

    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didDisconnectInterfaceController interfaceController: CPInterfaceController, to window:  CPWindow) {
        TemplateManager.shared.interfaceController(interfaceController, didDisconnectWith: window)
    }
	
	func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didConnect interfaceController: CPInterfaceController) {
		TemplateManager.shared.interfaceController(interfaceController, scene: templateApplicationScene)
	}
}
