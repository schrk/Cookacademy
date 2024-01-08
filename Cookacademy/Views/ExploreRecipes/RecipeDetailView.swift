//
//  RecipeDetailView.swift
//  Cookacademy
//
//  Created by Enzo Luigi Schork on 22/12/23.
//

import SwiftUI

struct RecipeDetailView: View {
    @AppStorage("hideOptionalDirections") private var hideOptionalDirections: Bool = false
    
    @Binding var recipe: Recipe
    
    private let listBackgroundColor = AppColor.background
    private let listTextColor = AppColor.foreground
    
    @State private var isPresenting = false
    @EnvironmentObject private var recipeData: RecipeData
    
    var body: some View {
        VStack {
            HStack{
                Text("Author: \(recipe.mainInformation.author)")
                    .font(.subheadline)
                    .padding()
                Spacer()
            }
            HStack {
                Text(recipe.mainInformation.description)
                    .font(.subheadline)
                    .padding()
                Spacer()
            }
            List{
                Section(header: Text("Ingredients")) {
                    ForEach(recipe.ingredients.indices, id: \.self) { index in
                        let ingredient = recipe.ingredients[index]
                        Text(ingredient.description)
                            .foregroundColor(listTextColor)
                    }
                }
                .listRowBackground(listBackgroundColor)
                Section(header: Text("Directions")) {
                    ForEach(recipe.directions.indices, id: \.self) { index in
                        let direction = recipe.directions[index]
                        if direction.isOptional && hideOptionalDirections {
                            EmptyView()
                        } else {
                            HStack {
                                let index = recipe.index(of: direction, excludingOptionalDirections: hideOptionalDirections) ?? 0
                                Text("\(index + 1)").bold()
                                Text("\(direction.isOptional ? "(Optional) " : "")\(direction.description)")
                            }
                            .foregroundColor(listTextColor)
                        }
                    }
                }
                .listRowBackground(listBackgroundColor)
            }
        }
        .navigationTitle(recipe.mainInformation.name)
        .toolbar {
            ToolbarItem {
                HStack {
                    Button("Edit") {
                        isPresenting = true
                    }
                    Button(action: {
                        recipe.isFavorite.toggle()
                    }) {
                        Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                    }
                }
            }
            ToolbarItem(placement: .navigationBarLeading) { Text("") }
        }
        .sheet(isPresented: $isPresenting) {
            NavigationView {
                ModifyRecipeView(recipe: $recipe)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                isPresenting = false
                            }
                        }
                    }
                    .navigationTitle("Edit Recipe")
            }
            .onDisappear {
                recipeData.saveRecipes()
            }
        }
    }
}

struct RecipeDetailView_Preview: PreviewProvider {
    @State static var recipe = Recipe.testRecipes[1]
    static var previews: some View {
        NavigationView {
            RecipeDetailView(recipe: $recipe)
        }
    }
}
