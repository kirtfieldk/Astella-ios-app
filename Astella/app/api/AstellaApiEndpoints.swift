//
//  AstellaApiEndpoints.swift
//  Astella
//
//  Created by Keith Kirtfield on 4/29/23.
//

import Foundation


enum AstellaEndpoints: String, Codable, CaseIterable {
    case GET_EVENT_BY_ID, ADD_USER_TO_EVENT  = "event/"
    case CREATE_EVENT  = "event"
    case GET_EVENT_BY_CITY  = "event/city"
    case POST_MESSAGE_TO_EVENT  = "message/post/"
    case GET_MESSAGE_IN_EVENT  = "message/event/"
    case LIKE_MESSAGE_IN_EVENT  = "message/event/upvote/"
    case UNLIKE_MESSAGE_IN_EVENT = "message/event/downvote/"
    case GET_EVENTS_MEMBER_OF  = "user/event/member/"
    case GET_EVENTS_MEMBER  = "member/user/event/"
    case GET_USRS_LIKE_MESSAGE  = "message/event/whoupvote/"
    case PIN_MESSAGE = "event/pin/message/"
    case UNPIN_MESSAGE = "event/unpin/message/"
    case GET_USER_PIN = "event/user/pin/message/"
    case GET_MESSAGE_THREAD = "event/message/thread/"
}
    

struct AstellaUrlIds : Hashable {
    let userId : String
    let eventId : String
    let messageId : String
    
    static var emptyUrlIds = AstellaUrlIds(userId: "", eventId: "", messageId: "")
}
