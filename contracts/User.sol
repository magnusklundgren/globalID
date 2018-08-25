pragma solidity ^0.4.24;

contract User {
  address main;
  string pub;
  bytes32 biometrics; //This is encrypted.
  string name;
  bytes32 id;

  address[] whitelist;

  struct hashEntry{
    bytes32 dataHash;
    bytes32 keyHash;
  }

  //events
  event ReturnBool(bool res);
  event ReturnAddr(address res);
  event ReturnStr(string res);
  event ReturnBytes(bytes32 res);

  //mappings
  mapping(address => hashEntry) public hashes; //mapping id -> symmetric key hash

  //modifiers
  modifier notMain(address _subKey) {
    require(_subKey != main);
    _;
  }

  modifier isMain() {
    require(msg.sender == main);
    _;
  }

  /*msg.sender is address, and pub is string, resulting in TypeError*/
  // modifier isPub() {
  //   require(msg.sender == pub);
  //   _;
  // }
  modifier isPub(){
      _;
  }

  modifier validSender(address sender){
    //require (msg.sender == sender || msg.sender == pub);
    require (msg.sender == sender);
    _;
  }

  modifier isWhitelist(address _subKey) {
    /*TypeError*/
    //if (_subKey == pub){
    //  _;
    // return;
    //}
    for(uint i = 0; i < whitelist.length; i++){
      if (whitelist[i] == _subKey){
        _;
      }
    }
  }

  constructor(string _pubUser,  bytes32 _biometrics, string _name, bytes32 _id)
  public {
    main = msg.sender;
    pub  = _pubUser;
    biometrics = _biometrics;
    name = _name;
    id = _id;
    addWhitelist(main);
  }

  function getMain() public returns(address){
    emit ReturnAddr(main);
    return main;
  }

  function getPub() public returns(string){
    emit ReturnStr(pub);
    return pub;
  }

  function getID() public returns(bytes32){
    emit ReturnBytes(id);
    return id;
  }

  function getName() public returns(string){
    emit ReturnStr(name);
    return name;
  }

  function getBio() public returns(bytes32){
    emit ReturnBytes(biometrics);
    return biometrics;
  }

  function killUser() public isMain {
    //Do something else than overwriting values maybe
    pub = "empty";
    main = 0x0;
    biometrics = 0x123;
    name = "";
    id = 0x123;
  }

  function transferMain(address _newMain) public {
    main = _newMain;
  }

  function updatePublic(string _pubKey) public isMain {
    pub = _pubKey;
  }

  function readSymKey(address hashID) isPub{
    bytes32 hashedKey = hashes[hashID].keyHash;

    //bytes32 symKey = decrypt(hashedKey, privateKey);
  }

  function addWhitelist(address _subKey)
    public returns(bool){
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
    for (uint i = 0; i < whitelist.length; i++){
      if (whitelist[i] == _subKey){
        delete whitelist[i];
        emit ReturnBool(true);
        return true;
      }
    }
    emit ReturnBool(false);
    return false;
  }

  function addDocs(address _thirdParty, bytes32 _dataHash, bytes32 _keyHash)
  public isWhitelist(_thirdParty) validSender(_thirdParty) {
    hashes[_thirdParty] = hashEntry(_dataHash, _keyHash);
  }

  function removeDocs(address _thirdParty)
  public isWhitelist(_thirdParty) validSender(_thirdParty) {
    delete(hashes[_thirdParty]);
  }

}
