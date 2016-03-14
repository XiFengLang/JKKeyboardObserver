//
//  UIKeyboardInputMode.h
//  FitComeCare
//
//  Created by 孙国林 on 16/3/4.
//  Copyright © 2016年 Mac3. All rights reserved.
//

#ifndef TestDeterminKeyboard_UIKeyboardInputMode_h
#define TestDeterminKeyboard_UIKeyboardInputMode_h

@class NSString, NSArray;

@interface UIKeyboardInputMode : UITextInputMode {
    
}

@property (nonatomic,copy) NSString * identifier;
@property (nonatomic,readonly) NSString * primaryLanguage;
@property (nonatomic,copy) NSString * softwareLayout;
@property (nonatomic,copy) NSString * hardwareLayout;
@property (nonatomic,readonly) NSArray * normalizedIdentifierLevels;

@end

@interface UIKeyboardInputModeController : NSObject {
    
    UIKeyboardInputMode* _currentInputMode;
    NSArray* _inputModesWithoutHardwareSupport;
    NSString* currentLocale;
    NSString* currentLanguage;
    NSArray* keyboardInputModes;
    NSArray* enabledInputModes;
    NSArray* normalizedInputModes;
    NSArray* defaultKeyboardInputModes;
    NSArray* defaultRawInputModes;
    NSArray* defaultInputModes;
    NSArray* defaultNormalizedInputModes;
    NSString* _inputModeContextIdentifier;
    
}

+ (id)sharedInputModeController;
- (id)_MCFilteredExtensionIdentifiers;
- (void)_clearAllExtensionIfNeeded;
- (void)_setCurrentInputMode:(id)arg1 force:(BOOL)arg2;
- (id)_systemInputModePassingTest:(id)arg1;
- (id)activeInputModeIdentifiers;
- (id)activeInputModes;
- (id)allowedExtensions;
- (BOOL)containsDictationSupportedInputMode;
- (id)currentInputMode;
- (id)currentInputModeInPreference;
- (BOOL)currentLocaleRequiresExtendedSetup;
- (id)currentPublicInputMode;
- (id)currentSystemInputMode;
- (id)currentUsedInputMode;
- (void)dealloc;
- (id)defaultEnabledInputModesForCurrentLocale:(BOOL)arg1;
- (id)defaultInputModes;
- (id)defaultKeyboardInputModes;
- (id)defaultNormalizedInputModes;
- (id)defaultRawInputModes;
- (id)delegate;
- (BOOL)deviceStateIsLocked;
- (void)didEnterBackground:(id)arg1;
- (id)enabledInputModeIdentifiers:(BOOL)arg1;
- (id)enabledInputModeIdentifiers;
- (id)enabledInputModeLanguages;
- (id)enabledInputModes;
- (id)extensionInputModes;
- (id)hardwareInputMode;
- (BOOL)identifierIsValidSystemInputMode:(id)arg1;
- (id)identifiersFromInputModes:(id)arg1;
- (id)init;
- (id)inputModeContextIdentifier;
- (id)inputModeWithIdentifier:(id)arg1;
- (id)inputModesWithoutHardwareSupport;
- (id)keyboardInputModeIdentifiers;
- (id)keyboardInputModes;
- (id)lastUsedInputMode;
- (id)nextInputModeFromList:(id)arg1 withFilter:(unsigned int)arg2 withTraits:(id)arg3;
- (id)nextInputModeInPreferenceListForTraits:(id)arg1;
- (id)nextInputModeToUse;
- (id)nextInputModeToUseForTraits:(id)arg1;
- (id)normalizedEnabledInputModeIdentifiers;
- (id)normalizedInputModes;
- (void)performWithForcedExtensionInputModes:(id)arg1;
- (void)performWithoutExtensionInputModes:(id)arg1;
- (id)preferredLanguages;
- (void)setCurrentInputMode:(id)arg1;
- (void)setCurrentInputModeInPreference:(id)arg1;
- (void)setCurrentUsedInputMode:(id)arg1;
- (void)setDefaultInputModes:(id)arg1;
- (void)setDefaultKeyboardInputModes:(id)arg1;
- (void)setDefaultNormalizedInputModes:(id)arg1;
- (void)setDefaultRawInputModes:(id)arg1;
- (void)setDelegate:(id)arg1;
- (void)setEnabledInputModes:(id)arg1;
- (void)setInputModeContextIdentifier:(id)arg1;
- (void)setKeyboardInputModeIdentifiers:(id)arg1;
- (void)setKeyboardInputModes:(id)arg1;
- (void)setLastUsedInputMode:(id)arg1;
- (void)setNextInputModeToUse:(id)arg1;
- (void)setNormalizedInputModes:(id)arg1;
- (void)startConnectionForFileAtURL:(id)arg1 forInputModeIdentifier:(id)arg2;
- (void)startDictationConnectionForFileAtURL:(id)arg1 forInputModeIdentifier:(id)arg2;
- (id)suggestedInputModesForCurrentLocale:(BOOL)arg1 fallbackToDefaultInputModes:(BOOL)arg2;
- (id)suggestedInputModesForCurrentLocale;
- (id)suggestedInputModesForPreferredLanguages;
- (id)supportedInputModeIdentifiers;
- (void)switchToCurrentSystemInputMode;
- (void)updateCurrentAndNextInputModes;
- (void)updateCurrentInputMode:(id)arg1;
- (void)updateLastUsedInputMode:(id)arg1;
- (BOOL)verifyKeyboardExtensionsWithApp;

@end

#endif