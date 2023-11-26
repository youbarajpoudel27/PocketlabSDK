//
//  SwiftUIView.swift
//  
//
//  Created by Youbaraj POUDEL on 08/11/2023.
//

import SwiftUI

public enum ScenarioInstanceStepsType {
    case identification,photo,exptectedVariety, analysis, note
}


public struct ScenarioPlayerComponent: View {
    
    public var annotationType: AnnotationType
    public var scenarioId: Int
    
    public init(){
        self.annotationType = AnnotationType.remoteId
        self.scenarioId = 1288
    }
    
    public init(annotationType: AnnotationType, scenarioId: Int) {
        self.annotationType = annotationType
        self.scenarioId = scenarioId
    }
    
    public var body: some View {
        NavigationView {
            ZStack {
                if false {
                    ProgressView()
                        .navigationBarBackButtonHidden(true)
                        .onAppear {
                        }
                }else {
                    VStack {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 16) {
                                VStack {
                                    ZStack(alignment: .top) {
                                        ZStack(alignment: .bottom) {
                                            Spacer()
                                                .frame(height: 200)
                                        }
                                        HStack {
                                            Spacer()
                                            Button{
                                            } label: {
                                                
                                            }
                                        }
                                        .padding(.horizontal, 32)
                                    }
                                }//end of vstack
                                VStack(spacing: 0) {
                                    VStack(alignment: .center) {
                                        Spacer().frame(height: 12)
                                        PackageCustomText(name: "Created on 28/02/23 at 09:53", textColor: PackageColors.pureBlack.opacity(0.4) ,alignment: .center, font: PackageFonts.regularFont12)
                                        Spacer().frame(height: 12)
                                    }.frame(maxWidth: .infinity) //end of vstack
                                    
                                    VStack {
                                        PackageImageTextView(title: "Identification", annotationType: AnnotationType.remoteId, scenarioInstanceStepsType:ScenarioInstanceStepsType.identification)
                                        
                                       //add navigation link for image later.
                                        
                                        //variety declaration
                                        NavigationLink {
                                            VarietyDeclarationView()
                                        } label: {
                                            PackageImageTextView(title: "Expected variety", secondaryTitle: "Apprilio", annotationType: AnnotationType.variety, scenarioInstanceStepsType: ScenarioInstanceStepsType.exptectedVariety)
                                        }
                                        
                                        //add other steps later based on the scenario system config.
                                        
                                        
                                    }//end of vstack
                                    .padding(.horizontal, 16)
                                }
                                .background(PackageColors.darkGray)
                                .packageCornerRadius(20, corners: [.topLeft, .topRight])
                                .cornerRadius(20)
                                
                            }
                        }
                    }
                    .background(
                        GeometryReader { geometry in
                            PackageColors.brown
                                .frame(height: min(geometry.size.height, 240))
                        }
                    )
                    .background(PackageColors.darkGray)
                    
                    .edgesIgnoringSafeArea(.top)
                }
            }
        }
    }
}

struct ScenarioPlayerComponent_Previews: PreviewProvider {
    static var previews: some View {
        ScenarioPlayerComponent(annotationType: AnnotationType.remoteId,  scenarioId: 1288)
    }
}


public struct PackageImageTextView: View {
    public var title: String
    public var secondaryTitle: String?
    public var annotationType: AnnotationType
    public var scenarioInstanceStepsType: ScenarioInstanceStepsType
    public var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    //Image("plus", bundle: .module)
                    Text(title)
                        .foregroundColor(PackageColors.pureBlack)
                    Spacer()
                    if let secondaryTitle = secondaryTitle {
                        Text(secondaryTitle)
                            .foregroundColor(PackageColors.pureBlack)
                      //  Image("plus", bundle: .module)
                    }
                    if getHeight() == 40 {
                        TickMarkView()
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .frame(height: getHeight())
            .background(PackageColors.pureWhite)
            .cornerRadius(10)
            
        }
    }

    
    func getHeight() -> (CGFloat) {
        switch annotationType {
        case .remoteId, .variety, .proteinRate: return 58
        case .customRemoteId(_):
            if scenarioInstanceStepsType == .identification { return 40 }
        case .customVariety(_):
            if scenarioInstanceStepsType == .exptectedVariety { return 40 }
           
        default: return 58
        }
        return 58
    }
}

public struct TickMarkView: View {
    public var defaultColor: Color = .green
    public var defaultSize: CGFloat = 24

    public var body: some View {
        Image(systemName: "checkmark")
            .foregroundColor(defaultColor)
            .font(.system(size: defaultSize))
    }
}

