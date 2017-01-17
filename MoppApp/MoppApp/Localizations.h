//
// Autogenerated by Laurine - by Jiri Trecak ( http://jiritrecak.com, @jiritrecak )
// Do not change this file manually!
//


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Imports

@import Foundation;


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Header

@interface _Localizations : NSObject

/// Base translation: Change %@
- (NSString *(^)(NSString *))PinActionsChangePin;
/// Base translation: 1 time
- (NSString *)MyEidUsedOnce;

/// Base translation: Validity:
- (NSString *)MyEidValidity;

/// Base translation: Unblocking %@:
- (NSString *(^)(NSString *))PinActionsUnblockingPin;
/// Base translation: Birth:
- (NSString *)MyEidBirth;

/// Base translation: %@ has been changed.
- (NSString *(^)(NSString *))PinActionsSuccessPinChanged;
/// Base translation: Valid
- (NSString *)MyEidValid;

/// Base translation: %i times
- (NSString *(^)(int))MyEidTimesUsed;
/// Base translation: is valid
- (NSString *)ContainerDetailsSignatureValid;

/// Base translation: ID-kaart on riigi sisene kohustuslik isikut tõendav dokument alates 15-aastast. Eesti kodanik saab ID-kaardiga reisida Euroopa Liidu ja Euroopa Majanduspiirkonna riikides.  ID-kaarti saab taotleda Politsei- ja Piirivalveameti teenindustes, Eesti Vabariigi välisteeninduses, posti võ e-posti teel. %@
- (NSString *(^)(NSString *))MyEidIdCardInfo;
/// Base translation: PIN action was successful
- (NSString *)PinActionsSuccessTitle;

/// Base translation: Personal data
- (NSString *)MyEidPersonalData;

/// Base translation: Signed
- (NSString *)ContainersListSectionHeaderSigned;

/// Base translation: Current %@ code
- (NSString *(^)(NSString *))PinActionsCurrentPin;
/// Base translation: Changing %@
- (NSString *(^)(NSString *))PinActionsChangingPin;
/// Base translation: Current %@ was wrong. You have %i tries left.
- (NSString *(^)(NSString *, int))PinActionsWrongPinRetry;
/// Base translation: Document
- (NSString *)ContainerDetailsTitle;

/// Base translation: You are currenty importing file named "%@". Please select unsigned document or create new one.
- (NSString *(^)(NSString *))FileImportInfo;
/// Base translation: Used:
- (NSString *)MyEidUseCount;

/// Base translation: Repeat new %@ code
- (NSString *(^)(NSString *))PinActionsRepeatPin;
/// Base translation: Import file
- (NSString *)FileImportTitle;

/// Base translation: is not valid
- (NSString *)ContainerDetailsSignatureInvalid;

/// Base translation: Files
- (NSString *)ContainerDetailsDatafileSectionHeader;

/// Base translation: PUK
- (NSString *)PinActionsPuk;

/// Base translation: Personal Code:
- (NSString *)MyEidPersonalCode;

/// Base translation: Not valid
- (NSString *)MyEidNotValid;

/// Base translation: %@ has been changed and unblocked.
- (NSString *(^)(NSString *))PinActionsSuccessPinUnblocked;
/// Base translation: ID card is not found.  Please check if ID card is inserted correctly. New ID cards have chip on the back side of the card.
- (NSString *)MyEidWarningCardNotFound;

/// Base translation: tap here
- (NSString *)MyEidTapHere;

/// Base translation: E-mail:
- (NSString *)MyEidEmail;

/// Base translation: My eID
- (NSString *)TabMyEid;

/// Base translation: Read more.
- (NSString *)MyEidFindMoreInfo;

/// Base translation: Here you can change your PIN codes and unblock them if needed. PIN operations need card reader to be connected to your phone.
- (NSString *)PinActionsInfo;

/// Base translation: Citizenship:
- (NSString *)MyEidCitizenship;

/// Base translation: Using current %@ code
- (NSString *(^)(NSString *))PinActionsVerificationOption;
/// Base translation: New %@ must be different from current %@.
- (NSString *(^)(NSString *, NSString *))PinActionsSameAsCurrent;
/// Base translation: My eID
- (NSString *)MyEidMyEid;

/// Base translation: New %@ has invalid format.
- (NSString *(^)(NSString *))PinActionsInvalidFormat;
/// Base translation: Current %@ was wrong. %@ has been blocked.
- (NSString *(^)(NSString *, NSString *))PinActionsWrongPinBlocked;
/// Base translation: Card reader is not connected.  Please make sure your reader is turned on and %@ to select it.
- (NSString *(^)(NSString *))MyEidWarningReaderNotFound;
/// Base translation: Size: %ld kb
- (NSString *(^)(long))ContainerDetailsDatafileDetails;
/// Base translation: Signatures
- (NSString *)ContainerDetailsSignatureSectionHeader;

/// Base translation: New %@ has incorrect length.
- (NSString *(^)(NSString *))PinActionsIncorrectLength;
/// Base translation: Documents
- (NSString *)TabContainers;

/// Base translation: Signature certificate
- (NSString *)MyEidSignatureCertificate;

/// Base translation: Changing %@:
- (NSString *(^)(NSString *))PinActionsVerificationTitle;
/// Base translation: PIN1
- (NSString *)PinActionsPin1;

/// Base translation: OK
- (NSString *)ActionOk;

/// Base translation: Error
- (NSString *)PinActionsErrorTitle;

/// Base translation: Unsigned
- (NSString *)ContainersListSectionHeaderUnsigned;

/// Base translation: PIN2
- (NSString *)PinActionsPin2;

/// Base translation: New %@ code
- (NSString *(^)(NSString *))PinActionsNewPin;
/// Base translation: Signature %@
- (NSString *(^)(NSString *))ContainerDetailsSignaturePrefix;
/// Base translation: Format: %@ | Size: %ld kb
- (NSString *(^)(NSString *, long))ContainerDetailsHeaderDetails;
/// Base translation: https://www.politsei.ee/en/teenused/isikut-toendavad-dokumendid/id-kaart/taiskasvanule/
- (NSString *)MyEidIdCardInfoLink;

/// Base translation: eID
- (NSString *)MyEidEid;

/// Base translation: Cancel
- (NSString *)Cancel;

/// Base translation: Valid until:
- (NSString *)MyEidValidUntil;

/// Base translation: Surname:
- (NSString *)MyEidSurname;

/// Base translation: * New PIN1 must be different from previous PIN1.  * New PIN1 must be 4-12 digits long.  * New PIN1 can't be 0000, 1234, or contain your personal id code.
- (NSString *)PinActionsRulesPin1;

/// Base translation: * New PIN2 must be different from previous PIN2.  * New PIN2 must be 5-12 digits long.  * New PIN2 can't be 00000, 12345, or contain your personal id code.
- (NSString *)PinActionsRulesPin2;

/// Base translation: Settings
- (NSString *)TabSettings;

/// Base translation: SIM settings
- (NSString *)TabSimSettings;

/// Base translation: Unblock %@
- (NSString *(^)(NSString *))PinActionsUnblockPin;
/// Base translation: Card in reader:
- (NSString *)MyEidCardInReader;

/// Base translation: Could not change %@
- (NSString *(^)(NSString *))PinActionsGeneralError;
/// Base translation: Create document
- (NSString *)FileImportCreateContainerButton;

/// Base translation: Rules
- (NSString *)PinActionsRulesTitle;

/// Base translation: Given names:
- (NSString *)MyEidGivenNames;

/// Base translation: Search
- (NSString *)ContainersListSearchPlaceholder;

+ (_Localizations *)sharedInstance;

@end


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Macros

// Make localization to be easily accessible
#define Localizations [_Localizations sharedInstance]
