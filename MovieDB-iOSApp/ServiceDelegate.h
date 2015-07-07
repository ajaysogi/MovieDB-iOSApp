//
//  ServiceDelegate.h
//  MovieDB-iOSApp
//
//  Created by Ajay Sogi on 18/02/2015.
//  Copyright (c) 2015 Ajay Sogi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ServiceDelegate <NSObject>

- (void)serviceFinished:(id)service withError:(BOOL)error;

@end
