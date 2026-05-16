//
//  RegisterView.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 11/03/26.
//

import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @FocusState private var focusedField: Field?
    @Binding var showLoginView: Bool
    var contentType: UITextContentType? {
        switch focusedField {
        case .email:
            return .emailAddress
        case .password:
            return .password
        case .fullName:
            return .name
        case .passwordConfirmation:
            return .password
        case .none:
            return .name
        }
    }
    var body: some View {
        VStack(spacing: 32) {
            ForEach(Field.allCases, id:\.self) { field in
                TextField(field.rawValue, text: authViewModel.textBinding(field: field))
                    .foregroundStyle(Color.nsTextPrimary)
                    .textContentType(contentType)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never) 
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.border)
                            .stroke(Color.nsAccentPrimary, lineWidth: focusedField == field ? 2 : 0)
                    )
                    .focused($focusedField, equals: field)
            }
            
            AuthButtonComponent(title: "Create Account") {
                Task {
                    do {
                        try await authViewModel.createEmailAccount()
                        showLoginView = false
                    } catch {
                        print(error)
                    }
                }
            }
            
            HStack() {
                Text("Have an account?")
                
                Button("Singin Here"){
                    showLoginView = false
                }
                .foregroundColor(Color.orangePrimary)
                .underline()
                .buttonStyle(.plain)
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .padding(.top, 32)
        .padding(.horizontal)
        .navigationTitle("Daftar Akun")
    }
}

#Preview {
    NavigationStack {
        RegisterView(showLoginView: .constant(true))
            .environmentObject(AuthViewModel())
    }
}
