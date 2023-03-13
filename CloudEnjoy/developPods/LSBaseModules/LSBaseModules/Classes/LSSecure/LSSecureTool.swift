//
//
//  LSSecureTool.swift
//  Haylou_Fun
//
//  Created by     on 2022/5/23
//     
//


import Foundation
import CommonCrypto

public struct LSSecureTool {
    public static var AES_KEY: String = _AES_KEY()
    public static let pbServerKey = "zN28XWOifAC9uahWCNJG7KOr8FvfpUuGzJRDyvLcjoGXWOsCp7jWMjyRXAv/9NCRdxLwHC1t/4ZkAqAabkjXuGmZ/mvw3jSV0PNbeM5dChCn3tHRRPIFucu+zkYMC13blPkVlXxFQ6qO6imRwYGs4agAv1txM7+nk2F9f33kauZnNY/Qh4qnJ2EWv7R73QR5L+eUIvGCZOE2v0sIwh+Fmd+t4WeuMhr5YCc+P1eo2bc2KQN8T9+0g9T5OGGvacIK1xKsFXl1p6CTEdnkzjw+eG5+3qfekGOzSobqxmvhe7A="
    public static let prAppKey = "QbFAStVchVE/LETaXkR/s/fDCdiBLcgET9X9rY2DMRFLuuyfYwrrtix/L5j/YWogB4RDsugUANU53Q+2Ii1ge9yyVi36t80dsxEenrfuM3ifckYSNi2OfBnLaoPRQO4Gd75b0r4JfSuzycRrauIYLPsAeA5MGN5gPoUmjKs7QtSsCPYFryX0DHb+jqqW9RBkMoKqHpzFhDhdtfLYeBSnDVuKMexAH5urC+DRYMMTJCe1PDBLcGbd1EoUu+JL0RyHurbnVkRDRusz5iKuLOQ6xGpKgInz9UtKXJNuOoo1uw6Gq1w35FYTMkknr8I7wraYaww6mTTa5MM2gdm19/XXLxP41vGmX+BvWrZ29VQjE616KnuZZzlGFO+Ukd4hVaejCkAib2fvqNwvy4xzxNRn3pje9j1cpW6Sm8cNSwwhHZleBU5rC9urwTuEqrzCD6zWA7aZXWdd1YTD6pHhQkPqgPBcY5PPu51e4pGoCJPCHokAXCPZGfI0xSnepDe0i+4jwDqJ9T9YsF0Hnm/oPg4yhSHC0XJQCMeTkeOQ5rGwakl5Pf9lG0vKUFgnl4co9F4TxGa0Qbzy+myJkBw8nVr6xWgzJNpH27r+eaRC8XR/R+fyzDviHyvgnmj/iL0nf7DQzEymW3hwLheUqojpKCqkZKdV5YeuLVS/T0MmuD+56QBlOkEu297qbbwaOkc8G6kdpOo9g1MS8QrZ4E9Nq9s4HBYcCsV3EXCKeeoQIdMy6UQjC5Gy3kyqpAIZdgGb5atDM8KZCzMlL/SaZqLMqYlil6eJ5+hPPtADXjm3JL7w3kNnujJY/8/Q3P5d6vXS1IRuXBBIeGW7+IId9IR5bmY+NPfPPDxPNzCcpgNdJ/uVExhPitsS8lrgUt7huOsrmt1ayHn2xSvX7KE8j+u0D0JdiKvqI9IT/i9wboYiR7KAQtgANfI0Huaa6XlOGB7L5tvma8F5600hxaU4FUjSByp2ax3bLKxHweS0IX7KU/VW+pn/PxDxckoP/FH3TcGT43flXx0XRmQNsv/gT6fWAEDLmhf/AFUmWlvfOx04Q2oflUmghEAZCw5tuONQ7HSmAWuWcOl+mNKMkCW6/vvN4viAQGSpapHbpWeDs2z9HA7qZnFKhurGa+F7sA=="
    
    public static var randomAESKey: String {
        guard let _ranKey = _randomAESKey else {
            let ranKey = creatRandomAESKey() ?? ""
            _randomAESKey = ranKey
            return ranKey
        }
        
        return _ranKey
    }
    
    public static var _randomAESKey: String?
    
    public static func creatRandomAESKey() -> String? {
        var keyData = Data(count: 64)
        let result = keyData.withUnsafeMutableBytes { SecRandomCopyBytes(kSecRandomDefault, 64, $0) }
        
        if result == errSecSuccess {
            return keyData.base64EncodedString()
        }
        return nil
    }
    
    public static var _securyAESKey: String?
    public static var securyAESKey: String {
        guard let _secrKey = _securyAESKey else {
            let secKey = creatSecuryAESKey() ?? ""
            _securyAESKey = secKey
            return secKey
        }
        return _secrKey
    }
    
    private static func creatSecuryAESKey() -> String? {
        RSA.encryptString(randomAESKey, publicKey: LSSecureOBJ.encode(withDES: pbServerKey, key: AES_KEY))
    }
    
    public static func encryptBody(_ body: String) {
        
    }
}

public extension String {
    public func AESEncrypt(key: String, iv: String, options: Int = kCCOptionPKCS7Padding) -> String? {
        if let keyData = key.data(using: String.Encoding.utf8),
            let data = self.data(using: String.Encoding.utf8),
            let cryptData    = NSMutableData(length: Int((data.count)) + kCCBlockSizeAES128) {


            let keyLength              = size_t(kCCKeySizeAES128)
            let operation: CCOperation = UInt32(kCCEncrypt)
            let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options:   CCOptions   = UInt32(options)



            var numBytesEncrypted :size_t = 0

            let cryptStatus = CCCrypt(operation,
                                      algoritm,
                                      options,
                                      (keyData as NSData).bytes, keyLength,
                                      iv,
                                      (data as NSData).bytes, data.count,
                                      cryptData.mutableBytes, cryptData.length,
                                      &numBytesEncrypted)

            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                cryptData.length = Int(numBytesEncrypted)
                let base64cryptString = cryptData.base64EncodedString(options: .lineLength64Characters)
                return base64cryptString


            }
            else {
                return nil
            }
        }
        return nil
    }
    
    func aesDecrypt(key:String, iv:String, options:Int = kCCOptionPKCS7Padding) -> String? {
        if let keyData = key.data(using: String.Encoding.utf8),
            let data = NSData(base64Encoded: self, options: .ignoreUnknownCharacters),
            let cryptData    = NSMutableData(length: Int((data.length)) + kCCBlockSizeAES128) {

            let keyLength              = size_t(kCCKeySizeAES128)
            let operation: CCOperation = UInt32(kCCDecrypt)
            let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options:   CCOptions   = UInt32(options)

            var numBytesEncrypted :size_t = 0

            let cryptStatus = CCCrypt(operation,
                                      algoritm,
                                      options,
                                      (keyData as NSData).bytes, keyLength,
                                      iv,
                                      data.bytes, data.length,
                                      cryptData.mutableBytes, cryptData.length,
                                      &numBytesEncrypted)

            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                cryptData.length = Int(numBytesEncrypted)
                let unencryptedMessage = String(data: cryptData as Data, encoding:String.Encoding.utf8)
                return unencryptedMessage
            }
            else {
                return nil
            }
        }
        return nil
    }
}


extension String {
    var md5: String {
        guard let data = data(using: .utf8) else {
            return self
        }
        
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = data.withUnsafeBytes({ bytes in
            return CC_MD5(bytes.baseAddress, CC_LONG(data.count), &digest)
        })
        
        return digest.map { String(format: "%02x", $0)}.joined()
    }
    
    var SHA256: String {
        guard let data = data(using: .utf8) else {
            return self
        }
        
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        
        _ = data.withUnsafeBytes({ bytes in
            return CC_SHA256(bytes.baseAddress, CC_LONG(data.count), &digest)
        })
        
        return digest.map { String(format: "%02x", $0)}.joined()
    }
}
