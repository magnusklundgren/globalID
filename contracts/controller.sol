pragma solidity ^0.4.24;

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

  function verifyUser(bytes32 _userID, address _userMain)
  public isMain(_userMain) {
    verifiedUsers[_userID] = true;
  }

  function revokeVerification(bytes32 _userID, address _userMain)
  public isMain(_userMain) {
    verifiedUsers[_userID] = false;
  }

  function hashKey(User _user, _symKey) public {
    string pubKey = _user.getPub();
    //bytes32 keyHashed = encrypt(_symKey, pubKey);
    bytes32 keyHashed = 0x5678
    return keyHashed;
  }

  function addDocs(User _user, _symKey, _dataHashed){
    bytes32 keyHashed = hashKey(_user, _symKey);
    _user.addDocs(entityAddress, _dataHashed, keyHashed);
  }

}
