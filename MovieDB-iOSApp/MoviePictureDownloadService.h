//
//  MoviePictureDownloadService.h
//  MovieDB-iOSApp
//
//  Created by Ajay Sogi on 22/02/2015.
//  Copyright (c) 2015 Ajay Sogi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceDelegate.h"


@interface MoviePictureDownloadService : NSOperation{

    NSString *movieId;
    NSString *moviePictureUrl;
    id<ServiceDelegate> delegate;
    
}

// Expose attributes to other classes
@property (nonatomic, retain) NSString *movieId;
@property (nonatomic, retain) NSString *moviePictureUrl;
@property (nonatomic, retain) id<ServiceDelegate> delegate;

@end
