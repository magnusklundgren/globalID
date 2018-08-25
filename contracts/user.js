const ora = require("ora")
const parseArgs = require("minimist")

const {
  Qtum,
} = require("qtumjs")

const repoData = require("./solar.development.json")
const qtum = new Qtum("http://qtum:test@localhost:3889", repoData)
const myToken = qtum.contract("User.sol")

async function getPub() {
    const res = await myToken.send("getPub")
    console.log("waiting for transaction confirmation")
    const receipt = await res.confirm(1, (updatedTx) => {
	console.log("new confirmation", updatedTx.txid, updatedTx.confirmations)
    })
    console.log("tx receipt:", JSON.stringify(receipt, null, 2))
    var returned = await myToken.receipt(res.txid);
    var vals = returned.logs[0];
    var retval = vals['res'];
    console.log(retval);
    return retval;
}

async function getID() {
    const res = await myToken.send("getID")
    console.log("waiting for transaction confirmation")
    const receipt = await res.confirm(1, (updatedTx) => {
	console.log("new confirmation", updatedTx.txid, updatedTx.confirmations)
    })
    console.log("tx receipt:", JSON.stringify(receipt, null, 2))
    var returned = await myToken.receipt(res.txid);
    var vals = returned.logs[0];
    var retval = vals['res'];
    console.log(retval);
    return retval;
}

async function getMain() {
    const res = await myToken.send("getMain")
    console.log("waiting for transaction confirmation")
    const receipt = await res.confirm(1, (updatedTx) => {
	console.log("new confirmation", updatedTx.txid, updatedTx.confirmations)
    })
    console.log("tx receipt:", JSON.stringify(receipt, null, 2))
    var returned = await myToken.receipt(res.txid);
    var vals = returned.logs[0];
    var retval = vals['res'];
    console.log(retval);
    return retval;
}

// async function readSymKey(hashID) {
//     var params = [hashID]
//     const res = await myToken.send("readSymKey", params)
//     console.log("waiting for transaction confirmation")
//     const receipt = await res.confirm(1, (updatedTx) => {
// 	console.log("new confirmation", updatedTx.txid, updatedTx.confirmations)
//     })
//     console.log("tx receipt:", JSON.stringify(receipt, null, 2))
//     var returned = await myToken.receipt(res.txid);
//     var vals = returned.logs[0];
//     if vals['res'] {
// 	console.log("Transaction completed")
//     }else{
// 	console.log("Entry already exists")
//     }
//     return vals['res'];
// }

async function addWhitelist(_subKey) {
    var params = [_subKey]
    const res = await myToken.send("addWhitelist", params)
    console.log("waiting for transaction confirmation")
    const receipt = await res.confirm(1, (updatedTx) => {
	console.log("new confirmation", updatedTx.txid, updatedTx.confirmations)
    })
    console.log("tx receipt:", JSON.stringify(receipt, null, 2))
    var returned = await myToken.receipt(res.txid);
    var vals = returned.logs[0];
    if(vals['res']) {
	console.log("Transaction completed")
    }
    else{
	console.log("Entry already exists")
    }
    return vals['res'];
}

async function removeWhiteList(_subKey) {
    var params = [_subKey]
    const res = await myToken.send("removeWhiteList", params)
    console.log("waiting for transaction confirmation")
    const receipt = await res.confirm(1, (updatedTx) => {
	console.log("new confirmation", updatedTx.txid, updatedTx.confirmations)
    })
    console.log("tx receipt:", JSON.stringify(receipt, null, 2))
    var returned = await myToken.receipt(res.txid);
    var vals = returned.logs[0];
    if(vals['res']) {
	console.log("Transaction completed")
    }
    else{
	console.log("Entry does not exists")
    }
    return vals['res'];
}


async function main() {

    await getPub();
    await getID();
    await getMain();
    await addWhitelist('3c11fd266d4b97c521e0a5bbd998fb37eb53ac58');
    await removeWhiteList('3c11fd266d4b97c521e0a5bbd998fb37eb53ac58');
    await removeWhiteList('3c11fd266d4b97c521e0a5bbd998fb37eb53ac58');

}

main().catch(err => {
  console.log("error", err)
})
