//
//  SearchResult.swift
//  PARAGO
//
//  Created by leedonggi on 2020/06/03.
//  Copyright © 2020 DaeduckSoftwareMeisterHighSchool. All rights reserved.
//

import SwiftUI
import Kingfisher
import UIKit

struct SearchResultView: SwiftUI.View {
    
    @State var showCard = false
    @State var bottomState = CGSize.zero
    @State var showFull = false
    @State var leftImage = 1
    @State var centerImage = 2
    @State var rightImage = 3
    @State private var image: UIImage = UIImage(named: "TestImage")!
    
    @Binding var datas: [[String: Any]]
    
    let colors: [SwiftUI.Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]
    let images: [SwiftUI.Image] = [Image("TestImage")]
    let placeholderImage = UIImage(named: "TestImage")
    var imageURL: URL? = URL(string: "https://shopping-phinf.pstatic.net/main_2290754/22907549426.20200729113016.jpg?type=f300")
    public let animation: Animation = .easeInOut
    
    var selectedImage = 0
    
    var body: some SwiftUI.View {
        VStack {
            GeometryReader { fullView in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(0..<1) { index in
                            GeometryReader { geo in
                                Image(uiImage: self.image)
                                    .resizable()
                                    .frame(height: 240)
                                    .rotation3DEffect(.degrees(-Double(geo.frame(in: .global).midX - fullView.size.width / 2) / 28), axis: (x: 0, y: 1, z: 0))
                                    .shadow(color: Color.gray, radius: 3, x: 0, y: 3)
                            }
                            .frame(width: 240)
                        }
                    }
                    .padding(.horizontal, (fullView.size.width - 240) / 2)
                }
            }
            .edgesIgnoringSafeArea(.all)
            .padding(.top, 40)
            ResultsView(showFull: $showFull, datas: $datas)
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
        .onAppear {
            self.loadImage()
        }
    }
    
    private func loadImage() {
        let newURL = URL(string: "\(datas[0]["product_image"])")
        guard let imageURL = imageURL else { return }
        KingfisherManager.shared.retrieveImage(with: imageURL) { result in
            switch result {
            case .success(let imageResult):
                withAnimation(self.animation) {
                    self.image = imageResult.image
                }
            case .failure:
                break
            }
        }
    }
}

struct SearchResult_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        SearchResultView(datas: .constant([["": ""]]))
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

struct ResultsView: SwiftUI.View {
    @Binding var showFull: Bool
    @Binding var datas: [[String: Any]]
    
    var body: some SwiftUI.View {
        VStack(spacing: 20) {
            Rectangle()
                .frame(width: 40, height: 5)
                .cornerRadius(3)
                .opacity(0.1)
            Text("\(datas[0]["product_name"] as! String)")
                .padding(.bottom, -10)
            List {
                Group {
                    ResultRow(value: "1,960,000 원", postFee: "10,000원")
                    ResultRow(value: "1,960,000 원", postFee: "10,000원")
                    ResultRow(value: "1,960,000 원", postFee: "10,000원")
                    ResultRow(value: "1,960,000 원", postFee: "10,000원")
                    ResultRow(value: "1,960,000 원", postFee: "10,000원")
                    ResultRow(value: "1,960,000 원", postFee: "10,000원")
                    ResultRow(value: "1,960,000 원", postFee: "10,000원")
                    ResultRow(value: "1,960,000 원", postFee: "10,000원")
                    ResultRow(value: "1,960,000 원", postFee: "10,000원")
                    ResultRow(value: "1,960,000 원", postFee: "10,000원")
                }
                Group {
                    ResultRow(value: "1,960,000 원", postFee: "10,000원")
                    ResultRow(value: "1,960,000 원", postFee: "10,000원")
                    ResultRow(value: "1,960,000 원", postFee: "10,000원")
                    ResultRow(value: "1,960,000 원", postFee: "10,000원")
                    ResultRow(value: "1,960,000 원", postFee: "10,000원")
                    ResultRow(value: "1,960,000 원", postFee: "10,000원")
                    ResultRow(value: "1,960,000 원", postFee: "10,000원")
                    ResultRow(value: "1,960,000 원", postFee: "10,000원")
                    ResultRow(value: "1,960,000 원", postFee: "10,000원")
                    ResultRow(value: "1,960,000 원", postFee: "10,000원")
                }
            }
            .frame(height: showFull ? 560:260)
            .environment(\.defaultMinListRowHeight, 64)
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
