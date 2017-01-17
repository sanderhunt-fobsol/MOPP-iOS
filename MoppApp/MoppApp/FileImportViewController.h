//
//  FileImportViewController.h
//  MoppApp
//
//  Created by Ants Käär on 16.01.17.
//  Copyright © 2017 Mobi Lab. All rights reserved.
//

#import "BaseContainersListViewController.h"

@protocol FileImportViewControllerDelegate
- (void)openContainerDetailsWithName:(NSString *)containerFileName;
@end

@interface FileImportViewController : BaseContainersListViewController

@property (strong, nonatomic) NSString *dataFilePath;
@property (assign, nonatomic) id <FileImportViewControllerDelegate> delegate;

@end
