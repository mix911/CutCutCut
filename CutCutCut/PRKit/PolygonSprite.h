//
//  PolygonSprite.h
//  CutCutCut
//
//  Created by demo on 19.01.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PRFilledPolygon.h"
#import "Box2D.h"

#define PTM_RATIO 32

@interface PolygonSprite : PRFilledPolygon
{
    b2Body* body_;
    BOOL original_;
    b2Vec2 centroid_;
    BOOL sliceEntered_;
    BOOL sliceExited_;
    b2Vec2 entryPoint_;
    b2Vec2 exitPoint_;
    double sliceEntryTime_;
}

@property(nonatomic, assign)   b2Body* body;
@property(nonatomic, readwrite)BOOL    original;
@property(nonatomic, readwrite)b2Vec2  centroid;
@property(nonatomic, readwrite)BOOL    sliceEntered;
@property(nonatomic, readwrite)BOOL    sliceExited;
@property(nonatomic, readwrite)b2Vec2  entryPoint;
@property(nonatomic, readwrite)b2Vec2  exitPoint;
@property(nonatomic, readwrite)double  sliceEntryTime;

+(id)spriteWithFile:(NSString*)filename body:(b2Body*)body original:(BOOL)original;
+(id)spriteWithTexture:(CCTexture2D*)texture body:(b2Body*)body original:(BOOL)original;
+(id)spriteWithWorld:(b2World*)world;

-(id)initWithTexture:(CCTexture2D*)texture body:(b2Body*)body original:(BOOL)original;
-(id)initWithFile:(NSString*)filename body:(b2Body*)body original:(BOOL)original;
-(id)initWithWorld:(b2World*)world;

-(b2Body*)createBodyForWorld:(b2World*)world
                    position:(b2Vec2)position
                    rotation:(float)rotation
                    vertices:(b2Vec2*)verticies
                 vertexCount:(int32)count
                     density:(float)density
                    friction:(float)friction
                 restitution:(float)restitution;

-(void)activateCollisiions;
-(void)deactivateCollisions;

@end
