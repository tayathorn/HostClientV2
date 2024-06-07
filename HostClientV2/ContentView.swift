//
//  ContentView.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 6/6/2567 BE.
//

import SwiftUI

struct ContentView: View {
    @State private var mode: String = ""
    @State private var message: String = ""
    
    let openDrawerHandler = OpenDrawerHandler()
    
    var body: some View {
        VStack {
            Text(mode)
                .padding()
                .font(.headline)
            
            Text(message)
                .onAppear {
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("UPDATE_UI"), object: nil, queue: .main) { notification in
                        // Handle notification here
                        print("Received notification: \(notification)")
                        if let object = notification.object as? OpenDrawerEvent {
                            message = "drawer id: \(object.cashDrawerID) amount: \(object.amount)"
                        }
                        
                        if let object = notification.object as? OpenDrawerCommand {
                            message = "drawer id: \(object.cashDrawerID) amount: \(object.amount)"
                        }
                    }
                }
            
            Button(action: {
                HostControllerManagerV2.shared.set(role: .host)
                mode = HostControllerManagerV2.shared.role.rawValue
            }) {
                Text("Host")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Button(action: {
                HostControllerManagerV2.shared.set(role: .client)
                mode = HostControllerManagerV2.shared.role.rawValue
            }) {
                Text("Client")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Button(action: {
                openDrawerHandler.handleSend(useSocket: false)
            }) {
                Text("Open drawer via http")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Button(action: {
                openDrawerHandler.handleSend(useSocket: true)
            }) {
                Text("Open drawer via socket")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
