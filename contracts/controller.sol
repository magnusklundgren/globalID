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

}
