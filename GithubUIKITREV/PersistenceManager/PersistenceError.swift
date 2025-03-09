//
//  PersistenceError.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 09/03/25.
//

import Foundation

enum PersistenceError: String, Error {
    case unableToFavourites = "Unable to Favourite.Please try again"
    case alreadyAddedToFavourites = "User is already marked as favourite.You must really like them 😄"
}
