pragma solidity ^0.4.24;
import "User.sol";

contract Controller {
  address entityAddress;

  //events
  event ReturnBool(bool res);

  //mappings
  mapping(bytes32 => bool) verifiedUsers;

  //modifiers
  /* modifier isMain(User _user) { */
  /*   address userMain = _user.getMain(); */
  /*   require(msg.sender == userMain); */
  /*   _; */
  /* } */

  constructor(){
    entityAddress = msg.sender;
  }

  //Verify a user in regards to the given controller.
  function verifyUser(User _user)
  public {
    User user = User(_user);
    bytes32 _userID = user.getID();
    verifiedUsers[_userID] = true;
    emit ReturnBool(true);
  }

  //encrypts the symmetric key with the public key of the user
  function revokeVerification(User _user)
  public {
    bytes32 _userID = _user.getID();
    verifiedUsers[_userID] = false;
    emit ReturnBool(true);
  }

  //encrypts the symmetric key with the public key of the user
  function hashKey(User _user, bytes32 _symKey) public returns(bytes32){
    string memory pubKey = _user.getPub();
    //bytes32 keyHashed = encrypt(_symKey, pubKey);
    bytes32 keyHashed = 0x5678; //simulated key
    return keyHashed;
  }

  //add entry in the _user's hashes mapping.
  function addDocs(User _user, bytes32 _symKey, bytes32 _dataHashed){
    bytes32 keyHashed = hashKey(_user, _symKey);
    _user.addDocs(entityAddress, _dataHashed, keyHashed);
    emit ReturnBool(true);
  }

  //Authorizes a user's credibility in accordance to their biometric data used at creation.
  function auth(string _privateKey, bytes32 _bio) public returns(bool) {
    //decrypt bio;
    //bool res = (biometrics == _bio); //check decrypted biometrics with parsed variable _bio
    bool res = true;
    emit ReturnBool(res);
    return res;
}

contract mainController is Controller {

  //mappings
  mapping(bytes32 => bool) public userList;

  function generatePub() private returns (string memory, string memory){
    // Generate new public-private keypair
    // Right now it's just some random address for illustration.
    return ("newpublickey", "newprivatekey");
  }

  function update(User _user) public {
    /* string memory publicKey; */
    /* string memory privateKey; */
    (string memory publicKey, string memory privateKey) = generatePub();
    _user.updatePublic(publicKey);
    emit ReturnBool(true);
    //send privateKey to user.
  }

  //Kill a user, and render contract unusable in the future
  //in case of physical death or similar.
  function killUser(User _user) public {
    bytes32 userID  = _user.getID();
    address userMain = _user.getMain();
    revokeVerification(_user);
    delete(userList[userID]);
    _user.killUser();
    emit ReturnBool(true);
  }


  //add a new user contract.
  function addUser(bytes32 _biometrics, string _name, bytes32 _id) public {
    (string memory publicKey, string memory privateKey) = generatePub();
    address newUser = new User(publicKey, _biometrics, _name, _id);
    userList[_id] = true;
    emit ReturnBool(true);
    //send _privateKey to the user. - find a way to implement this outside of blockchain
  }

  //changes the main controller of a user, and revokes their verification, until
  //verified by new main controller.
  function transferMain(User _user, address _newMain) public {
    revokeVerification(_user);
    _user.transferMain(_newMain);
    emit ReturnBool(true);
  }
}
