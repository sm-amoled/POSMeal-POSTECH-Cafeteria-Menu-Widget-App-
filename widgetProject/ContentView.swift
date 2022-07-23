//
//  ContentView.swift
//  widgetProject
//
//  Created by Kim Insub on 2022/05/04.
//

import SwiftUI

struct ContentView: View {
    //Define
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var network: Network
    @AppStorage("isFirstLaunching") var isFirstLaunching: Bool = true
    @State private var showSheet = false
    @State private var selectedMeal = "ONTIME"


    init(){
        UIPageControl.appearance().currentPageIndicatorTintColor = Color.currentPageIndicatorTintColor
        UIPageControl.appearance().pageIndicatorTintColor = Color.pageIndicatorTintColor
    }

    var body: some View {
        
        NavigationView {
            TabView{
                MenuView(date: "today", menuIndex: 0)
                MenuView(date: "tomorrow", menuIndex: 1)
                MenuView(date: "dayAfterTomorrow", menuIndex: 2)
            }
            .onAppear{
                // Lock on Portrait Mode
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                AppDelegate.orientationLock = .portrait
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .background(Color.backgroundColor)
            .navigationBarHidden(true)
            .toolbar{
                ToolbarItemGroup(placement: ToolbarItemPlacement.bottomBar){
                    //WIDGET CONFIG BUTTON
                    Button{
                        self.showSheet = true
                    } label: {
                        Text("위젯설정")
                    }
                }
            }
            //WIDGET CONFIG : SELECT MEAL
            .confirmationDialog("위젯에 보일 정보를 선택하세요", isPresented: self.$showSheet, titleVisibility: .visible){
                Button("조식"){
                    self.selectedMeal = "BREAKFAST_A"
                    UserDefaults(suiteName: "group.com.kim.widgetProject")!.set(self.selectedMeal, forKey: "SELECTEDMEAL")
                }
                Button("간단식"){
                    self.selectedMeal = "BREAKFAST_B"
                    UserDefaults(suiteName: "group.com.kim.widgetProject")!.set(self.selectedMeal, forKey: "SELECTEDMEAL")
                }
                Button("중식"){
                    self.selectedMeal = "LUNCH"
                    UserDefaults(suiteName: "group.com.kim.widgetProject")!.set(self.selectedMeal, forKey: "SELECTEDMEAL")
                }
                Button("석식"){
                    self.selectedMeal = "DINNER"
                    UserDefaults(suiteName: "group.com.kim.widgetProject")!.set(self.selectedMeal, forKey: "SELECTEDMEAL")
                }
                Button("위즈덤"){
                    self.selectedMeal = "STAFF"
                    UserDefaults(suiteName: "group.com.kim.widgetProject")!.set(self.selectedMeal, forKey: "SELECTEDMEAL")
                }
                Button("더 블루힐"){
                    self.selectedMeal = "INTERNATIONAL"
                    UserDefaults(suiteName: "group.com.kim.widgetProject")!.set(self.selectedMeal, forKey: "SELECTEDMEAL")
                }
                Button("시간에 맞추기"){
                    self.selectedMeal = "ONTIME"
                    UserDefaults(suiteName: "group.com.kim.widgetProject")!.set(self.selectedMeal, forKey: "SELECTEDMEAL")
                }
            }
        }
        .onChange(of: scenePhase){
            newPhase in
            if newPhase == .active {
                network.getMenus(of: "today")
                network.getMenus(of: "tomorrow")
                network.getMenus(of: "dayAfterTomorrow")
                UserDefaults(suiteName: "group.com.kim.widgetProject")!.set(self.selectedMeal, forKey: "SELECTEDMEAL")
            }
        }
        .onAppear{
            network.getMenus(of: "today")
            network.getMenus(of: "tomorrow")
            network.getMenus(of: "dayAfterTomorrow")
            UserDefaults(suiteName: "group.com.kim.widgetProject")!.set(self.selectedMeal, forKey: "SELECTEDMEAL")
        }
        .fullScreenCover(isPresented: self.$isFirstLaunching){
            OnBoardingTabView(isFirstLaunching: self.$isFirstLaunching)
        }
    }
}
