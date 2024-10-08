const ora = require("ora")
const parseArgs = require("minimist")

const {
  Qtum,
} = require("qtumjs")

const repoData = require("./solar.development.json")
const qtum = new Qtum("http://qtum:test@localhost:3889", repoData)
const myToken = qtum.contract("mainController.sol")

async function update(_user){
    var params = [_user]
    const res = await myToken.send("update", params)
    console.log("waiting for transaction confirmation")
    const receipt = await res.confirm(1, (updatedTx) => {
	console.log("new confirmation", updatedTx.txid, updatedTx.confirmations)
    })
    console.log("tx receipt:", JSON.stringify(receipt, null, 2))
    console.log("Transaction completed")
}
async function killUser(_user){
    var params = [_user]
    const res = await myToken.send("killUser", params)
    console.log("waiting for transaction confirmation")
    const receipt = await res.confirm(1, (updatedTx) => {
	console.log("new confirmation", updatedTx.txid, updatedTx.confirmations)
    })
    console.log("tx receipt:", JSON.stringify(receipt, null, 2))
    console.log("Transaction completed")
}

async function addUser(_biometrics, _name, _id){
    var params = [_biometrics, _name, _id]
    const res = await myToken.send("addUser", params)
    console.log("waiting for transaction confirmation")
    const receipt = await res.confirm(1, (updatedTx) => {
	console.log("new confirmation", updatedTx.txid, updatedTx.confirmations)
    })
    console.log("tx receipt:", JSON.stringify(receipt, null, 2))
    console.log("Transaction completed")
}

async function auth(_privateKey,_bio){
    var params = [_privateKey, _bio]
    const res = await myToken.send("auth", params)
    console.log("waiting for transaction confirmation")
    const receipt = await res.confirm(1, (updatedTx) => {
	console.log("new confirmation", updatedTx.txid, updatedTx.confirmations)
    })
    console.log("tx receipt:", JSON.stringify(receipt, null, 2))
    console.log("Transaction completed")
    var returned = await myToken.receipt(res.txid);
    var vals = returned.logs[0];
    var retval = vals['res'];
    if(retval) {
	console.log("User authenticated")
    }
    else{
	console.log("Uset NOT authenticated")
    }
    return retval;
}

async function main() {
    var user = '5c61a543910b554fc5c64436df996cfa9e0023f2';
    await update(user);
    auth('1234','5c61a543910b554');

    await killUser(user);

  // const argv = parseArgs(process.argv.slice(2))

  // const cmd = argv._[0]

  // if (process.env.DEBUG) {
  //   console.log("argv", argv)
  //   console.log("cmd", cmd)
  // }

  //   switch (cmd) {
  //   case "update":
  //   	var _user = argv._[1]
  //   	if (!_user) {
  //           throw new Error("please type a new entry")
  //   	}
  //   	await update(_user)
  //   	break
  //   case "killUser":
  //   	var _user = argv._[1]
  //   	if (!_user) {
  //           throw new Error("please type a new entry")
  //   	}
  //   	await killUser(_user)
  //   	break
  //   case "addUser":
  // 	var _biometrics = argv._[1]
  // 	var _name = argv._[2]
  //    	var _id = argv._[3]
  //   	if (!_name || !_id) {
  //    	    throw new Error("Please give three parameters")
  //   	}
  //   	await addUser(_biometrics, _name, _id)
  //   	break
  //   case "auth":
  //   	var _privateKey = argv._[1]
  // 	var _bio = argv._[2]
  //   	if (!_privateKey || !_bio) {
  //   	    throw new Error("Please two parameters")
  //   	}
  //   	await auth(_privateKey, _bio)
  //   	break
  //   default:
  //     console.log("unrecognized command", cmd)
  // }
}

main().catch(err => {
  console.log("error", err)
})
