//
//  MovieTableViewController.h
//  MovieDB-iOSApp
//
//  Created by Ajay Sogi on 18/02/2015.
//  Copyright (c) 2015 Ajay Sogi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceDelegate.h"


/* 
    NOTES:
    ---------------------------------------------------------------------------------------------------------------
    1 - Adding Search Bar
    Search bar is required at the top of the movie TableView class. Therefore a UISearchBarDelegate is required
 
    2 - Adding Table Arrays
    The table needs to be prepared to use arrays that can store the data, which can be manipulated later.
    The code added to this file will create two array attributes that will store a list of films and the other
    will store list of search results. The two array attribuetes will then need to be initialised whithin the 
    implementation file.
 
    3 - Web Service
    The service delegates header is imported which will be implemented to use the search service. A NSOperationQueue
    will be required to run the service in the background. Also import the MovieSearchService.h so that the class 
    can be called in order to make the API request.
 */

@interface MovieTableViewController : UITableViewController <UISearchBarDelegate, ServiceDelegate>{

    // Create an attribute to hold the search bar in the class
    UISearchBar *searchBar;
    
    // This boolean will be used in order to respond to wehter the search bar request will be active or not
    BOOL searching;
    
    // Array attribute that will store movies
    NSMutableArray *movies;
    
    // Array attributes that will store search results
    NSMutableArray *searchResults;
    
    // Attribute that will be used to run the service in the background
    NSOperationQueue *serviceQueue;
    
}

@end
