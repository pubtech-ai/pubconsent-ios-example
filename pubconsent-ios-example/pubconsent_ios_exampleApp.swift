//
//  pubconsent_ios_exampleApp.swift
//  pubconsent-ios-example
//
//  Created by Marco Prontera.
//

import SwiftUI
import PubConsent

class ConsentReadyHandler: OnConsentReadyCallback {
    func onConsentReady(consentApiInstance: any PubConsent.ConsentApiInterface) {
        if (consentApiInstance.getCmpType() == CmpType.TCF_V2_GDPR) {
            if let apiInstance = consentApiInstance as? TCFGDPRConsentApi {
                print("Google Consent Status \(apiInstance.isVendorConsentEnabled(vendorId: 755))")
                print("Google Consent Mode ad_personalization granted? \(apiInstance.getGoogleConsentMode()[GoogleConsentModeType.ad_personalization] == .granted)")
            } else {
                print("Contact Pubtech since there is some unexpected problem (This can't happen but it's better to track every exception.")
            }
        }
        if (consentApiInstance.getCmpType() == CmpType.GOOGLE_CONSENT_MODE) {
            if let apiInstance = consentApiInstance as? GCMConsentApi {
                print("Google Consent Mode ad_personalization granted? \(apiInstance.getGoogleConsentMode()[GoogleConsentModeType.ad_personalization] == .granted)")
            }
        }
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
