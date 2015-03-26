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
// 1. Add notification features for early morning daily quote
// 2. Implement notification center widget
// 3. Add apple watch target
// 4. Add a menu { offer customisation }
// 5. Add advertisements to the app
// 6. Create the mac version
// 7. Add a share feature for the quotes

// Bugs list
// -- Add support for swift 1.1
// -- Alert the user when there is no network connection