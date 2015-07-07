//
//  MovieDetailsService.h
//  MovieDB-iOSApp
//
//  Created by Ajay Sogi on 21/02/2015.
//  Copyright (c) 2015 Ajay Sogi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ServiceDelegate.h"

@interface MovieDetailsService : NSOperation {

    // Variable to repersent the movie that is being looked for
    NSString *movieID;
    
    // Delegate to contact when the service is complete
    id<ServiceDelegate> delegate;
    
    // Info received is stored within this dictionary
    NSDictionary *details;
    
}

@property (nonatomic, retain) NSString *movieID;
@property (nonatomic, retain) id<ServiceDelegate> delegate;
@property (nonatomic, retain) NSDictionary *details;

@end
