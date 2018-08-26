pragma solidity ^0.4.24;

contract User {
  address main;
  string pub;
  bytes32 biometrics; //This is encrypted.
  string name;
  bytes32 id;
  bool dead;


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
  mapping(address => hashEntry) public hashes;
  mapping(address => bool) whitelist;


  //modifiers
  modifier notMain(address _subKey) {
    assert(_subKey != main);
    _;
  }

  modifier isMain() {
    assert(msg.sender == main);
    _;
  }

  modifier validSender(address sender){
    //require (msg.sender == sender || msg.sender == pub);
    assert (msg.sender == sender);
    _;
  }

  modifier isWhitelist(address _subKey) {
    assert (whitelist[_subKey]);
      _;
  }

  constructor(string _pubUser,  bytes32 _biometrics, string _name, bytes32 _id)
  public {
    main = msg.sender;
    pub  = _pubUser;
    biometrics = _biometrics;
    name = _name;
    id = _id;
    dead = false;
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

  function getBio() public returns(string){
    emit ReturnBytes(bio);
    return bio;
  }

  function getName() public returns(string){
    emit ReturnStr(name);
    return name;
  }

  function getID() public returns(bytes32){
    emit ReturnBytes(id);
    return id;
  }

  function getDead() public returns(string){
    emit ReturnBool(dead);
    return dead;
  }


  function killUser() public isMain {
      dead = true;
  }

  function transferMain(address _newMain) public {
    main = _newMain;
  }

  function updatePublic(string _pubKey) public isMain {
    pub = _pubKey;
  }

  function readSymKey(address hashID) {
    bytes32 hashedKey = hashes[hashID].keyHash;

    //bytes32 symKey = decrypt(hashedKey, privateKey);
  }

  function addWhitelist(address _subKey) public returns(bool) {
    if (whitelist[_subKey]) {
      emit ReturnBool(false);
      return false;
    }
    whitelist[_subKey] = true;
    emit ReturnBool(true);
    return true;
  }

  function removeWhiteList(address _subKey) public notMain(_subKey) returns(bool) {
    if (whitelist[_subKey]) {
      // Setting it to false is the same as delete.
      whitelist[_subKey] = false;
      emit ReturnBool(true);
      return true;
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
