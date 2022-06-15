//
//  ButtonStyles.swift
//  sususudoku
//
//  Created by TeU on 2022/6/15.
//

import SwiftUI

struct ActivityButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding([.vertical], 8)
            .frame(minWidth: UIScreen.screenWidth * 0.6)
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .shadow(color: Color("Shadow"), radius: 2, x: 0, y: 2)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

#if DEBUG
struct ButtonStyles_Previews: PreviewProvider {
    static var previews: some View {
        Button("ActivityButtonStyle") {}
            .buttonStyle(ActivityButtonStyle())
            .previewLayout(.sizeThatFits)
    }
}
#endif
