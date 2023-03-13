//
//
//  LSSecureOBJ.h
//  Haylou_Fun
//
//  Created by     on 2022/5/24
//     
//


#import <Foundation/Foundation.h>

NSString * _AES_KEY(void);

NS_ASSUME_NONNULL_BEGIN

@interface LSSecureOBJ : NSObject

+ (NSString *)encodeWithDES: (NSString *)target key: (NSString *) key;

+ (NSString *)decodeWithDES: (NSString *)target key: (NSString *) key;

@end

NS_ASSUME_NONNULL_END
