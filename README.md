# sideossdk

Sideos SDK for Self Sovereign Identity mobile applications

## Getting Started

Add the plugin as a dependency and then initiate it as follows:

# var sideossdkPlugin = await Sideossdk.create();

This ensures the plugin is initialized and ready to be used. 


# Available functions are desccribed below.

## String getLocalDid()
Retrieve the DID (did:key:<version>:<publicKeyB64>) for this device.

## String signVC(String vc)
Returns a signed JWT. The vc must be a valid JSON object serialized.

## String verifyVC(String vc, String signature) {
Returns a true/false result whether the VC was verified with the specific signature.

## String getSharedKeyPair()
Diffie Hellmann shared keypair to secure cryptiing/decrypting messages.

## String cryptDataExt(String key, String data)
Using the shared key pair public key crypts the data.

## String decryptDataExt(String key, String data)
Using the shared key pair private key decrypts the data

## String deriveSharedKey(String prKey, String puKey)
Usinig the private key of the shared keypair, and the other entity public key creates the derived shared key to crypt and decrypt data

## String getVerifiableCredentials()
Returns an array of saved Verifiable Credentials

## String saveVerifiableCredential(String vc, String type) 
Saves a Verifiable Credential (see VerifiableCredential object) with a speccific type.

## String deleteVerifiableCredential(String vc) 
Deletes a stored Verifiable Credential given the UID as string.

## String respondToServer(String url, String payload) 
Helper function to send a POST request to the url with the payload as a JWT.

## String parseVC(String vc)
Parses and verifies a VC signature. Returns true/false. It also resolves the ISSUER DID for both did:key and did:sideos DIDs.

## String signAcceptanceJWT(String jwt, String destinationDID, String challenge)
Creates a Verifiable Presentation to accept an offer of a VC which includes the destination DID and the signature. The jwt parameter is actually the received credential offer including the PROOF. The challenge is needed to make sure the receiver can check the correct signature of the newly created JWT and not a copy.

## String signSharedJWT(String jwt, String destinationDID, String challenge)
Creates a Verifiable Presentation to share a request of a VC which includes the destination DID and the signature. The jwt parameter is actually the stored credential requested including the PROOF.
The challenge is needed to make sure the receiver can check the correct signature of the newly created JWT and not a copy.

## String parseJWT(String jwt) 
Given a JWT verifies it and returns the content as HEADER, PAYLOAD and SIGNATURE.
