//
//  NSObject+ABExtras.h
//  uSpeak
//
//  Created by uSpeak on 28/05/13.
//  Copyright (c) 2013 uSpeak Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ABExtras)

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

@end
