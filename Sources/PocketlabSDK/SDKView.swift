//
//  SwiftUIView.swift
//  
//
//  Created by Youbaraj POUDEL on 07/11/2023.
//

import SwiftUI

public struct SDKView: View {
    @available(macOS 10.15, *)
    public var body: some View {
        Text("Hello sdk")
    }
}

public struct SwiftUIView_Previews: PreviewProvider {
    @available(macOS 10.15, *)
    public static var previews: some View {
        SDKView()
    }
}
