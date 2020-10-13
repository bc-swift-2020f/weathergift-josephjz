//  APIkeys.swift
//  The Weather Gift App

import Foundation

// pasting API Key here
// create a struct with a constant in it so we don't have to type in API key like a literal
// restricting this file so that it won't get uploaded to GitHub

struct APIkeys {
    
    // by creating this using static instead of var allows us to just refer to type APIkeys and then say . and name of struct (won't need to create a variable with a struct instance)
    //      just refer to APIkeys.googlePlacesKey
    
    static let googlePlacesKey = "AIzaSyDq9fBF-FwL8k6Q3wH_5qrJRf-z0JNoIvw"
    
    static let openWeatherKey = "aa41d5ba29e5ca8f734fb35456d61799"
}
