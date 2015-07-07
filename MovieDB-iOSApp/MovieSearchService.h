//
//  MovieSearchService.h
//  MovieDB-iOSApp
//
//  Created by Ajay Sogi on 18/02/2015.
//  Copyright (c) 2015 Ajay Sogi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ServiceDelegate.h"

@interface MovieSearchService : NSOperation{

    NSString *searchTerm;
    id<ServiceDelegate> delegate;
    
    NSArray *results;
}

@property (nonatomic, retain) NSString *searchTerm;
@property (nonatomic, retain) id<ServiceDelegate> delegate;

@property (nonatomic, retain) NSArray *results;

@end
