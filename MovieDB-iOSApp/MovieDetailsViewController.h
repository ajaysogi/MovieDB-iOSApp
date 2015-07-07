//
//  MovieDetailsViewController.h
//  MovieDB-iOSApp
//
//  Created by Ajay Sogi on 19/02/2015.
//  Copyright (c) 2015 Ajay Sogi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServiceDelegate.h"

@interface MovieDetailsViewController : UIViewController <ServiceDelegate> {

    NSOperationQueue *serviceQueue;
    
}

// Create property links to the xib file so that they can be editable within the program code
//-------------------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UIImageView *imgFilm;
@property (weak, nonatomic) IBOutlet UILabel *txtFilmText;
@property (weak, nonatomic) IBOutlet UILabel *txtFilmYear;

@property (weak, nonatomic) IBOutlet UITextView *txtOverview;
@property (weak, nonatomic) IBOutlet UITextView *txtProdCompanies;
//-------------------------------------------------------------------------------------------

// Create a dictionary that stores all the movie details requested
@property (nonatomic, retain) NSDictionary *movie;



@end
