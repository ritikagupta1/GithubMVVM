//
//  GFError.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 05/03/25.
//

import Foundation
enum GFError: String, Error {
    case invalidUserName = "This username created an invalid request, Please try again later."
    case unableToCompleteRequest = "Unable to complete your request, Please Check your Internet Connection."
    case invalidResponse = "Invalid Response from server,Please try again."
    case invalidData = "The data received from the server was invalid.Please try again."
    case unableToFavourites = "Unable to Favourite.Please try again"
    case alreadyAddedToFavourites = "User is already marked as favourite.You must really like them 😄"
}
