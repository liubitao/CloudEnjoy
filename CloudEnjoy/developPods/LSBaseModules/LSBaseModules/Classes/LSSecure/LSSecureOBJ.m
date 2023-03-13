//
//
//  LSSecureOBJ.m
//  Haylou_Fun
//
//  Created by     on 2022/5/24
//     
//


// iv: 12312300
#import "LSSecureOBJ.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"
#import "GTMDefines.h"


#define STRING_ENCRYPT_KEY 0xAC
NSString * _AES_KEY(void) {
    unsigned char key[] = {
        (STRING_ENCRYPT_KEY ^ 'N'),
        (STRING_ENCRYPT_KEY ^ 'H'),
        (STRING_ENCRYPT_KEY ^ 'E'),
        (STRING_ENCRYPT_KEY ^ 'A'),
        (STRING_ENCRYPT_KEY ^ 'L'),
        (STRING_ENCRYPT_KEY ^ 'T'),
        (STRING_ENCRYPT_KEY ^ 'H'),
        (STRING_ENCRYPT_KEY ^ 'H'),
        (STRING_ENCRYPT_KEY ^ 'L'),
        (STRING_ENCRYPT_KEY ^ '\0')
    };
    unsigned char *p = key;
    while (((*p) ^= STRING_ENCRYPT_KEY) != '\0') p++;
    return [NSString stringWithUTF8String:(const char *) key];
}

@implementation LSSecureOBJ

+ (NSString *)encodeWithDES:(NSString *)target key:(NSString *)key{
    //把string 转NSData
    NSData* data = [target dataUsingEncoding:NSUTF8StringEncoding];
    
    //length
    size_t plainTextBufferSize = [data length];
    
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [key UTF8String];
    //偏移量
    const void *vinitVec = (const void *) [_AES_KEY() UTF8String];
    
    //配置CCCrypt
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES, //3DES
                       kCCOptionECBMode|kCCOptionPKCS7Padding, //设置模式
                       vkey,    //key
                       kCCKeySize3DES,
                       vinitVec,     //偏移量，这里不用，设置为nil;不用的话，必须为nil,不可以为@“”
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString *result = [GTMBase64 stringByEncodingData:myData];
    return result;
}

+ (NSString *)decodeWithDES:(NSString *)target key:(NSString *)key {
    
    NSData *encryptData = [GTMBase64 decodeData:[target dataUsingEncoding:NSUTF8StringEncoding]];
    
    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [key UTF8String];
    
    const void *vinitVec = (const void *) [_AES_KEY() UTF8String];
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding|kCCOptionECBMode,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                      length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    
    
    return result;
}

//hex数据转为bytes
+ (NSData *) hexToBytes:(NSString *)target

{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= target.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [target substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

@end
