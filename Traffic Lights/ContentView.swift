//
//  ContentView.swift
//  Traffic Lights
//
//  Created by Yohey Kuwabara on 2022/10/21.
//

import SwiftUI
import ActivityKit

struct ContentView: View {
    @ObservedObject var model = LightsModel()
    
    @State var activity: Activity<widgetAttributes>?
    
    var body: some View {
        VStack {
            Button(action: {startActivity()}){Text("Start Activity")}
            
            VerticalView(model: model)
            
            HorizontalView(model: model)
        }
        .padding()
        .onChange(of: model.lightState){newValue in
            updateActivity()
        }
        .onAppear(){
            ///startActivity()
        }
    }
    
    func startActivity(){
        print("start activity")
        let attributes = widgetAttributes(name: "name")
        let state = widgetAttributes.ContentState(lightState: model.lightState, lightText: model.lightText, greenOpacity: model.greenOpacity, greenShadow: model.greenShadow, yellowOpacity: model.yellowOpacity, yellowShadow: model.yellowShadow, redOpacity: model.redOpacity, redShadow: model.redShadow)
        
        do {
            activity = try Activity<widgetAttributes>.request(attributes: attributes, contentState: state)
            
        }catch (let error) {
            print("error has occured", error)
        }
    }
    
    func updateActivity() {
        print("update activity")
        let state = widgetAttributes.ContentState(lightState: model.lightState, lightText: model.lightText, greenOpacity: model.greenOpacity, greenShadow: model.greenShadow, yellowOpacity: model.yellowOpacity, yellowShadow: model.yellowShadow, redOpacity: model.redOpacity, redShadow: model.redShadow)
        
        ///let updateState = activity?.contentState
        ///updateState.
        Task{
            await activity?.update(using: state)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct VerticalView: View {
    @ObservedObject var model: LightsModel
    
    var body: some View {
        Button(action: {
            model.SwitchState()
        }){
            ZStack{
                RoundedRectangle(cornerRadius: 30)
                    .frame(width: 120, height: 230)
                    .foregroundColor(.primary)
                
                VStack(spacing: 10){
                    ZStack{
                        RoundedRectangle(cornerRadius: 30)
                            .frame(width: 100, height: 100)
                            .foregroundColor(.red.opacity(model.redOpacity))
                            .shadow(color: .red ,radius: model.redShadow)
                        
                        Image("figure.standing")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 65, height: 65)
                            .foregroundColor(.white.opacity(model.redOpacity))
                    }
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 30)
                            .frame(width: 100, height: 100)
                            .foregroundColor(.green.opacity(model.greenOpacity))
                            .shadow(color: .green,radius: model.greenShadow)
                        
                        Image(systemName: "figure.walk")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 65, height: 65)
                            .foregroundColor(.white.opacity(model.greenOpacity))
                    }
                }
            }
        }
    }
}

struct HorizontalView: View {
    @ObservedObject var model: LightsModel
    
    var body: some View {
        Button(action: {
            model.SwitchState()
        }){
            ZStack{
                RoundedRectangle(cornerRadius: 60)
                    .frame(width: 340, height: 120)
                    .foregroundColor(.primary)
                HStack{
                    Circle()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.green.opacity(model.greenOpacity))
                        .shadow(color: .green,radius: model.greenShadow)
                    Circle()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.yellow.opacity(model.yellowOpacity))
                        .shadow(color: .yellow,radius: model.yellowShadow)
                    
                    Circle()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.red.opacity(model.redOpacity))
                        .shadow(color: .red,radius: model.redShadow)
                    
                }
                
            }
        }
    }
}

class LightsModel: ObservableObject{
    @Published var lightState: Int = 0 //0:green 1:yellow 2:red
    
    @Published var greenOpacity = 1.0
    @Published var yellowOpacity = 0.2
    @Published var redOpacity = 0.2
    
    @Published var greenShadow: CGFloat = 20
    @Published var yellowShadow: CGFloat = 0
    @Published var redShadow: CGFloat = 0
    
    var offOpacity = 0.2
    var onShadow: CGFloat = 20
    
    var lightText = "青"
    let greenText = "青"
    let redText = "赤"
    
    var lightColor = Color.green
    
    func SwitchState(){
        print("switch state")
        withAnimation(){
            if lightState == 2{
                lightState = 0
            }else{
                lightState += 1
            }
            
            switch lightState {
            case 0:
                greenOpacity = 1.0
                redOpacity = offOpacity
                
                greenShadow = onShadow
                redShadow = 0
                
                lightText = greenText
                lightColor = Color.green
            case 1:
                yellowOpacity = 1.0
                greenOpacity = offOpacity
                
                yellowShadow = onShadow
                greenShadow = 0
                
                lightColor = Color.yellow
            case 2:
                redOpacity = 1.0
                yellowOpacity = offOpacity
                
                redShadow = onShadow
                yellowShadow = 0
                
                lightText = redText
                lightColor = Color.red
            default:
                greenOpacity = 1.0
                yellowOpacity = 1.0
                redOpacity = 1.0
            }
        }
    }
}

