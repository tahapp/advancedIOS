//
//  User.swift
//  AutoLayout
//
//  Created by ben hussain on 7/11/23.
//


import Foundation
struct User
{
    var name: String
    var company: String
    var login: String
    var password: String
    static let usersDataBase =
    [
        User(name: "John Appleseed", company: "Apple", login: "japple", password: "foo"),
        User(name: "Madison Bumgarner", company: "World Champion San Francisco Giants", login: "madbum", password: "foo"),
        User(name: "John Hennessy", company: "Stanford", login: "hennessy", password: "foo"),
        User(name: "Bad Guy", company: "Criminals, Inc.", login: "baddie", password: "foo"),
    ]
    static func login(login: String, password: String) -> User?
    {
        if let user = database[login.trimmingCharacters(in: .whitespaces)]
        {
            if user.password == password
            {
                return user
            }
            
        }
        
        return nil
    }
    static let database: Dictionary<String, User> = {
        var theDatabase = Dictionary<String, User>()
        for user in usersDataBase
        {
            theDatabase[user.login] = user
        }
        
        return theDatabase
        
    }()
}

