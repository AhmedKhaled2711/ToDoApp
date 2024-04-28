//
//  Utils.h
//  ToDoApp
//
//  Created by Ahmed Khaled on 21/04/2024.
//

#import <Foundation/Foundation.h>
#import "TaskModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HelperClass : NSObject

+ (NSArray<TaskModel *> *)filterTasksFromArray:(NSArray<TaskModel *> *)tasks withFilter:(NSString*)filterKey;
+ (NSArray<TaskModel *> *)filterTasksByPriority:(NSArray<TaskModel *> *)tasks withPriority:(NSString*)priorityKey;
+(void)saveTaskArrayToUserDefaults:(NSString *)keyName withArray:(NSMutableArray *)taskArray;
+(NSMutableArray *)readArrayWithTaskObjFromUserDefaults:(NSString*)keyName;
+(void)removeArrayFromUserDefaults:(NSString *)keyName;

@end

NS_ASSUME_NONNULL_END
