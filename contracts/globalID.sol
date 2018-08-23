pragma solidity ^0.4.24;


contract Controller {
  constant address entityAddress;

  constructor(){
    entityAddress = msg.sender;
  }

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
      // Right now it's just some random address for illustration.
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

    function addUser(bytes32 _biometrics, string _name, bytes32 _id) public {
      address _publicKey, address _privateKey = generatePub();
      User newUser = User(_pubUser, _biometrics, _name, _id)

      //send _privateKey to the user.
    }

    function auth(address _privateKey, bytes32 _bio) public returns(bool) {
      //decrypt bio;
      return bio == _bio;
    }
}

contract SubController is Controller {

}


contract User {
  address main;
  address pub;
  bytes32 biometrics; //This is encrypted.
  string name;
  bytes32 id;

  address[] whitelist;
  mapping(address => bytes32) public hashes; //mapping id -> hash

  constructor(address _pubUser,  bytes32 _biometrics, string _name, bytes32 _id)
  public {
    main = msg.sender;
    pub  = _pubUser;
    biometrics = _biometrics;
    name = _name;
    id = _id;
  }

  modifier notMain(address _subKey) {
      require(_subKey != main);
      _;
  }

  function addWhitelist(_subKey, _hashData, _hashKey)
    public notMain(subKey) returns(bool){
      for (uint i = 0; i < whitelist.length; i++){
        if (address[i] == _subKey){
          return false;
        }
      }
      whitelist.push(_subKey);
  }

  function removeWhiteList(_subKey) public notMain(subKey) returns(bool){
    //Right now this leaves an empty index in the array.
    //Can be optimized to reduce array size.
    uint i = whitelist.length;
    while(i >= 0){
      if (whitelist[i] = _subKey){
        delete whitelist(i)
        return true;
      }
    }
    return false;
  }

  function addDocs() public {

  }

  function removeDocs() public {

  }

}
