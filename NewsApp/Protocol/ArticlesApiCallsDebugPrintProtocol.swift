//
//  ArticlesApiCallsDebugPrintProtocol.swift
//  NewsApp
//
//  Created by khalil on 23/10/22.
//

import Foundation

protocol ArticlesApiCallsDebugPrintProtocol { }

extension ArticlesApiCallsDebugPrintProtocol {
    func articlesApiCallsDebugPrint(type: ArticlesApiCallsDebugPrintType, callType: NewsArticlesCallType, dataToPrint: String?) {
        /*🔴​🟠​🟡​🟢​🔵​🟣​​⚫️⚪️​🟤​🟠*/
        
        switch type {
        case .startCalling:
            debugPrint("##### CALLING API TYPE -> \(callType) -> \(Date())")
            guard let dataToPrint = dataToPrint else {
                debugPrint("🔵##### CALLING API URL -> \(dataToPrint)")
                return
            }
            debugPrint("🔵##### CALLING API URL -> \(dataToPrint)")
            
        case .successResult:
            debugPrint("##### RESULT API TYPE -> \(callType) -> \(Date())")
            guard let dataToPrint = dataToPrint else { return }
            debugPrint("🟢​##### SUCCESS RESPONSE COUNT -> \(dataToPrint))")
            
        case .errorResult:
            debugPrint("##### RESULT API TYPE -> \(callType) -> \(Date())")
            guard let dataToPrint = dataToPrint else { return }
            debugPrint("🔴##### ERROR -> \(dataToPrint)")
        }
        debugPrint("**--------------------​----------------------------**")
    }
}
