//
//  ModifyDirectionView.swift
//  Cookcademy
//
//  Created by Joel Alejandro Milla Lopez on 02/12/23.
//

import SwiftUI

struct ModifyDirectionView: View {
    @Binding var direction: Direction
    let createAction: (Direction) -> Void
    
    private let listBackgroundColor = AppColor.background
    private let listTextColor = AppColor.foreground
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            TextField("Direction description", text: $direction.description)
                .listRowBackground(listBackgroundColor)
            Toggle(isOn: $direction.isOptional) {
                Text("Optional")
            }
            .listRowBackground(listBackgroundColor)
            
            HStack {
                Spacer()
                Button {
                    createAction(direction)
                    dismiss()
                } label: {
                    Text("Save")
                }
                Spacer()
            }
            .listRowBackground(listBackgroundColor)
        }
        .foregroundColor(listTextColor)
    }
}

struct ModifyDirectionView_Previews: PreviewProvider {
    @State static var emptyDirection = Direction(description: "", isOptional: false)
    static var previews: some View {
        NavigationStack {
            ModifyDirectionView(direction: $emptyDirection, createAction: {_ in })
        }
    }
}
