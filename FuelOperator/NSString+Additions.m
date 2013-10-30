//
//  NSString+Additions.m
//  FuelOperator
//
//  Created by Gary Robinson on 10/29/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "NSString+Additions.h"
#import <CommonCrypto/CommonCryptor.h>

#define FUEL_OPERATOR_ENCRYPT_KEY   @"18A198FF158436493F6DEF72B1D61"

@implementation NSString (Additions)

+ (NSData*)encrypt:(NSString *)string
{
    NSString *secret = FUEL_OPERATOR_ENCRYPT_KEY;
	return [[string dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:secret];
}

+ (NSString *)decrypt:(NSData*)encryptedData
{
    NSString *secret = FUEL_OPERATOR_ENCRYPT_KEY;
	return [[NSString alloc] initWithData:[encryptedData AES256DecryptWithKey:secret] encoding:NSUTF8StringEncoding];
}


@end
