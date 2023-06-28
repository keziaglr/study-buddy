//
//  ChatTemp.swift
//  studybuddy
//
//  Created by Kezia Gloria on 24/06/23.
//

import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

final class MessageManager: ObservableObject {
    
    @Published private(set) var chats : [Chat] = []
    @Published private(set) var lastmessageID = ""
    @Published private var um = UserManager()
    
    let db = Firestore.firestore()
    
    func getChats(communityID: String) -> [Chat]{
        db.collection("communities").document(communityID).collection("chats").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching data \(String(describing: error))")
                return
            }
            
            self.chats = documents.compactMap{ document -> Chat? in
                do{
                    return try document.data(as : Chat.self)
                }catch{
                    print("Error decoding document into message \(String(describing: error))")
                    return nil
                }
            }
            
            self.chats.sort{ $0.dateCreated < $1.dateCreated}
            
            if let id = self.chats.last?.id {
                self.lastmessageID = id
            }
            
        }
        return chats
    }
    
    func sendChats(text: String, communityID: String){
        um.getUser(id: Auth.auth().currentUser?.uid ?? "") { user in
            if let user = user {
                let newChat = Chat(id: "\(UUID())", content: text, dateCreated: Date(), user: user.id)
                
                do {
                    try self.db.collection("communities").document(communityID).collection("chats").document(newChat.id).setData(from: newChat)
                } catch {
                    print("Error sending chat: \(error)")
                }
            } else {
                print("Failed to retrieve user")
            }
        }

    }
    
}

 

class BadgeManager: ObservableObject {
    
    @Published var badges = [Badge]()
    @Published private var um = UserManager()
    
    var db = Firestore.firestore()
    
    init() {
        getBadges()
    }
    
    func validateBadge(badgeId: String, completion: @escaping (Bool) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }

        um.getUser(id: currentUserID) { user in
            var isValid = false
            if let currUser = user {
                isValid = currUser.badges.contains(badgeId)
            }

            completion(isValid)
        }
    }
    
    func getBadge(id: String, completion: @escaping (Badge?) -> Void){
        db.collection("badges").document(id).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error getting community: \(error)")
                completion(nil)
                return
            }
            
            guard let document = documentSnapshot else {
                print("Badges document does not exist")
                completion(nil)
                return
            }
            
            if document.exists {
                let data = document.data()
                let documentID = document.documentID
                let name = data?["name"] as? String ?? ""
                let image = data?["image"] as? String ?? ""
                let description = data?["description"] as? String ?? ""
                let badge = Badge(id: documentID, name: name, image: image, description: description)
                
                print("Retrieved user: \(badge)")
                completion(badge)
            } else {
                print("User document does not exist")
                completion(nil)
            }
        }
    }
    
    func achieveBadge(badgeId: String){
        um.getUser(id: Auth.auth().currentUser?.uid ?? "") { [self] user in
            let collectionRef = db.collection("users")
            let documentRef = collectionRef.document(user?.id ?? "")
            documentRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let data = document.data(), let existingArray = data["badges"] as? [String] {
                        var newArray = existingArray
                        newArray.append(badgeId)
                        
                        documentRef.updateData(["badges": newArray]) { error in
                            if let error = error {
                                print("Error updating array: \(error.localizedDescription)")
                            } else {
                                print("Array updated successfully")
                            }
                        }
                    } else {
                        print("Existing array not found in the document")
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    func getBadges(){
        db.collection("badges").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching data \(String(describing: error))")
                return
            }
            
            self.badges = documents.compactMap{ (queryDocumentSnapshot) -> Badge in
                let documentID = queryDocumentSnapshot.documentID
                let data = queryDocumentSnapshot.data()
                let name = data["name"] as? String ?? ""
                let image = data["image"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                return Badge(id: documentID, name: name, image: image, description: description)
            }
        }
    }
}


struct ChatTemp: View {
    @ObservedObject var manager : MessageManager
    @State var communityID : String = "A0grBMs808NJcvvnQjLE"
    
    var body: some View {
        VStack{
            VStack{
                ScrollViewReader { proxy in
                    ScrollView{
                        if manager.chats.count != 0 {
                            ForEach(manager.chats, id: \.id) {
                                message in
                                Bubble(message: message)
                                    .onAppear{
                                        print("\(message)")
                                    }
                            }
                        }else{
                            Text("Empty messages")
                        }

                    }.padding()
                    .task {
                        manager.getChats(communityID: communityID)
                    }
                    .onChange(of: manager.lastmessageID) { id in
                        proxy.scrollTo(id, anchor: .bottom)
                    }

                }
                Field(communityID: communityID)
                    .environmentObject(manager)
                    
            }
        }
    }
}

struct Field: View {
    @EnvironmentObject var manager : MessageManager
    @State var messages = ""
    @State var communityID = ""
    
    var body: some View {
        HStack{
            CTextfield(placeholder: Text("Enter Message"), text: $messages)
            Button{
                manager.sendChats(text: messages, communityID: communityID)
                messages = ""
            }label: {
    
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color(.black))
                    .cornerRadius(50)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color(.gray))
        .cornerRadius(30)
    }
}

struct Bubble: View {
    var message: Chat
    @State private var um = UserManager()
    @State private var showTime = false
    @State private var user: UserModel? = nil
    var body: some View {
        VStack(alignment: Auth.auth().currentUser?.uid != message.user ? .leading : .trailing ){
            HStack{
                VStack {
                    if let user = user {
                        Text(user.name)
                    } else {
                        Text("")
                    }
                }
                .task {
                    um.getUser(id: message.user) { retrievedUser in
                        self.user = retrievedUser
                    }
                }

                Text(message.content)
                    .padding()
                    .background(Auth.auth().currentUser?.uid != message.user ? Color(.gray) : Color(.red))
                    .cornerRadius(30)
            }
            .frame(maxWidth: 300, alignment: Auth.auth().currentUser?.uid != message.user ? .leading : .trailing)
            .onTapGesture {
                showTime.toggle()
            }
            if showTime {
                Text("\(message.dateCreated.formatted(.dateTime.hour().minute()))")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(Auth.auth().currentUser?.uid != message.user ? .leading : .trailing , 25)
            }
        }.frame(maxWidth: .infinity, alignment: Auth.auth().currentUser?.uid != message.user ? . leading : .trailing)
            .padding(Auth.auth().currentUser?.uid != message.user ? .leading : .trailing)
            .padding(.horizontal, 10)
    }
}

struct CTextfield: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool) -> () = {_ in}
    var commit: () -> () = {}
    
    var body: some View{
        ZStack(alignment: .leading){
            if text.isEmpty{
                placeholder
                    .opacity(0.5)
            }
            
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}


//struct ChatTemp_Previews: PreviewProvider {
//    static var previews: some View {
//        Bubble(message: Chat(id: "", content: "halo", dateCreated:", user: <#T##UserModel#>))
//    }
//}
