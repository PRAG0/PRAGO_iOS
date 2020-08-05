//
//  SigninView.swift
//  PRAGO
//
//  Created by leedonggi on 2020/07/08.
//  Copyright © 2020 DaeduckSoftwareMeisterHighSchool. All rights reserved.
//

import SwiftUI

struct SigninView: View {
    
    @State private var txtID = ""
    @State private var txtPW = ""
    @State private var signUpID = ""
    @State private var signUpPW = ""
    @State private var txtUserName = ""
    @State private var isNeedSignup = false
    @State private var isNeedName = false
    
    @Binding var isSignIn: Bool
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 160)
            Text("PRAGO")
                .font(.custom("Antonio-Bold", size: 48))
                .foregroundColor(Color.white)
            Spacer()
                .frame(height: 60)
            HStack {
                SigninSubView(txtID: $txtID, txtPW: $txtPW, isNeedName: $isNeedName, isSignIn: $isSignIn)
                    .frame(width: UIScreen.screenWidth)
                SignupSubView(txtID: $signUpID, txtPW: $signUpPW, isNeedName: $isNeedName)
                    .frame(width: UIScreen.screenWidth)
                SetNameView(isNeedSignUp: $isNeedSignup, userName: $txtUserName, txtID: $signUpID, txtPW: $signUpPW)
                    .frame(width: UIScreen.screenWidth)
            }
            .offset(x: isNeedSignup ? isNeedName ? -UIScreen.screenWidth - 8:0:UIScreen.screenWidth + 8)
            .animation(.easeInOut)
            Spacer()
            HStack {
                Text(isNeedSignup ? "이미 PRAGO 회원이신가요?":"아직 PRAGO 회원이 아니신가요?")
                    .foregroundColor(Color.white)
                    .font(.system(size: 12))
                Button(isNeedSignup ? "로그인":"회원가입") {
                    self.isNeedSignup.toggle()
                    self.isNeedName = false
                }
                .foregroundColor(Color.white)
                .font(.system(size: 13))
                .padding(.leading, -4)
            }
            .animation(.easeInOut)
            .padding(.bottom, 60)
        }
        .frame(width: UIScreen.screenWidth)
        .background(LinearGradient.init(gradient: Gradient(colors: [Color("BackgroundStartColor"), Color("BackgroundFinishColor")]), startPoint: .top, endPoint: .bottom)
        .edgesIgnoringSafeArea(.all))
    }
}

struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        SigninView(isSignIn: .constant(false))
    }
}

struct AuthModel: Codable{
    let accessToken: String
    let refreshToken: String?
}

struct SigninSubView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var txtID: String
    @Binding var txtPW: String
    @Binding var isNeedName: Bool
    
    @Binding var isSignIn: Bool
    
    var body: some View {
        VStack{
            TextField("ID", text: $txtID)
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .keyboardType(.emailAddress)
            Rectangle()
                .frame(width: UIScreen.screenWidth - 64, height: 1)
                .foregroundColor(Color.white)
                .padding(.top, -4)
                .padding(.bottom, 32)
            SecureField("PW", text: $txtPW)
                .foregroundColor(.white)
                .padding(.horizontal, 32)
            Rectangle()
                .frame(width: UIScreen.screenWidth - 64, height: 1)
                .foregroundColor(Color.white)
                .padding(.top, -4)
                .padding(.bottom, 32)
            if txtID == "" || txtPW == "" {
                Text("로그인")
                    .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
            } else {
                Button("로그인") {
                    self.postData()
                }
                .foregroundColor(Color.white)
            }
        }
    }
    
    func postData() {
        _ = Connector.instance
            .getRequest(MainAPI.signIn, method: .post, params: getParam())
            .decodeData(AuthModel.self)
            .subscribe(onNext: { [self] code, str, data in
                switch code{
                case 200:
                    print(data)
                    self.isSignIn = true
                    self.presentationMode.wrappedValue.dismiss()
                case 204: print(code)
                default: print(code)
                }
            })
    }
    
    func getParam() -> [String : String] {
        var param = [String : String]()
        param["user_id"] = txtID
        param["password"] = txtPW
        return param
    }
}

struct SignupSubView: View {
    @State private var txtPWC = ""
    
    @Binding var txtID: String
    @Binding var txtPW: String
    @Binding var isNeedName: Bool
    
    var body: some View {
        VStack{
            TextField("ID", text: $txtID)
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .keyboardType(.emailAddress)
            Rectangle()
                .frame(width: UIScreen.screenWidth - 64, height: 1)
                .foregroundColor(Color.white)
                .padding(.top, -4)
                .padding(.bottom, 32)
            SecureField("PW", text: $txtPW)
                .foregroundColor(.white)
                .padding(.horizontal, 32)
            Rectangle()
                .frame(width: UIScreen.screenWidth - 64, height: 1)
                .foregroundColor(Color.white)
                .padding(.top, -4)
                .padding(.bottom, 32)
            SecureField("PW Check", text: $txtPWC)
                .foregroundColor(.white)
                .padding(.horizontal, 32)
            Rectangle()
                .frame(width: UIScreen.screenWidth - 64, height: 1)
                .foregroundColor(Color.white)
                .padding(.top, -4)
            if txtPW != txtPWC {
                HStack {
                    Text("다시 확인해주세요")
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                        .padding(.top, -6)
                        .padding(.leading, 32)
                    Spacer()
                }
            }
            if (txtID == "" || txtPW == "" || txtPWC == "") && (txtPW != txtPWC) {
                Text("다음으로")
                    .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                    .padding(.top, 60)
            } else {
                Button("다음으로") {
                    self.isNeedName.toggle()
                }
                .foregroundColor(Color.white)
                .padding(.top, 60)
            }
        }
    }
}

struct SetNameView: View {
    
    @Binding var isNeedSignUp: Bool
    @Binding var userName: String
    @Binding var txtID: String
    @Binding var txtPW: String
    
    var body: some View {
        VStack{
            TextField("Name", text: $userName)
                .foregroundColor(.white)
                .padding(.horizontal, 32)
            Rectangle()
                .frame(width: UIScreen.screenWidth - 64, height: 1)
                .foregroundColor(Color.white)
                .padding(.top, -4)
                .padding(.bottom, 32)
            if userName == "" {
                Text("회원가입")
                    .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
            } else {
                Button("회원가입") {
                    self.postData()
                }
                .foregroundColor(Color.white)
            }
        }
    }
    
    func postData() {
        print("\(userName) \(txtID) + \(txtPW)")
    _ = Connector.instance
        .getRequest(MainAPI.signUp, method: .post, params: ["user_id": "\(txtID)", "name": "\(userName)", "password": "\(txtPW)"])
        .decodeData(AuthModel.self)
        .subscribe(onNext: { [self] code, str, data in
            switch code{
            case 201:
                self.isNeedSignUp = false
                print(data)
            case 204: print(code)
            default: print(code)
            }
        })
    }
}
