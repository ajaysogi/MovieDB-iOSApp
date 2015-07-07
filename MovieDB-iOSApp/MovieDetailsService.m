//
//  MovieDetailsService.m
//  MovieDB-iOSApp
//
//  Created by Ajay Sogi on 21/02/2015.
//  Copyright (c) 2015 Ajay Sogi. All rights reserved.
//

#import "MovieDetailsService.h"

@implementation MovieDetailsService

@synthesize delegate;
@synthesize movieID;
@synthesize details;

-(void)main{

    NSString *api_key = @"c32733824837ebd1ddb2ac60b90feced";
    NSString *movie_id = [movieID stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *url = [NSString stringWithFormat:@"http://api.themoviedb.org/3/movie/%@?api_key=%@", movie_id, api_key];
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
    
    if (responseData != nil){
        
        NSError *error = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        
        if(error){
            [delegate serviceFinished:self withError:YES];
        } else{
            details = json;
            [delegate serviceFinished:self withError:NO];
        }
    } else {
        [delegate serviceFinished:self withError:YES];
    }
}



@end
