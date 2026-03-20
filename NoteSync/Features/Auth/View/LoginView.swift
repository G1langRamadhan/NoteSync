//
//  LoginView.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 11/03/26.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var email: String = ""
    @State var showRegisterView: Bool = false
    @FocusState private var focusedField: Field?
    @State var isEmailInvalid: Bool = false
    
    var body: some View {
        VStack (spacing: 20){
            Image(systemName: "pencil.and.scribble")
                .resizable()
                .frame(width: 40, height: 40)
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.nsAccentPrimary)
                )
            
            Text("NoteSync")
                .font(Font.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(Color.nsTextPrimary)
            
            VStack(alignment: .leading, spacing: 10) {
                TextField("Email", text: $authViewModel.email)
                    .textContentType(.emailAddress)
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
            }
            .foregroundStyle(Color.nsTextPrimary)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            
            VStack(spacing: 10) {
                AuthButtonComponent(title: "SignIn") {
                    try await authViewModel.loginEmailAccount()
                }
                .disabled(authViewModel.email.isEmpty || authViewModel.password.isEmpty)
                
                Text("or")
                
                AuthButtonComponent(title: "SignIn With Google") {
                    try await authViewModel.signInWithGoogle()
                }
                AuthButtonComponent(title: "SignIn With Apple") {
                    try await authViewModel.sigInWithApple()
                }
                
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
    
    func isValidEmail(_ email: String) -> Bool {
        let regex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/
        return email.wholeMatch(of: regex) != nil
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
