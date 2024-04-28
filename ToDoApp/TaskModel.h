//
//  TaskModel.h
//  ToDoApp
//
//  Created by Ahmed Khaled on 21/04/2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskModel : NSObject

@property NSString *taskName;
@property NSString *taskDescription;
@property NSString *dateOfCreation;
@property NSString *taskPriority;
@property NSString *taskState;


@end

NS_ASSUME_NONNULL_END
