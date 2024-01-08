//
//  ModifyDirectionView.swift
//  Cookacademy
//
//  Created by Enzo Luigi Schork on 29/12/23.
//

import SwiftUI

struct ModifyDirectionView: ModifiableComponentView {
    @Binding var direction: Direction
    let createAction: (Direction) -> Void
    
    init(component: Binding<Direction>, createAction: @escaping (Direction) -> Void) {
        self._direction = component
        self.createAction = createAction
    }
    
    private let listBackgroundColor = AppColor.background
    private let listTextColor = AppColor.foreground
    
    @Environment(\.presentationMode) private var mode
    
    var body: some View {
        Form {
            TextField("Direction Description", text: $direction.description)
                .listRowBackground(listBackgroundColor)
            Toggle("Optional", isOn: $direction.isOptional)
                .listRowBackground(listBackgroundColor)
            HStack {
                Spacer()
                Button("Save") {
                    createAction(direction)
                    mode.wrappedValue.dismiss()
                }
                Spacer()
            }
            .listRowBackground(listBackgroundColor)
        }
        .foregroundColor(listTextColor)
    }
}

struct ModifyDirectionView_Previews: PreviewProvider {
    @State static var recipe = Recipe.testRecipes[0]
    
    static var previews: some View {
        NavigationView {
            ModifyDirectionView(component: $recipe.directions[0]) { direction in
                print(direction)
            }
        }
    }
}
