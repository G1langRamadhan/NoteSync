//
//  LoginView.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 11/03/26.
//

import SwiftUI
import FirebaseAuth
import GoogleSignInSwift
import AuthenticationServices

struct LoginView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var email: String = ""
    @State var showRegisterView: Bool = false
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack (spacing: 20){
            Image(systemName: "pencil.and.scribble")
                .resizable()
                .frame(width: 40, height: 40)
                .padding(25)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.nsAccentPrimary)
                )
            
            Text("NoteSync")
                .font(Font.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(Color.nsTextPrimary)
            
            VStack(spacing: 10) {
                TextField("Email", text: $authViewModel.email)
                .foregroundStyle(Color.nsTextSecondary)
                .textContentType(.emailAddress)
                .padding(25)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.border)
                        .stroke(Color.nsAccentPrimary, lineWidth: focusedField == .email ? 2 : 0)
                )
                .focused($focusedField, equals: .email)
                
                TextField("Password", text: $authViewModel.password)
                .foregroundStyle(Color.nsTextSecondary)
                .textContentType(.password)
                .padding(25)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.border)
                        .stroke(Color.nsAccentPrimary, lineWidth: focusedField == .password ? 2 : 0)
                )
                .focused($focusedField, equals: .password)
            }
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            
            VStack(spacing: 10) {
                ButtonAuthComponent(title: "SignIn") {
                    Task {
                        do {
                            try await authViewModel.loginEmailAccount()
                            authViewModel.email = ""
                            authViewModel.password = ""
                        } catch {
                            print(error)
                        }
                    }
                }
                .disabled(authViewModel.email.isEmpty || authViewModel.password.isEmpty)
                
                Text("or")
                
                GoogleSignInButton(scheme: .dark, style: .standard, state: .normal) {
                    Task {
                        do {
                            try await authViewModel.signInWithGoogle()
                        } catch {
                            print(error)
                        }
                    }
                }
                
                Button {
                    Task {
                        do {
                            try await authViewModel.sigInWithApple()
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    signInWithAppleButtonUIrepresentable(buttonType: .signIn, buttonStyle: .white)
                }
                .frame(height: 55)

                HStack() {
                    Text("Dont have an account?")
                    
                    Button("SingUp Here"){
                        showRegisterView = true
                    }
                    .underline()
                    .buttonStyle(.plain)
                }
                .padding(.top, 10)
            }
        }
        .fullScreenCover(isPresented: $showRegisterView, content: {
            RegisterView(showLoginView: $showRegisterView)
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 20)
    }
}

#Preview {
    LoginView()
}
