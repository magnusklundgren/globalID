pragma solidity ^0.4.24;

contract User {
  address main;
  string pub;
  bytes32 biometrics; //This is encrypted.
  string name;
  bytes32 id;

  //events
  event ReturnBool(bool res);

  function getMain() public returns(address){
    return main;
  }

  function getPub() public returns(string){
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

  constructor(string _pubUser,  bytes32 _biometrics, string _name, bytes32 _id)
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
