//
//  StocksListView.swift
//  PolyCook
//
//  Created by Radu Bortan on 17/02/2022.
//

import SwiftUI

struct StocksListView: View {
    var body: some View {
        ZStack {
            Color.green
            Image(systemName: "shippingbox")
                .foregroundColor(Color.white)
                .font(.system(size: 100))
        }
    }
}

struct StocksListView_Previews: PreviewProvider {
    static var previews: some View {
        StocksListView()
    }
}
