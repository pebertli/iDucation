//
//  IDCGLKitViewController.m
//  iducation
//
//  Created by pebertli on 09/04/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "IDCGLKitViewController.h"
#import "UtilityMesh.h"
#import "UtilityModel+viewAdditions.h"
#import "IDCConstants.h"

@interface IDCGLKitViewController ()

@end

@implementation IDCGLKitViewController

@synthesize modelManager;
@synthesize model;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithFrame: (CGRect) frame modelList:(NSString*) listName modelNames:(NSArray*) array {
    self = [super init];
    if (self!=nil) {
        models = array;
        list = listName;
        animation_back = NO;
        animation_swipe = NO;
        quaternion_base = GLKQuaternionMake(0.0, 0.0, 0.0, 1.0);
        quaternion_base_a = GLKQuaternionMake(0.0, 0.0, 0.0, 1.0);
        quaternion_base_o = GLKQuaternionMake(0.0, 0.0, 0.0, 1.0);
        originalFrame = frame;
        //needs to be the last call
        self.view.frame = frame;
       
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

	// Do any additional setup after loading the view.
    
    // Verify the type of view created automatically by the xib
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]],
             @"View controller's view is not a GLKView");
    
    // Use high resolution depth buffer
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    // Create an OpenGL ES 2.0 context and provide it to the view
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    // Make the new context current
    [EAGLContext setCurrentContext:view.context];
    
    //type of z buffer
    glEnable(GL_DEPTH_TEST);
    
    // Create a base effect that provides standard OpenGL ES 2.0 Shading Language programs and set constants to be used for all subsequent rendering
    self.baseEffect = [[GLKBaseEffect alloc] init];
        
    // The model manager loads models and sends the data to GPU. Each loaded model can be accesssed by name.
//  NSString *modelsPath = [[NSBundle mainBundle] pathForResource: @"bumper" ofType:@"modelplist"];
 
    NSString *modelsPath = [[NSBundle mainBundle] pathForResource:list ofType:@"modelplist"];
    self.modelManager =  [[UtilityModelManager alloc] initWithModelPath:modelsPath];
    
    // Load models used to draw the scene
//    self.model = [self.modelManager modelNamed:@"bumperCar"];
    
    for(NSString* str in models){
        self.model = [self.modelManager modelNamed:str];}

    
    //bounding box
    AGLKAxisAllignedBoundingBox bb = self.model.axisAlignedBoundingBox;
    NSAssert((bb.max.x - bb.min.x)>0 && (bb.max.z - bb.min.z)>0,@"BB has no area");

    //merge BB from all models, (makeceil and makefloor from corners max and min respectively)
    //TO-DO
    
    //center from merged bb is where the camera is looking for
    cameraLookAt = GLKVector3DivideScalar(GLKVector3Add(bb.min,bb.max),2);
    //radius as max value between corners and center
    float radius = GLKVector3Distance(bb.max, cameraLookAt);
    float radiusAux = GLKVector3Distance(bb.min, cameraLookAt);
    if(radiusAux>radius)
        radius = radiusAux;
    //distance from  center to sphere surface
    float fov = GLKMathDegreesToRadians(FOV_DEGREE)/2.0;
    float distance = radius/tan(fov);
    GLKVector3 direction = GLKVector3Normalize(cameraLookAt);
    //position from the camera
    cameraPosition = GLKVector3Add(cameraLookAt, GLKVector3MultiplyScalar(direction, distance));
    
    // Configure a light
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.ambientColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    self.baseEffect.light0.diffuseColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    self.baseEffect.light0.position = GLKVector4Make(cameraPosition.x,cameraPosition.y,cameraPosition.z,1.0);
    self.baseEffect.light0.spotDirection = cameraLookAt;
    //self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    self.baseEffect.texture2d0.name =
    self.modelManager.textureInfo.name;
    self.baseEffect.texture2d0.target =
    self.modelManager.textureInfo.target;
    
    //Pan gesture
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [panGesture setMaximumNumberOfTouches:1];
    [panGesture setDelegate:self];
    [self.view addGestureRecognizer:panGesture];
    
    //double tap gesture
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [doubleTapGesture setDelegate:self];
    [self.view addGestureRecognizer:doubleTapGesture];
    
    //pinch gesture
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [pinchGesture setDelegate:self];
    [self.view addGestureRecognizer:pinchGesture];


}

- (void)pinch:(UIPinchGestureRecognizer *)gestureRecognizer{
    
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged)
    {
        scalePinch = gestureRecognizer.scale;
    }
    
    if([gestureRecognizer state] == UIGestureRecognizerStateEnded)
    {
        CGRect frame = self.view.frame;
        
        if(scalePinch>1){
        //full size
        frame.size.height = HEIGHT_IPAD;
        frame.size.width = WIDTH_IPAD;
        frame.origin.x = 0;
        frame.origin.y = 0;
        }
        else {
            //return to original Frame
            frame = originalFrame;
        }

        [UIView animateWithDuration:SHORT_TIME_INTERVAL delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                           self.view.frame = frame;
                         }
                         completion:nil];
    }

    
    
}

- (void)doubleTap:(UITapGestureRecognizer *)gestureRecognizer{
    
    if(!animation_back){
        
        //reset animation time
        slerpAnimationTime = 0.0;

        //if the model is rotationed,then start animation
        if(!(quaternion_base.x == 0.0 && quaternion_base.y == 0.0 && quaternion_base.z == 0.0 && quaternion_base.w == 1.0)){
            animation_back = YES;
            animation_swipe = NO;
        }
        
    }
    
}


- (void)pan:(UIPanGestureRecognizer *)gestureRecognizer
{
    //if the user start drage, then stop animations
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan)
    {
        animation_back = NO;
        animation_swipe = NO;
        //initial orientation when drag
        quaternion_base_a = quaternion_base;
    }
    UIView* piece = gestureRecognizer.view;
    CGPoint translation = [gestureRecognizer  translationInView:[piece superview]];
    
    //degree conversion from the total translation in drag. (half loop by width/height)
    float x = ((360.0*translation.x)/(piece.frame.size.width*FACTOR_DRAG));
    float y = ((360.0*translation.y)/(piece.frame.size.height*FACTOR_DRAG));

    // get touch delta
	CGPoint delta = CGPointMake(GLKMathDegreesToRadians(x), GLKMathDegreesToRadians(y));
    //alter the orientation of the model
    [self rotateQuaternionWithVector:delta];
    
    //if drag ended, then start swipe animation
    if([gestureRecognizer state] == UIGestureRecognizerStateEnded)
    {
        velocity = [gestureRecognizer velocityInView:piece];
        //max of 720 degrees
        velocity.y = GLKMathDegreesToRadians(MIN(MAX_DEGREE_VELOCITY, velocity.y/FACTOR_VELOCITY));
        velocity.x = GLKMathDegreesToRadians(MIN(MAX_DEGREE_VELOCITY, velocity.x/FACTOR_VELOCITY));

        //reset animation time
        slerpAnimationTime = 0.0;
        //final orientation when touch up
        quaternion_base_o = quaternion_base;
        animation_swipe = YES;
        animation_back = NO;

    }
    
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // Clear Frame Buffer (erase previous drawing)
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    
    glEnable(GL_CULL_FACE);

    // Calculate the aspect ratio for the scene and setup a perspective projection
    const GLfloat  aspectRatio = (GLfloat)view.drawableWidth / (GLfloat)view.drawableHeight;
    self.baseEffect.transform.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(FOV_DEGREE), aspectRatio, Z_NEAR,Z_FAR);

    [self.modelManager prepareToDraw];
    [self.baseEffect prepareToDraw];
    
    [model draw];
}

- (void)update
{
    if(animation_back){
        //period of last update between 0.01 and 0.5 s
        NSTimeInterval elapsedTimeSeconds = MIN(MAX([self timeSinceLastUpdate], 0.01f), 0.5f);
        
        //compute increase time
        slerpAnimationTime = [self lowPassFilter:elapsedTimeSeconds target:VERY_SHORT_TIME_INTERVAL current:slerpAnimationTime];
        //slerp orientation until identity orientation
        GLKQuaternion qr = GLKQuaternionSlerp(quaternion_base, GLKQuaternionIdentity, slerpAnimationTime);
        //the function in low pass filter never reachs target, then it needs to have a tolerance to finish
        if(slerpAnimationTime>=VERY_SHORT_TIME_INTERVAL-(VERY_SHORT_TIME_INTERVAL/100)){
            animation_back = NO;
            qr = GLKQuaternionIdentity;
        }
        quaternion_base = qr;
    }
    
    //if there is velocity for animation
    if(animation_swipe && (velocity.x!=0.0 || velocity.y!=0.0)){
        
        //period of last update between 0.01 and 0.5 s
        NSTimeInterval   elapsedTimeSeconds =  MIN(MAX([self timeSinceLastUpdate], 0.01f), 0.5f);
        
        slerpAnimationTime = [self lowPassFilter:elapsedTimeSeconds target:FAIR_TIME_INTERVAL current:slerpAnimationTime];
        
        GLKVector3 up = GLKVector3Make(0.f, 1.f, 0.f);
        GLKVector3 right = GLKVector3Make(1.f, 0.f, 0.f);
        //degree proportional to slerp time
        float y = (slerpAnimationTime/FAIR_TIME_INTERVAL)*velocity.y;
        float x = (slerpAnimationTime/FAIR_TIME_INTERVAL)*velocity.x;

        //compute world axis for current orientation
        GLKQuaternion quaternion_base1 = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(y, right),quaternion_base_o);
        quaternion_base = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(x, up),quaternion_base1);
        //the function in low pass filter never reachs target, then it needs to have a tolerance to finish
        if(slerpAnimationTime>=FAIR_TIME_INTERVAL-(FAIR_TIME_INTERVAL/100)){
            animation_swipe = NO;
        }
    }

    //camera position
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeLookAt(0,0,cameraPosition.y, cameraLookAt.x,cameraLookAt.y, cameraLookAt.z, 0.0, 1.0, 0.0);
    //rotate around center: translate to center, rotate, translate back
    modelViewMatrix = GLKMatrix4TranslateWithVector3(modelViewMatrix, cameraLookAt);
    modelViewMatrix = GLKMatrix4Multiply( modelViewMatrix, GLKMatrix4MakeWithQuaternion( quaternion_base ) );
    modelViewMatrix = GLKMatrix4TranslateWithVector3(modelViewMatrix, GLKVector3Negate(cameraLookAt));

    //set new matrix
    self.baseEffect.transform.modelviewMatrix = modelViewMatrix;

}

- (void) rotateQuaternionWithVector:(CGPoint)delta
{
	GLKVector3 up = GLKVector3Make(0.f, 1.f, 0.f);
	GLKVector3 right = GLKVector3Make(1.f, 0.f, 0.f);
    
    //compute world axis for current orientation
    GLKQuaternion quaternion_base1 = GLKQuaternionNormalize(GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(delta.y, right),quaternion_base_a));
    quaternion_base = GLKQuaternionNormalize(GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(delta.x, up),quaternion_base1));    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//funtion for fast start and slow finish
- (float) lowPassFilter:(NSTimeInterval) elapsed target:(float) target current:(float) current
{
    float v = elapsed*(target-current);
    
    return current + (FACTOR_LOW_PASS_FILTER*v);
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Make the view's context current
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    
    // Stop using the context created in -viewDidLoad
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
    
    self.baseEffect = nil;
}

@end
