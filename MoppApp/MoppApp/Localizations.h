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

/// Base translation: Valid
- (NSString *)MyEidValid;

/// Base translation: Validity:
- (NSString *)MyEidValidity;

/// Base translation: Surname:
- (NSString *)MyEidSurname;

/// Base translation: Card reader is not connected.  Please make sure your reader is turned on and %@ to select it.
- (NSString *(^)(NSString *))MyEidWarningReaderNotFound;
/// Base translation: E-mail:
- (NSString *)MyEidEmail;

/// Base translation: Card in reader:
- (NSString *)MyEidCardInReader;

/// Base translation: Signed
- (NSString *)TabSigned;

/// Base translation: My eID
- (NSString *)TabMyEid;

/// Base translation: Personal Code:
- (NSString *)MyEidPersonalCode;

/// Base translation: ID-kaart on riigi sisene kohustuslik isikut tõendav dokument alates 15-aastast. Eesti kodanik saab ID-kaardiga reisida Euroopa Liidu ja Euroopa Majanduspiirkonna riikides.  ID-kaarti saab taotleda Politsei- ja Piirivalveameti teenindustes, Eesti Vabariigi välisteeninduses, posti võ e-posti teel. %@
- (NSString *(^)(NSString *))MyEidIdCardInfo;
/// Base translation: Birth:
- (NSString *)MyEidBirth;

/// Base translation: Given names:
- (NSString *)MyEidGivenNames;

/// Base translation: tap here
- (NSString *)MyEidTapHere;

/// Base translation: Signing
- (NSString *)TabSigning;

/// Base translation: ID card is not found.  Please check if ID card is inserted correctly. New ID cards have chip on the back side of the card.
- (NSString *)MyEidWarningCardNotFound;

/// Base translation: eID
- (NSString *)MyEidEid;

/// Base translation: https://www.politsei.ee/en/teenused/isikut-toendavad-dokumendid/id-kaart/taiskasvanule/
- (NSString *)MyEidIdCardInfoLink;

/// Base translation: Used:
- (NSString *)MyEidUseCount;

/// Base translation: Citizenship:
- (NSString *)MyEidCitizenship;

/// Base translation: My eID
- (NSString *)MyEidMyEid;

/// Base translation: Valid until:
- (NSString *)MyEidValidUntil;

/// Base translation: Signature certificate
- (NSString *)MyEidSignatureCertificate;

/// Base translation: %i times
- (NSString *(^)(int))MyEidTimesUsed;
/// Base translation: 1 time
- (NSString *)MyEidUsedOnce;

/// Base translation: SIM settings
- (NSString *)TabSimSettings;

/// Base translation: Read more.
- (NSString *)MyEidFindMoreInfo;

/// Base translation: Personal data
- (NSString *)MyEidPersonalData;

/// Base translation: Not valid
- (NSString *)MyEidNotValid;

+ (_Localizations *)sharedInstance;

@end


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Macros

// Make localization to be easily accessible
#define Localizations [_Localizations sharedInstance]
