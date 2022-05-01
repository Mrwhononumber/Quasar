//
//  QuasarError.swift
//  Quasar
//
//  Created by Basem El kady on 3/5/22.
//

import Foundation

enum QuasarError: String, Error {
 
    /// Networking
    
    case invalidURL          = "The URL you're using is invalid"
    case unableToComplete    = "Unable to complete your request, please check your internet connection"
    case invalidResponse     = "Invalid response from the server, please try again"
    case invalidData         = "The data received from the server is invalid, please try again"
  
    /// Core Data
    
    case savingDataFailure    = "Error happened while saving your data, please try again"
    case loadingDataFailure   = "Error happened while rloading your data, please try again"
    case deletingDataFailure  = "Error happened while Deleting data, please try again"
    case dataRetrivingFailure = "Error happened while retriving data, please try again"
}
