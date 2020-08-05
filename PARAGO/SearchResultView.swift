//
//  SearchResult.swift
//  PARAGO
//
//  Created by leedonggi on 2020/06/03.
//  Copyright © 2020 DaeduckSoftwareMeisterHighSchool. All rights reserved.
//

import SwiftUI
import WebKit

import struct Kingfisher.KFImage

struct SearchResultView: SwiftUI.View {
    
    @State var showCard = false
    @State var bottomState = CGSize.zero
    @State var showFull = false
    @State var selectedRow = 0
    @State private var image: UIImage = UIImage(named: "TestImage")!
    
    @Binding var datas: [[String: Any]]
    @Binding var images: [UIImage?]
    
    let colors: [SwiftUI.Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]
    var imageURL: URL? = URL(string: "https://shopping-phinf.pstatic.net/main_2230069/22300691253.20200519165442.jpg?type=f300")
    
    public let animation: Animation = .easeInOut
    
    var selectedImage = 0
    
    var body: some SwiftUI.View {
        VStack {
            GeometryReader { fullView in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(0..<self.datas.count, id: \.self) { index in
                            GeometryReader { geo in
                                Image(uiImage: UIImage(named: "TestImage")!)
                                    .resizable()
                                    .frame(width: 240, height: 240)
                                    .rotation3DEffect(.degrees(-Double(geo.frame(in: .global).midX - fullView.size.width / 2) / 28), axis: (x: 0, y: 1, z: 0))
                                    .shadow(color: Color.gray, radius: 3, x: 0, y: 3)
                                    .onTapGesture {
                                        self.selectedRow = index
                                }
                            }
                            .frame(width: 240)
                        }
                    }
                    .padding(.horizontal, (fullView.size.width - 240) / 2)
                }
            }
            .edgesIgnoringSafeArea(.all)
            .padding(.top, 40)
            ResultsView(showFull: $showFull, datas: $datas, selectedRow: $selectedRow)
                .padding(.top, 36)
                .padding(.bottom, -800)
                .offset(y: bottomState.height)
                .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8))
                .gesture(
                    DragGesture().onChanged { value in
                        self.bottomState = value.translation
                        if self.showFull {
                            self.bottomState.height += -300
                        }
                        if self.bottomState.height < -300 {
                            self.bottomState.height = -300
                        }
                    }
                    .onEnded { value in
                        if self.bottomState.height > 50 {
                            self.showCard = false
                        }
                        if (self.bottomState.height < -100 && !self.showFull) || (self.bottomState.height < -250 && self.showFull) {
                            self.bottomState.height = -300
                            self.showFull = true
                        } else {
                            self.bottomState = .zero
                            self.showFull = false
                        }
                    }
            )
            
        }
        .frame(minWidth: 0, maxWidth: UIScreen.screenWidth, minHeight: 0, maxHeight: .infinity)
        .background(Color("SearchBackgroundViewColor").edgesIgnoringSafeArea(.all))
    }
}

struct SearchResult_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        SearchResultView(datas: .constant([["product_name": "아이패드", "product_image": "https://shopping-phinf.pstatic.net/main_2230069/22300691253.20200519165442.jpg?type=f300", "product_site_link": "https://cr.shopping.naver.com/adcr.nhn?x=fBX9tHiMNdNRDpZxfkoVI%2F%2F%2F%2Fw%3D%3DsHe6Cb0w6TtVRDbdcka7Q0uYP0uBNwsfVdlA5kHSOpEk%2BOfKYJdVgfWNA6Z7HnieO65qRJcAqj1G4CNK8c9zyJfGNy9GydTw15BM3y5ulP2r%2BqFclSH6l0Wn5v3AT7DPw6zT5Hgx5TTxQ%2BM75VCGFC4ZYgwI2fs40XR%2FERq%2FGNyfWK4fiV391hyKbNzjTTmNI%2F%2FSiPXKi%2B9pwhREjyzAApJ0KU00sfVPduGrpKCqiG6Ki4%2Fr0lz1oSk9AW8qzFsUvpOr9sPYwajBkeE07IGGkJ5SCPsmGKllbt0kl8XIxCXQpmSPk%2BKDY%2FhD9apGSyZ5M3Iw2Nm7karCopX5mfU2uumZvbKpa7szeS6nFZhKwSGQ97Y3v8mSS3UD2Mjs%2BCnWbp8YGww9l3yIHF0RdEHFDW0Kz4SmQiJExuAao%2FbMtl6xIDZT%2BrRwks2AZL72XkHMG%2BIZXYQLgMKAPsyX7KB4BUPs0IWXVK58ZXAnkbAdmSGWTi%2FZ6nCDE0UUPvUdmrdYQTIETHLNys2o0jgmxqRUJqK8m28CPWi%2F6R7yaV4gOKn3zozDl1lnH3Ou2C%2F%2ByAOxrnzL64vaddAzoaTGWLP%2BNHx0cjwVm1BUYVknE7IEMpz4%3D&nvMid=82428972412&catId=50000152"]]), images: .constant([UIImage(named: "TestImage")]))
    }
}

struct HashTag: SwiftUI.View {
    var body: some SwiftUI.View {
        Rectangle()
            .cornerRadius(16)
            .foregroundColor(Color("HashTagColor"))
            .opacity(0.5)
            .shadow(color: Color.gray, radius: 2, x: 0, y: 3)
            .frame(height: 34)
    }
}

struct WebView : UIViewRepresentable {
    
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
    
}

struct ResultsView: SwiftUI.View {
    @Binding var showFull: Bool
    @Binding var datas: [[String: Any]]
    @Binding var selectedRow: Int
    
    var body: some SwiftUI.View {
        VStack(spacing: 20) {
            Rectangle()
                .frame(width: 40, height: 5)
                .cornerRadius(3)
                .opacity(0.1)
            Text("\(datas[selectedRow]["product_name"] as! String)")
                .padding(.bottom, -10)
            WebView(request: URLRequest(url: URL(string: "\(datas[selectedRow]["product_site_link"] as! String)")!))
                .frame(width: UIScreen.screenWidth - 32)
                .frame(height: showFull ? 540:240)
                .edgesIgnoringSafeArea(.all)
            Spacer()
        }
        .padding(.top, 8)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(30)
        .shadow(radius: 20)
    }
}

struct ResultRow: SwiftUI.View {
    var value: String
    var postFee: String
    
    var body: some SwiftUI.View {
        VStack(alignment: .center) {
            HStack {
                Image("GmarketLogo")
                Spacer()
                VStack {
                    HStack {
                        Text("가격")
                            .font(.system(size: 12))
                        Spacer()
                        Text("\(value)")
                            .font(.system(size: 12))
                    }
                    HStack {
                        Text("배송비")
                            .font(.system(size: 12))
                        Spacer()
                        Text("\(postFee)")
                            .font(.system(size: 12))
                    }
                }
                .frame(width: 110)
            }
        }
    }
}
