pragma solidity ^0.4.24;

contract Controller {
  address entityAddress;

  /*events*/
  event ReturnBool(bool res);

  constructor(){
    entityAddress = msg.sender;
  }

  mapping(string => bool) verifiedUsers;

  modifier isMain(address _userMain) {
    require(msg.sender == _userMain);
    _;

  }

  // modifier doesExist(address _user) public {
  //
  // }

  function verifyUser(string _userPub, address _userMain)
  public isMain(_userMain) {
    verifiedUsers[_userPub] = true;
  }

  function revokeVerification(string _userPub, address _userMain)
  public isMain(_userMain) {
    verifiedUsers[_userPub] = false;
  }

  // function mappingMain() public {
  //
  // }
  //
  // function mappingSubs() public {
  //
  // }

}
