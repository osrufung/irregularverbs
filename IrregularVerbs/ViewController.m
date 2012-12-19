//
//  ViewController.m
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 19/12/12.
//  Copyright (c) 2012 Oswaldo Rubio. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	//1 cargamos verbos del diccionario .plist
    //1.0 recuperamos path al resource
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"verbs" ofType:@"plist"];
    self.verbs = [NSMutableArray arrayWithContentsOfFile:plistPath];
    
    self.labelPresent.text = @"";
    self.labelPast.text = @"";
    self.labelParticiple.text = @"";
    self.labelTranslation.text = @"";
    
    self.current_State = 0;
    
    [self showRandomVerb];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showRandomVerb{
      //1.0 cargamos el nº total de verbos
     int array_tot = [self.verbs count];
    if(array_tot > 0){
        
        //tiramos el dado en estado = 0
        if(self.current_State == 0){
            self.current_Pos = (arc4random() % array_tot);
        }
        
        NSString *simple = self.verbs[self.current_Pos ][@"simple"];
        NSString *past = self.verbs[self.current_Pos ][@"past"];
        NSString *participle = self.verbs[self.current_Pos ][@"participle"];
        NSString *translation = self.verbs[self.current_Pos ][@"translation"];
        
        switch(self.current_State){
            //mostrar presente
            case 0:
                self.labelPresent.text = simple ;
                self.labelPast.text = @"" ;
                self.labelParticiple.text = @"" ;
                self.labelTranslation.text = translation;
                self.current_State = 1;
                break;
            //mostrar pasado
            case 1:
                self.labelPresent.text = simple ;
                self.labelPast.text = past ;
                self.labelParticiple.text = @"" ;
                self.labelTranslation.text = translation;
                self.current_State = 2;
                break;
            //mostrar participio
            case 2:
                self.labelPresent.text = simple ;
                self.labelPast.text = past ;
                self.labelParticiple.text = participle;
                self.labelTranslation.text = translation;
                self.current_State = 0;
                break;
        }
        

        
        
    }else{
        NSLog(@"No elements in Verbs");
   
    }
}

-(IBAction)screenTapped:(id)sender{

   [self showRandomVerb];
  
}

@end
