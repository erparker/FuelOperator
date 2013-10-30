//
//  NSString+Additions.h
//  FuelOperator
//
//  Created by Gary Robinson on 10/29/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

+ (NSData*)encrypt:(NSString *)string;
+ (NSString *)decrypt:(NSData*)encryptedData;

@end
