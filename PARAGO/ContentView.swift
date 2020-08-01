//
//  ContentView.swift
//  PARAGO
//
//  Created by leedonggi on 2020/06/03.
//  Copyright © 2020 DaeduckSoftwareMeisterHighSchool. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var txtSearch: String = ""
    @State private var isSearched = false
    @State private var showMyPage = false
    @State private var showSignin = false
    @State var rightState = CGSize.zero
    @State var datas: [[String: Any]] = [["product_name": ""]]
    
    var body: some View {
        ZStack {
            VStack() {
                Spacer()
                    .frame(height: isSearched ? 10 : 160)
                Text("PRAGO")
                    .font(.custom("Antonio-Bold", size: 40))
                    .foregroundColor(Color.white)
                    .shadow(color: Color.gray, radius: 2, x: 0, y: 3)
                    .padding(.bottom, -20)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0))
                ZStack {
                    Rectangle()
                        .foregroundColor(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.gray, radius: 2, x: 0, y: 3)
                    TextField("검색어를 입력하세요", text: $txtSearch)
                        .font(.system(size: 14))
                        .padding(.horizontal)
                }
                .padding(.horizontal, 36)
                .frame(height: 36)
                .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0))
                Button(action: {
                    self.isSearched.toggle()
                    self.showMyPage = false
                }) {
                    Button(isSearched ? "메인으로":"검색하기") {
                        if self.isSearched {
                            self.isSearched = false
                        } else {
                            self.getData()
                        }
                    }
                        .foregroundColor(Color.white)
                        .font(.system(size: 16))
                }
                .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0))
                Spacer()
                HStack {
                    Spacer()
                    Image("imgLabel")
                        .padding(.trailing, -36)
                }
                .padding(.bottom, 120)
                .opacity(isSearched ? 0 : 1)
                .frame(height: isSearched ? 0 : 140)
                .onTapGesture {
                    self.showMyPage.toggle()
                }
                SearchResultView(datas: $datas)
                    .frame(height: isSearched ? 680 : 0)
                    .opacity(isSearched ? 1 : 0)
                    .shadow(color: Color.gray, radius: 3, x: 0, y: 3)
                    .animation(.spring(response: 0.55, dampingFraction: 1, blendDuration: 0))
            }
            .frame(width: UIScreen.screenWidth)
            .background(LinearGradient.init(gradient: Gradient(colors: [Color("BackgroundStartColor"), Color("BackgroundFinishColor")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    ZStack {
                        Rectangle()
                            .foregroundColor(.white)
                        VStack {
                            HStack {
                                Text("My Page")
                                    .font(.custom("Antonio-Bold", size: 28))
                                    .fontWeight(.black)
                                    .lineLimit(1)
                                    .padding(.top, 48)
                                    .padding(.leading, 24)
                                Spacer()
                            }
                            List {
                                MypageRow(name: "로그인")
                                    .onTapGesture {
                                        self.showSignin = true
                                }
                                .sheet(isPresented: $showSignin) {
                                    SigninView()
                                }
                                MypageRow(name: "찜한 상품")
                                    .onTapGesture {
                                        self.showMyPage = false
                                        self.isSearched = true
                                }
                                MypageRow(name: "개인정보 변경")
                                MypageRow(name: "비밀번호 변경")
                            }
                            .padding(.top, -16)
                        }
                        .opacity(showMyPage ? 1 : 0)
                        .animation(.easeInOut(duration: 0.15))
                    }
                    .frame(width: showMyPage ? 300 : 0, height: 460)
                    .cornerRadius(30)
                    .shadow(color: Color.gray, radius: 3, x: 0, y: 3)
                    .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8))
                    .gesture(
                        DragGesture().onChanged { value in
                            self.rightState = value.translation
                            if self.showMyPage {
                                self.rightState.width += -300
                            }
                            if self.rightState.width < -300 {
                                self.rightState.width = -300
                            }
                        }
                        .onEnded { value in
                            if self.rightState.width > 50 {
                                self.showMyPage = false
                            }
                            if (self.rightState.width < -100 && !self.showMyPage) || (self.rightState.width < -250 && self.showMyPage) {
                                self.rightState.width = -300
                                self.showMyPage = true
                            } else {
                                self.rightState = .zero
                                self.showMyPage = false
                            }
                        }
                    )
                }}
                .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    func getData() {
        let url = "http://192.168.137.1:8080/search_api/search/?query=\(txtSearch)"
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        var request = URLRequest(url: URL(string: encodedURL)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request){
            [self] data, res, err in
            guard self != nil else { return }
            if let err = err { print(err.localizedDescription); return }
            print((res as! HTTPURLResponse).statusCode)
            switch (res as! HTTPURLResponse).statusCode{
            case 200:
                let jsonSerialization = try! JSONSerialization.jsonObject(with: data!, options: []) as! [[String: Any]]
                print(jsonSerialization)
                self.datas = jsonSerialization
                self.isSearched.toggle()
            default:
                print("error")
            }
        }.resume()
    }
}

struct MypageRow: View {
    var name: String
    
    var body: some View {
        Text("\(name)")
            .font(.system(size: 16))
            .padding(.leading, 6)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}
