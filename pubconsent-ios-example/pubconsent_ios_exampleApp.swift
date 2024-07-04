//
//  pubconsent_ios_exampleApp.swift
//  pubconsent-ios-example
//
//  Created by Marco Prontera.
//

import SwiftUI
import PubConsent

class ConsentReadyHandler: OnConsentReadyCallback {
    func onConsentReady() {
        print("Consent is ready.")
    }
}

class CloseUIHandler: OnCloseUICallback {
    func onCmpUIClosed() {
        print("CMP UI has been closed.")
    }
}

class OpenUIHandler: OnOpenUICallback {
    func onCmpUIOpen() {
        print("CMP UI has been opened.")
    }
}

// Implement the OnGoogleConsentModeCallback protocol
class GoogleConsentModeHandler: OnGoogleConsentModeCallback {
    func update(googleConsentModeMap: [GoogleConsentModeType: GoogleConsentModeStatus]) {
        print("Google consent mode updated:")
        
        print("Status ad_personalization: \(googleConsentModeMap[GoogleConsentModeType.ad_personalization] == GoogleConsentModeStatus.granted)")
        print("Status ad_storage: \(googleConsentModeMap[GoogleConsentModeType.ad_storage] == GoogleConsentModeStatus.granted)")
        print("Status ad_user_data: \(googleConsentModeMap[GoogleConsentModeType.ad_user_data] == GoogleConsentModeStatus.granted)")
        print("Status analytics_storage: \(googleConsentModeMap[GoogleConsentModeType.analytics_storage] == GoogleConsentModeStatus.granted)")
    }
}

class ErrorHandler: OnErrorCallback {
    func onError(message: String) {
        print("Error occurred: \(message)")
    }
}



class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let consentReadyHandler = ConsentReadyHandler()
        let closeUIHandler = CloseUIHandler()
        let openUIHandler = OpenUIHandler()
        let googleConsentModeHandler = GoogleConsentModeHandler()
        let errorHandler = ErrorHandler()

        let cmpCallbacks = CmpCallbacks(
            onConsentReadyCallback: consentReadyHandler,
            onCloseUICallback: closeUIHandler,
            onCmpUIOpenCallback: openUIHandler,
            onErrorCallback: errorHandler,
            onGoogleConsentModeCallback: googleConsentModeHandler
        )
        
        // Please change the "id" and the "appName" this are used only for our demo purpose.
        // You can get the "id" from our Configurator.
        // The "appName" is something you have to choose here and don't change unless you have the purpose of doing that. (The appName will be useful for searching report date in our dashboard)
        let parameters = CmpConfig(
            id: "362", appName: "demo-app-apple", debug: true, callbacks: cmpCallbacks
        )
        PubConsentCMP.shared.configure(cmpConfiguration: parameters)
        return true
    }
}

@main
struct pubconsent_ios_exampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
