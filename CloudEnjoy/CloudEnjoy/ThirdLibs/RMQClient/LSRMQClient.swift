//
//  LSRMQClient.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/4/20.
//

import Foundation
import RMQClient
import LSBaseModules
import HandyJSON




class LSRMQClient {
    static let client = LSRMQClient()
    
    var conn: RMQConnection?
    var delegate: RMQConnectionDelegateLogger!
    
    class func install(rabbitaddress: String, rabbitport: String) {
        self.unInstall()
        let url = "amqp://byyzm:byyzm@\(rabbitaddress):\(rabbitport)"
        client.conn = RMQConnection(uri: url, delegate: RMQConnectionDelegateLogger())
        
        let queueName = storeModel().account + "-" + userModel().userid + "-" + machModel().code
        let exchangeName = "yxx"
        
        client.conn?.start()
        let ch = client.conn?.createChannel()
        ch?.queue(queueName)
        ch?.queueBind(queueName, exchange: exchangeName, routingKey: "yxx")
        ch?.queueBind(queueName, exchange: exchangeName, routingKey: "yxx" + storeModel().account)
        ch?.queueBind(queueName, exchange: exchangeName, routingKey: "yxx" + storeModel().account + "." + userModel().userid)
        ch?.queueBind(queueName, exchange: exchangeName, routingKey: "yxx" + storeModel().account + "." + userModel().userid + "." + machModel().code)
        ch?.basicConsume(queueName, handler: { message in
            self.handerMessage(LSMQMessageModel.deserialize(from: message.body.string(encoding: .utf8)))
        })
    }
    
    class func handerMessage(_ message: LSMQMessageModel?) {
        guard let notification = message?.retcode.notification else {
            return
        }
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: notification, object: nil)
        }
    }

    class func unInstall() {
        if (client.conn != nil) {
            client.conn?.close()
            client.conn = nil
        }
    }
}

enum LSMessageType: Int, HandyJSONEnum {
    case heartbeat = 1
    case dispatchOrder = 669
    case updateYuyueStatus = 668
    case upClock = 673
    case downClock = 674
    case updateUserStatus = 672
    case changeProject = 680
    case returnProject = 679
    case otherLogin = 660
    
    var notification: NSNotification.Name? {
        switch self {
        case .dispatchOrder:
            return LSRMQNotification.dispatchOrder
        case .updateYuyueStatus:
            return LSRMQNotification.updateYuyueStatus
        case .upClock:
            return LSRMQNotification.upClock
        case .downClock:
            return LSRMQNotification.downClock
        case .updateUserStatus:
            return LSRMQNotification.updateUserStatus
        case .changeProject:
            return LSRMQNotification.changeProject
        case .returnProject:
            return LSRMQNotification.returnProject
        case .otherLogin:
            return LSRMQNotification.otherLogin
        default: return nil
        }
    }
}


struct LSRMQNotification{
    static let dispatchOrder = Notification.Name("LSRMQ.dispatchOrder")
    static let updateYuyueStatus = Notification.Name("LSRMQ.updateYuyueStatus")
    static let upClock = Notification.Name("LSRMQ.upClock")
    static let downClock = Notification.Name("LSRMQ.downClock")
    static let updateUserStatus = Notification.Name("LSRMQ.updateUserStatus")
    static let changeProject = Notification.Name("LSRMQ.changeProject")
    static let returnProject = Notification.Name("LSRMQ.returnProject")
    static let otherLogin = Notification.Name("LSRMQ.otherLogin")
}

struct LSMQMessageModel: HandyJSON {
    var data = ""
    var dbid = ""
    var otherdata = ""
    var requesttime = ""
    var responsetime = ""
    var retcode = LSMessageType.heartbeat
    var retmsg = ""
    var runtime = ""
    var server = ""
    var sid = ""
    var spid = ""
}
