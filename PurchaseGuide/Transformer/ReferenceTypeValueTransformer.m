//
//  ReferenceTypeValueTransformer.m
//  PodioKit
//
//  Created by Sebastian Rehnby on 22/04/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import "ReferenceTypeValueTransformer.h"
#import "Constants.h"

@implementation ReferenceTypeValueTransformer

- (instancetype)init {
  return [super initWithDictionary:@{
    @"app" : @(ReferenceTypeApp),
    @"app_revision" : @(ReferenceTypeAppRevision),
    @"app_field" : @(ReferenceTypeAppField),
    @"item" : @(ReferenceTypeItem),
    @"bulletin" : @(ReferenceTypeBulletin),
    @"comment" : @(ReferenceTypeComment),
    @"status" : @(ReferenceTypeStatus),
    @"space_member" : @(ReferenceTypeSpaceMember),
    @"alert" : @(ReferenceTypeAlert),
    @"item_revision" : @(ReferenceTypeItemRevision),
    @"rating" : @(ReferenceTypeRating),
    @"task" : @(ReferenceTypeTask),
    @"task_action" : @(ReferenceTypeTaskAction),
    @"space" : @(ReferenceTypeSpace),
    @"org" : @(ReferenceTypeOrg),
    @"conversation" : @(ReferenceTypeConversation),
    @"message" : @(ReferenceTypeMessage),
    @"notification" : @(ReferenceTypeNotification),
    @"file" : @(ReferenceTypeFile),
    @"file_service" : @(ReferenceTypeFileService),
    @"profile" : @(ReferenceTypeProfile),
    @"user" : @(ReferenceTypeUser),
    @"widget" : @(ReferenceTypeWidget),
    @"share" : @(ReferenceTypeShare),
    @"form" : @(ReferenceTypeForm),
    @"auth_client" : @(ReferenceTypeAuthClient),
    @"connection" : @(ReferenceTypeConnection),
    @"integration" : @(ReferenceTypeIntegration),
    @"share_install" : @(ReferenceTypeShareInstall),
    @"icon" : @(ReferenceTypeIcon),
    @"org_member" : @(ReferenceTypeOrgMember),
    @"news" : @(ReferenceTypeNews),
    @"hook" : @(ReferenceTypeHook),
    @"tag" : @(ReferenceTypeTag),
    @"embed" : @(ReferenceTypeEmbed),
    @"question" : @(ReferenceTypeQuestion),
    @"question_answer" : @(ReferenceTypeQuestionAnswer),
    @"action" : @(ReferenceTypeAction),
    @"contract" : @(ReferenceTypeContract),
    @"meeting" : @(ReferenceTypeMeeting),
    @"batch" : @(ReferenceTypeBatch),
    @"system" : @(ReferenceTypeSystem),
    @"space_member_request" : @(ReferenceTypeSpaceMemberRequest),
    @"live" : @(ReferenceTypeLive),
    @"item_participation" : @(ReferenceTypeItemParticipation),
  }];
}

@end
