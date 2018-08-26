pragma solidity ^0.4.24;

contract User {
  address main;
  string pub; //Public key
  bytes32 biometrics; //This is encrypted.
  string name;
  bytes32 id; //Unique identifier for every individual
  bool dead;

  //For saving hashes of the data and the symmeytric key
  //Mapped to the address of the provider.
  struct hashEntry{
    bytes32 dataHash;
    bytes32 keyHash;
  }

  //events to return values for the interface
  event ReturnBool(bool res);
  event ReturnAddr(address res);
  event ReturnStr(string res);
  event ReturnBytes(bytes32 res);

  //mappings
  mapping(address => hashEntry) public hashes;
  mapping(address => bool) whitelist;

  //modifiers
  modifier notMain(address _subKey) {
    require(_subKey != main);
    _;
  }

  modifier isMain() {
    require(msg.sender == main);
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

  //Getter functions for all attributes.
  function getMain() public returns(address){
    emit ReturnAddr(main);
    return main;
  }

  function getPub() public returns(string){
    emit ReturnStr(pub);
    return pub;
  }

  function getBio() public returns(bytes32){
    emit ReturnBytes(biometrics);
    return biometrics;
  }

  function getName() public returns(string){
    emit ReturnStr(name);
    return name;
  }

  function getID() public returns(bytes32){
    emit ReturnBytes(id);
    return id;
  }

  function getDead() public returns(bool){
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

  function readSymKey(address hashID) private {
    bytes32 hashedKey = hashes[hashID].keyHash;

    //bytes32 symKey = decrypt(hashedKey, privateKey);
    //return symKey;
  }

  //adds a new address, _subKey, to the whitelist
  function addWhitelist(address _subKey) public returns(bool) {
    if (whitelist[_subKey]) {
      emit ReturnBool(false);
      return false;
    }
    whitelist[_subKey] = true;
    emit ReturnBool(true);
    return true;
  }

  //removes address, _subKey, from the whitelist as long as it is not the main address
  function removeWhiteList(address _subKey) public notMain(_subKey) returns(bool) {
    if (whitelist[_subKey]) {
      // Setting it to false has the same effect here as delete
      whitelist[_subKey] = false;
      emit ReturnBool(true);
      return true;
    }
    emit ReturnBool(false);
    return false;
  }

  //used to add an entry in the hashes mapping
  function addDocs(address _thirdParty, bytes32 _dataHash, bytes32 _keyHash)
  public isWhitelist(_thirdParty) validSender(_thirdParty) {
    hashes[_thirdParty] = hashEntry(_dataHash, _keyHash);
  }

  //removes an entry from the hashes mapping.
  function removeDocs(address _thirdParty)
  public isWhitelist(_thirdParty) validSender(_thirdParty) {
    delete(hashes[_thirdParty]);
  }

}
