pragma solidity ^0.4.24;


contract Controller {
  address entityAddress;

  /*events*/
  event ReturnBool(bool res);

  constructor(){
    entityAddress = msg.sender;
  }

  mapping(address => bool) verifiedUsers;

  modifier isMain(address _userMain) {
    require(msg.sender == _userMain);
    _;

  }

  // modifier doesExist(address _user) public {
  //
  // }

  function verifyUser(address _userPub, address _userMain)
  public isMain(_userMain) {
    verifiedUsers[_userPub] = true;
  }

  function revokeVerification(address _userPub, address _userMain)
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

contract MainController is Controller {

    /*events*/
    event ReturnPub(address _publickKey);

    mapping(address => bool) public userList;

    function generatePub() public returns (address, address){
      // Generate new public-private keypair
      // Right now it's just some random address for illustration.
      address publicKey = 0x753cDAB021dE31A6D4945a865FC04aCfE1c6f1a9;
      address privateKey = 0x753cDAB021dE31A6D4945a865FC04aCfE1c6f1a9;

      emit ReturnPub(publicKey);
      return (publicKey, privateKey);
    }

    function update(User _user) public {
      address publicKey;
      address privateKey;
      (publicKey, privateKey) = generatePub();
      // _user.pub = publicKey; // fix overwriting values in other contracts
      // Do something here to extract privateKey to user, while not putting it
      // on the blockchain
    }

    function killUser(User _user) public {
      //Do something else than overwriting values maybe
      // _user.pub = 0x0;
      // _user.main = 0x0;
      // _user.biometrics = 0;
      // _user.name = "";
      // _user.id = 0;

      //it doesn't seem straighforward to overwrite in a contract.
      bool user = true;
      bool dead = true;

    }

    function addUser(bytes32 _biometrics, string _name, bytes32 _id) public {
      address publicKey;
      address privateKey;
      (publicKey, privateKey) = generatePub();
      address newUser = new User(publicKey, _biometrics, _name, _id);
      userList[publicKey] = true;
      //send _privateKey to the user.
    }

    function auth(address _privateKey, bytes32 _bio) public returns(bool) {
      //decrypt bio;
      //bool res = (biometrics == _bio); //check decrypted biometrics with parsed variable _bio
      bool res = true;
      emit ReturnBool(res);
      return res;
    }

    function transferMain(User _user, address _newMain) public {
      revokeVerification(_user.getPub(), _user.getMain());
      //_user.main = _newMain; //Again, find way to overwrite
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

  //events
  event ReturnBool(bool res);

  function getMain() public returns(address){
    return main;
  }

  function getPub() public returns(address){
    return pub;
  }

  function getID() public returns(bytes32){
    return id;
  }

  function getName() public returns(string){
    return name;
  }

  function getBio() public returns(bytes32){
    return biometrics;
  }

  struct hashEntry{
    bytes32 dataHash;
    bytes32 keyHash;
    // mapping(address => bytes32) public dataHashes; //mapping id -> data hash
  }

  address[] whitelist;
  mapping(address => hashEntry) public hashes; //mapping id -> symmetric key hash

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

  function addWhitelist(address _subKey)
    public notMain(_subKey) returns(bool){
      for (uint i = 0; i < whitelist.length; i++){
        if (whitelist[i] == _subKey){
          emit ReturnBool(false);
          return false;
        }
      }
      whitelist.push(_subKey);
      emit ReturnBool(true);
      return true;
  }

  function removeWhiteList(address _subKey) public notMain(_subKey) returns(bool){
    //Right now this leaves an empty index in the array.
    //Can be optimized to reduce array size.
    uint i = whitelist.length;
    while(i >= 0){
      if (whitelist[i] == _subKey){
        delete whitelist[i];
        emit ReturnBool(true);
        return true;
      }
    }
    emit ReturnBool(false);
    return false;
  }

  function addDocs(address _thirdParty, bytes32 _dataHash, bytes32 _keyHash) public {
    hashes[_thirdParty] = hashEntry(_dataHash, _keyHash);
  }

  function removeDocs(address _thirdParty) public {
    delete(hashes[_thirdParty]);
  }

}
