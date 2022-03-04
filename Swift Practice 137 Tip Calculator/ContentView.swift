//
//  ContentView.swift
//  Swift Practice 137 Tip Calculator
//
//  Created by Dogpa's MBAir M1 on 2022/3/3.
//

import SwiftUI

struct ContentView: View {
    @State private var spentCost: Double = 0        //花費金額
    @State private var peopleToCount: Int = 2       //分母的人數在Picker的第幾的位置目前是二，所以會在Array的0/1/2 第三個的位置
    @State private var tipPercentage: Int = 10      //初始小費基準
    @FocusState private var keyboardIsFocus : Bool  //關注鍵盤類似firstResponder
    let tipPercentageArray = [0,5,10,15,20,25]      //小費總數Array用於Picker內選擇
    
    ///定義totalPerPerson為浮點數回傳每個人計算小費後的結果
    var totalPerPerson: Double {
        let peopleCount = Double(peopleToCount + 2)         //因為Picker選擇人數才是真正人數，peopleToCount是picker內的位置，所以依照差距要+2
        let grandTotal = spentCost + (spentCost / 100 * Double(tipPercentage)) //小費計算結果
        let amountPerPerson = grandTotal / peopleCount      //計算完的小費與總額除於人數
        return amountPerPerson                              //回傳每個人的計算結果
    }
    
    
    var body: some View {
        
        NavigationView{
            Form {
                Section {
                    //輸入小費金額使用，與spentCost$綁定，格式使用目前設定的貨幣，鍵盤使用數字，設置@FocusState
                    TextField("請輸入金額", value: $spentCost, format: .currency(code: Locale.current.currencyCode ?? "TWD")).keyboardType(.decimalPad).focused($keyboardIsFocus)
                    
                    //選擇總人數，selection設定在picker第$peopleToCount 順便綁定
                    //picker內透過forEach來設定人數選項
                    Picker("幾人除", selection: $peopleToCount) {
                        ForEach (2..<100) {
                            Text("\($0)人")
                        }
                    }
                }
                
                
                Section {
                    //設定小費選項的Picker，透過segmented顯示，並且與$tipPercentage綁定
                    //透過ForEach迴圈將tipPercentageArray放入Picker內顯示
                    //再透過header顯示小標題提示使用者選擇什麼
                    Picker("Tip percentage", selection: $tipPercentage) {
                            ForEach(tipPercentageArray, id: \.self) {
                                Text($0, format: .percent)
                            }
                    }.pickerStyle(.segmented)
                }
                header: {
                    Text("要給多少小費")
                }
                    
                
                Section {
                    //顯示最後計算結果，為現有使用貨幣格式，預設台灣。
                    Text(totalPerPerson, format: .currency(code: Locale.current.currencyCode ?? "TWD"))
                }
            }
            
            //設定Navigation的標題，另外設置ToolbarItemGroup內設置按鈕
            //Keyboard設定將keyboardIsFocus脫離關注
            .navigationTitle("晚餐到底多少錢").navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            keyboardIsFocus = false
                        }
                    }
                }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
