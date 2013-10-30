//
//  NSData+Additions.h
//  FuelOperator
//
//  Created by Gary Robinson on 10/30/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Additions)

- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;

@end
