//
//  ContentView.swift
//
//  Created by Marco Prontera.
//

import SwiftUI
import PubConsent
import WebKit
import UIKit

struct ContentView: View {
    private let viewControllerRepresentable = ViewControllerRepresentable()
    
    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .bottom, content: {
                    VStack(alignment: .leading, content: {
                        Text("PubConsent CMP").font(.title)
                        Text("iOS").font(.title).colorInvert()
                    })
                    
                    VStack(alignment: .center, content: {
                        Text("Simple")
                        Text("preview")
                    })
                    
                })
                
                VStack(spacing: 30) {
                    Text("Demo Actions:").font(.headline)
                    
                    Button("Open CMP") {
                        PubConsentCMP.shared.showNotice()
                    }.foregroundColor(.white)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(8)
                }
                .padding(.top, 100)
                .background {
                    viewControllerRepresentable
                        .frame(width: .zero, height: .zero)
                }
                .onAppear {
                    Task {
                        PubConsentCMP.shared.setupUI(containerController: viewControllerRepresentable.viewController)
                    }
                }
            }
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "#ff4f00"))
    }
}

extension Color {
        init(hex: String, alpha: Double = 1.0) {
            var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

            var rgb: UInt64 = 0

            Scanner(string: hexSanitized).scanHexInt64(&rgb)

            let red = Double((rgb & 0xFF0000) >> 16) / 255.0
            let green = Double((rgb & 0x00FF00) >> 8) / 255.0
            let blue = Double(rgb & 0x0000FF) / 255.0

            self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
        }
}


#Preview {
    ContentView()
}
