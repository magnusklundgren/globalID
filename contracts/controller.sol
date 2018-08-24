pragma solidity ^0.4.24;

contract Controller {
  address entityAddress;

  //events
  event ReturnBool(bool res);

  //mappings
  mapping(string => bool) verifiedUsers;

  //modifiers
  modifier isMain(address _userMain) {
    require(msg.sender == _userMain);
    _;
  }

  constructor(){
    entityAddress = msg.sender;
  }

  function verifyUser(string _userPub, address _userMain)
  public isMain(_userMain) {
    verifiedUsers[_userPub] = true;
  }

  function revokeVerification(string _userPub, address _userMain)
  public isMain(_userMain) {
    verifiedUsers[_userPub] = false;
  }

}
