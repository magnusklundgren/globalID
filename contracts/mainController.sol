pragma solidity ^0.4.24;
import "controller.sol";
import "User.sol";


contract mainController is Controller {

    /*events*/

    mapping(bytes32 => bool) public userList;

    function generatePub() private returns (string memory, string memory){
      // Generate new public-private keypair
      // Right now it's just some random address for illustration.
      return ("sdf", "sdf");
    }

    function update(User _user) public {
      /* string memory publicKey; */
      /* string memory privateKey; */
      (string memory publicKey, string memory privateKey) = generatePub();
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
      (string memory publicKey, string memory privateKey) = generatePub();
      address newUser = new User(publicKey, _biometrics, _name, _id);
      userList[_id] = true;
      //send _privateKey to the user.
    }

    function auth(string _privateKey, bytes32 _bio) public returns(bool) {
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
