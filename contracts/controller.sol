pragma solidity ^0.4.24;


contract Controller {
  constant address entityAddress;

  mapping(address => bool) verifiedUsers;

  function verifyUser(address _userPub) public {
    verifiedUsers[_userPub] = true;
  }

  function revokeVerification() public {
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

contract MainController is Controller {

    function generatePub() public returns (address publicKey, address privateKey){
      // Generate new public-private keypair

      publicKey = 0x753cDAB021dE31A6D4945a865FC04aCfE1c6f1a9;
      privateKey = 0x753cDAB021dE31A6D4945a865FC04aCfE1c6f1a9;
    }

    function update(User _user) public {
      address publicKey, address privateKey = generatePub();
      _user.pub = publicKey;
      // Do something here to extract privateKey to user, while not putting it
      // on the blockchain
    }

    function killUser(User _user) public {
      //Do something else than overwriting values maybe
      _user.pub = null;
      _user.main = null;
      _user.biometrics = null;
      _user.name = null;
      _user.id = null;

    }

    function addUser(address _pubUser) public {

    }

    function auth(address _privateKey, bytes32 _bio) public returns(bool) {

    }
}

contract SubController is Controller {

}


contract User {
  address pub;
  address main;
  bytes32 biometrics;
  string name;
  bytes32 id;

  address[] whitelist;
  mapping(address => bytes32) public hashes; //mapping id -> hash

  constructor(){

  }

  function

}
