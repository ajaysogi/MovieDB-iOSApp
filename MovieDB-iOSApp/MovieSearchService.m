//
//  MovieSearchService.m
//  MovieDB-iOSApp
//
//  Created by Ajay Sogi on 18/02/2015.
//  Copyright (c) 2015 Ajay Sogi. All rights reserved.
//

#import "MovieSearchService.h"

@implementation MovieSearchService

@synthesize searchTerm;
@synthesize delegate;
@synthesize results;

- (void)main {
    
    // DEBUG CODE:------------
    NSLog(@"Service has run");
    //------------------------
    
    NSString *api =  @"c32733824837ebd1ddb2ac60b90feced";
    NSString *search_term = [searchTerm stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSString *url = [NSString stringWithFormat:@"http://api.themoviedb.org/3/search/movie?api_key=%@&search_type=ngram&query=%@&include_adult=false", api, search_term];
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
    
    if (responseData != nil) {
        NSError *error = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        
        if (error) {
            [delegate serviceFinished:self withError:YES];
        } else {
            results = (NSArray *)[json valueForKey:@"results"];
            [delegate serviceFinished:self withError:NO];
        }
    } else {
    
        [delegate serviceFinished:self withError:YES];
    }
    
    
    
    
    
}

@end
