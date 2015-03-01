//
//  NSObject+ABExtras.m
//  uSpeak
//
//  Created by uSpeak on 28/05/13.
//  Copyright (c) 2013 uSpeak Ltd. All rights reserved.
//

#import "NSObject+ABExtras.h"

@implementation NSObject (ABExtras)

- (void)performBlock:(void (^)(void))block
          afterDelay:(NSTimeInterval)delay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}

@end
