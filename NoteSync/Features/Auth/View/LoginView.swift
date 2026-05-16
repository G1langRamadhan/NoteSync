//
//  LoginView.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 11/03/26.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State var showRegisterView: Bool = false
    @State var isEmailInvalid: Bool = false
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack (spacing: 25){
            Image("logo")
                .resizable()
                .frame(width: 100, height: 100)
            
            VStack(spacing: 10) {
                Text("Welcome to NoteSync")
                    .font(Font.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.nsTextPrimary)
                
                Text("Login to sync your notes")
            }
            
            
            VStack(alignment: .leading, spacing: 10) {
                TextField("Email", text: $authViewModel.email)
                    .textContentType(.emailAddress)
                    .foregroundStyle(Color.nsTextPrimary)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.border)
                            .stroke(isEmailInvalid ? Color.nsError : Color.nsAccentPrimary, lineWidth: focusedField == .email ? 2 : 0)
                    )
                    .focused($focusedField, equals: .email)
                    .onChange(of: authViewModel.email) { oldValue, newValue in
                        if newValue.count > 2 {
                            isEmailInvalid = !isValidEmail(newValue)
                        } else {
                            isEmailInvalid = false
                        }
                        
                        
                    }
                
                if isEmailInvalid {
                    HStack {
                        Image(systemName: "exclamationmark.triangle")
                        Text("Email tidak valid")
                    }
                    .font(.caption)
                    .foregroundStyle(.error)
                }
               
                
                TextField("Password", text: $authViewModel.password)
                    .textContentType(.password)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.border)
                            .stroke(Color.nsAccentPrimary, lineWidth: focusedField == .password ? 2 : 0)
                    )
                    .focused($focusedField, equals: .password)
                
                
                Button {
                    
                } label: {
                    Text("Forget Password?")
                        .foregroundStyle(Color.orangePrimary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .font(.subheadline)
                }

            }
            .foregroundStyle(Color.nsTextPrimary)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            
            VStack(spacing: 10) {
                AuthButtonComponent(title: "Sign In With Email") {
                    try await authViewModel.loginEmailAccount()
                }
                .disabled(authViewModel.email.isEmpty || authViewModel.password.isEmpty)
                
                DividerORView()
                    .padding(.vertical, 30)
                
                AuthButtonComponent(title: "Sign In With Google") {
                    try await authViewModel.signInWithGoogle()
                }
                AuthButtonComponent(title: "Sign In With Apple") {
                    try await authViewModel.sigInWithApple()
                }
                
                HStack() {
                    Text("Dont have an account?")
                    
                    Button("Sing Up Here"){
                        showRegisterView = true
                    }
                    .underline()
                    .foregroundStyle(Color.orangePrimary)
                    .buttonStyle(.plain)
                }
                .padding(.top, 20)
            }
        }
        .fullScreenCover(isPresented: $showRegisterView, content: {
            RegisterView(showLoginView: $showRegisterView)
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        .padding(.horizontal, 20)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let regex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/
        return email.wholeMatch(of: regex) != nil
    }
}

struct DividerORView: View {
    var body: some View {
        HStack(spacing: 16) {

            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)

            Text("OR")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Color.white.opacity(0.8))

            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
        }
        .padding(.horizontal, 24)
        .background(Color.black)
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
