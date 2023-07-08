//
//  widgetLiveActivity.swift
//  widget
//
//  Created by Yohey Kuwabara on 2022/10/21.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct widgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var lightState: Int
        var lightText: String
        
        var greenOpacity: Double
        var greenShadow: CGFloat
        
        var yellowOpacity: Double
        var yellowShadow: CGFloat
        
        var redOpacity: Double
        var redShadow: CGFloat
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct widgetLiveActivity: Widget {
    let ratio1: CGFloat = 1.6
    let ratio2: CGFloat = 2.4
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: widgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            GeometryReader{ geo in
                let lightSize: CGFloat = geo.size.height/ratio1
                let lightPadding: CGFloat = geo.size.height*(1 - 1/ratio1)/2
                
                let lightSize2: CGFloat = geo.size.height/ratio2
                let lightPadding2: CGFloat = (geo.size.height - 2*geo.size.height/ratio2)/2
                
                ///LightsView2(context: context, lightSize: lightSize2, lightPadding: lightPadding2)
                ipodView(geometry: geo.size)
            }
            ///.frame(height: 200)
            ///.activityBackgroundTint(.primary)
            ///.activitySystemActionForegroundColor(Color.white)
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    
                }
                DynamicIslandExpandedRegion(.trailing) {
                    
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack{
                        Circle()
                            .foregroundColor(.green.opacity(context.state.greenOpacity))
                            .shadow(color: .green,radius: context.state.greenShadow)
                        
                        Circle()
                            .foregroundColor(.yellow.opacity(context.state.yellowOpacity))
                            .shadow(color: .yellow,radius: context.state.yellowShadow)
                        
                        Circle()
                            .foregroundColor(.red.opacity(context.state.redOpacity))
                            .shadow(color: .red,radius: context.state.redShadow)
                    }
                }
            } compactLeading: {
                Circle()
                    .foregroundColor(.green.opacity(context.state.greenOpacity))
                    .shadow(color: .green,radius: context.state.greenShadow)
            } compactTrailing: {
                Circle()
                    .foregroundColor(.red.opacity(context.state.redOpacity))
                    .shadow(color: .red,radius: context.state.redShadow)
            } minimal: {
                Circle()
                    .foregroundColor(.green.opacity(context.state.greenOpacity))
                    .shadow(color: .green,radius: context.state.greenShadow)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

struct LightsView1: View{
    var context: ActivityViewContext<widgetAttributes>
    var lightSize: CGFloat
    var lightPadding: CGFloat
    
    var body: some View{
        VStack{
            if context.state.lightState == 0{
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: lightPadding)
                        ///Rectangle()
                            .frame(width: lightSize, height: lightSize)
                            ///.clipShape(ContainerRelativeShape())
                            .foregroundColor(.green.opacity(context.state.greenOpacity))
                            .shadow(color: .green,radius: context.state.greenShadow)
                        
                        Image(systemName: "figure.walk")
                            .resizable()
                            .scaledToFit()
                            .frame(width: lightSize - 10, height: lightSize - 10)
                            .foregroundColor(.white.opacity(context.state.greenOpacity))
                    }
                    .padding(lightPadding)
                    
                    
                    Text("青になりました")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green.opacity(context.state.greenOpacity))
                        .padding(.vertical, lightPadding)
                        .padding(.trailing, lightPadding)
                    
                }
            }else if context.state.lightState == 2{
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: lightPadding)
                            .frame(width: lightSize, height: lightSize)
                            .foregroundColor(.red.opacity(context.state.redOpacity))
                            .shadow(color: .red ,radius: context.state.redShadow)
                        
                        Image("figure.standing")
                            .resizable()
                            .scaledToFit()
                            .frame(width: lightSize - 10, height: lightSize - 10)
                            .foregroundColor(.white.opacity(context.state.redOpacity))
                    }
                    .padding(lightPadding)
                    
                    Text("赤になりました")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.red.opacity(context.state.redOpacity))
                        .padding(.vertical, lightPadding)
                        .padding(.trailing, lightPadding)
                }
            }
        }
    }
}

struct LightsView2: View{
    var context: ActivityViewContext<widgetAttributes>
    var lightSize: CGFloat
    var lightPadding: CGFloat
    ///var lightColor: Color
    
    var body: some View{
        VStack{
            HStack{
                VStack(spacing: 0){
                    ZStack{
                        light(context: context, lightSize: lightSize, lightPadding: lightPadding, lightColor: Color.red, lightOpacity: context.state.redOpacity, figureName: "figure.standing")
                    }
                    ///.padding(lightPadding)
                    
                    ZStack{
                        light(context: context, lightSize: lightSize, lightPadding: lightPadding, lightColor: Color.green, lightOpacity: context.state.greenOpacity, figureName: "figure.walk")
                    }
                    ///.padding(lightPadding)
                }
                .padding(lightPadding)
                
                Spacer()
                
                if context.state.lightState == 0{
                    TextView2(context: context, lightColorText: "青", textColor: Color.green, lightPadding: lightPadding)
                }else if context.state.lightState == 2{
                    TextView2(context: context, lightColorText: "赤", textColor: Color.red, lightPadding: lightPadding)
                }
                
                Spacer()
                
            }
        }
    }
}

struct light: View{
    var context: ActivityViewContext<widgetAttributes>
    var lightSize: CGFloat
    var lightPadding: CGFloat
    var lightColor: Color
    var lightOpacity: CGFloat
    
    var figureName: String
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 10)
            ///Rectangle()
                .frame(width: lightSize, height: lightSize)
            ///.clipShape(ContainerRelativeShape())
                .foregroundColor(lightColor.opacity(lightOpacity))
                .shadow(color: lightColor,radius: 10)
            
            Image(figureName)
                .resizable()
                .scaledToFit()
                .frame(width: lightSize - 10, height: lightSize - 10)
                .foregroundColor(.white.opacity(lightOpacity))
        }
    }
}

struct TextView2: View{
    var context: ActivityViewContext<widgetAttributes>
    var lightColorText: String
    var textColor: Color
    var lightPadding: CGFloat
    
    var body: some View{
        Text("信号が\(lightColorText)になりました")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(textColor)
            .padding(.vertical, lightPadding)
            .padding(.trailing, lightPadding)
    }
}

struct ipodView: View{
    var geometry: CGSize
    
    var body: some View{
        ZStack(alignment: .center){
            Color.chicagoBG
            
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: geometry.width, y: 0))
                path.addLine(to: CGPoint(x: 0, y: geometry.height))
                path.closeSubpath()
            }
            .fill()
            .foregroundColor(.black)
            .opacity(0.8)
            .blur(radius: 10)
            
            Path { path in
                path.move(to: CGPoint(x: geometry.width, y: geometry.height))
                path.addLine(to: CGPoint(x: geometry.width, y: 0))
                path.addLine(to: CGPoint(x: 0, y: geometry.height))
                path.closeSubpath()
            }
            .fill()
            .foregroundColor(.black)
            .opacity(0.5)
            .blur(radius: 10)
            
            Color.chicagoBG
                .clipShape(ContainerRelativeShape())
                .padding(4)
                .blur(radius: 3)
            
            VStack(alignment: .center){
                ZStack{
                    HStack(alignment: .center){
                        Image(systemName: "play.fill")
                            .foregroundColor(.chicagoText)
                        Spacer()
                        Image(systemName: "battery.100")
                            .foregroundColor(.chicagoText)
                        
                        
                    }
                    Text("Now Playing")
                        .font(.custom("Chicago", size: 18))
                        .foregroundColor(.chicagoText)
                        .offset(x: 0, y: 3)
                    
                    
                }
                Rectangle()
                    .frame(width: geometry.width - 30, height: 2)
                    .foregroundColor(.chicagoText)
                Spacer()
                Text("song title")
                    .font(.custom("Chicago", size: 28))
                    .foregroundColor(.chicagoText)
                Text("artist name")
                    .font(.custom("Chicago", size: 22))
                    .foregroundColor(.chicagoText)
                Spacer()
                
            }
            .padding()
        }
        .activityBackgroundTint(.chicagoBG)
        .activitySystemActionForegroundColor(Color.chicagoText)
    }
}

extension Color {
    static let chicagoText = Color("chicagoText")
    static let chicagoBG = Color("chicagoBG")
}
