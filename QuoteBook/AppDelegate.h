//
//  AppDelegate.h
//  QuoteBook
//
//  Created by AJ Ibraheem on 06/10/2014.
//  Copyright (c) 2014 The Leaf Enterprise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

// Feature list
// - Add the new StandS4 API to the server
// 1. Add notification features for early morning daily quote
// 2. Implement notification center widget
// 3. Add apple watch target
// 4. Add a menu { allow user change the colors }
// 5. Add advertisements to the app
// 6. Create the mac version
// 7. Add a share feature for the quotes
// 8. Integrate beautiful adverts in the app
// - Allow people add their own quotes { People can upvote & downvote quotes just like stack overflow, User generated content + My generated content 🙌🏽🙌🏽🙌🏽 }


// Bugs list
// -- Fix the bug on the server side, preventing cron jobs from executing with results
// -- Allow text re-size to accomodate for long quotes
// -- Alert the user when there is no network connection
// -- server side, write a script to prevent duplicate quotes
=======
// 1. Add notification features for early morning daily quote
// 2. Implement notification center widget
// 3. Add apple watch target

// Bugs list
// -- No Bugs --

