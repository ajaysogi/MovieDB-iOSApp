//
//  MoviePictureDownloadService.m
//  MovieDB-iOSApp
//
//  Created by Ajay Sogi on 22/02/2015.
//  Copyright (c) 2015 Ajay Sogi. All rights reserved.
//

#import "MoviePictureDownloadService.h"

@import UIKit;


@implementation MoviePictureDownloadService

@synthesize movieId;
@synthesize moviePictureUrl;

@synthesize delegate;

/*
    METHOD EXPLANATION:
    ----------------------------------------------------------------------------------------------------
    Synthesize the properites and add main method from NSOperation to download the file in the background
    
    Downloading the data is as simple as creating a URL to the file on the weband a string for the path we
    want to cache the data to. 
 
    Then asking NSData to initialise with the content of a file from a URL.
    
    We then create a UIImage from that dataand then convert the image back to data in given file type,
    (in this case PNG)
    
    Finally we save the data to a file and tell the delegate that we have finished.
 */
-(void) main {

    NSString *url = [self moviePictureUrl];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir, movieId];
    
    NSURL *aURL = [NSURL URLWithString:url];
    NSData *data = [[NSData alloc] initWithContentsOfURL:aURL];
    UIImage *movie_image = [UIImage imageWithData:data];
    
    NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(movie_image)];
    [data1 writeToFile:pngFilePath atomically:YES];
    
    [delegate serviceFinished:self withError:NO];
}

@end
