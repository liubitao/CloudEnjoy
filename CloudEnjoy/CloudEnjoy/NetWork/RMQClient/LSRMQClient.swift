//
//  LSRMQClient.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/4/20.
//

import Foundation
import RMQClient
import LSBaseModules
import SmartCodable




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
        
        ch?.queue(queueName, options: .autoDelete)
        ch?.queueBind(queueName, exchange: exchangeName, routingKey: "yxx")
        ch?.queueBind(queueName, exchange: exchangeName, routingKey: "yxx." + storeModel().account + "." + userModel().userid + "." + machModel().code)
        ch?.basicConsume(queueName, handler: { message in
            self.handerMessage(LSMQMessageModel.deserialize(from: message.body.string(encoding: .utf8)))
        })
    }
    
    class func handerMessage(_ message: LSMQMessageModel?) {
        guard let notification = message?.retcode.notification else{
            return
        }
        DispatchQueue.main.async {
            if let audioName = message?.retcode.audioName {
                LSAudioQueueManager.shared.enqueueToQueue(LSAudioOperation(audioName: audioName))
            }
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

enum LSMessageType: Int, SmartCaseDefaultable {
    case heartbeat = 1
    case dispatchOrder = 669
    case updateYuyueStatus = 668
    case upClock = 673
    case downClock = 674
    case updateUserStatus = 672
    case changeProject = 680
    case returnProject = 679
    case otherLogin = 660
    case autoCancelOrder = 681
    
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
        case .autoCancelOrder:
            return LSRMQNotification.autoCancelOrder
        default: return nil
        }
    }
    
    var audioName: String? {
        switch self {
        case .dispatchOrder:
            return "你有新的派工消息（收银端派工后，对应技师员工端收到提醒）"
        case .updateYuyueStatus:
            return "您有新的预约订单（收银端或技师端提交预约后，对应技师员工端收到提醒）"
        case .upClock:
            return "本次项目已开始上钟很高兴为您（收银端或技师端点击上钟后提醒）"
        case .downClock:
            return "本次项目已下钟期待您的下次光(收银端或技师端点击下钟后提醒)"
        case .updateUserStatus:
            return nil
        case .changeProject:
            return nil
        case .returnProject:
            return nil
        case .otherLogin:
            return nil
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
    static let autoCancelOrder = Notification.Name("LSRMQ.autoCancelOrder")
}

struct LSMQMessageModel: SmartCodable {
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
