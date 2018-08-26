pragma solidity ^0.4.24;
import "User.sol";

contract Controller {
  address entityAddress;

  //events
  event ReturnBool(bool res);

  //mappings
  mapping(bytes32 => bool) verifiedUsers;

  //modifiers
  modifier isMain(address _userMain) {
    require(msg.sender == _userMain);
    _;
  }

  constructor(){
    entityAddress = msg.sender;
  }

  //Verify a user in regards to the given controller.
  function verifyUser(bytes32 _userID, address _userMain)
  public isMain(_userMain) {
    verifiedUsers[_userID] = true;
  }

  function revokeVerification(bytes32 _userID, address _userMain)
  public isMain(_userMain) {
    verifiedUsers[_userID] = false;
  }

  //encrypts the symmetric key with the public key of the user
  function hashKey(User _user, bytes32 _symKey) public returns(bytes32){
    string memory pubKey = _user.getPub();
    //bytes32 keyHashed = encrypt(_symKey, pubKey);
    bytes32 keyHashed = 0x5678; //simulated key
    return keyHashed;
  }

  function addDocs(User _user, bytes32 _symKey, bytes32 _dataHashed){
    bytes32 keyHashed = hashKey(_user, _symKey);
    _user.addDocs(entityAddress, _dataHashed, keyHashed);
  }

  //Authorizes a user's credibility in accordance to their biometric data used at creation.
  function auth(string _privateKey, bytes32 _bio) public returns(bool) {
    //decrypt bio;
    //bool res = (biometrics == _bio); //check decrypted biometrics with parsed variable _bio
    bool res = true;
    emit ReturnBool(res);
    return res;
  }

}
