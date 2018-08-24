const ora = require("ora")
const parseArgs = require("minimist")

const {
  Qtum,
} = require("qtumjs")

const repoData = require("../solar.development.json")
const qtum = new Qtum("http://qtum:test@localhost:3889", repoData)
const myToken = qtum.contract("../globalID/contracts/globalID.sol")

async function addWhitelist(_subKey, _hashData, _hashKey) {
    var params = [_subKey, _hashData, _hashKey]
    const res = await myToken.send("addWhitelist", params)
    console.log("waiting for transaction confirmation")
    const receipt = await res.confirm(1, (updatedTx) => {
	console.log("new confirmation", updatedTx.txid, updatedTx.confirmations)
    })
    console.log("tx receipt:", JSON.stringify(receipt, null, 2))
    var returned = await myToken.receipt(res.txid);
    var vals = returned.logs[0];
    if vals['res'] {
	console.log("Transaction completed")
    }else{
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
    if vals['res'] {
	console.log("Transaction completed")
    }else{
	console.log("Entry already exists")
    }
    return vals['res'];
}


async function main() {
  const argv = parseArgs(process.argv.slice(2))

  const cmd = argv._[0]

  if (process.env.DEBUG) {
    console.log("argv", argv)
    console.log("cmd", cmd)
  }

    switch (cmd) {
    case "removeWhiteList":
	var _subKey = argv._[1]
	if (!_subKey) {
            throw new Error("please type a new entry")
	}
	await removeWhiteList(_subKey)
	break
    case "addWhitelist":
	var subKey = argv._[1]
    	var hashData = argv._[2]
    	var hashKey = argv._[3]
    	if (!hashData || !hashKey || !subKey) {
    	    throw new Error("Please give three parameters")
    	}
	await addWhitelist(subKey, hashData, hashKey)
	break
    // case "newPermanentEntry":
    // 	const hex1 = argv._[1]
    // 	if (!hex1) {
    //         throw new Error("please type a new entry")
    // 	}
    // 	await newPermanentEntry(hex1)
    // 	break
    // case "addToWhitelist":
    // 	const addr = argv._[1]
    // 	if (!addr) {
    // 	    throw new Error("Please give an address")
    // 	}
    // 	await addToWhitelist(addr)
    // 	break
    // case "removeFromWhitelist":
    // 	const addr1 = argv._[1]
    // 	if (!addr1) {
    // 	    throw new Error("Please give an address")
    // 	}
    // 	await removeFromWhitelist(addr1)
    // 	break
    // case "denyEntry":
    // 	const addr2 = argv._[1]
    // 	const index2 = argv._[2]
    // 	const permanent2 = argv._[3]
    // 	if (!addr2 || !permanent2) {
    // 	    throw new Error("Please give three parameters {string, int, bool}")
    // 	}
    // 	await denyEntry(addr2, index2, permanent2)
    // 	break
    // case "acceptEntry":
    // 	const addr3 = argv._[1]
    // 	const index3 = argv._[2]
    // 	const permanent3 = argv._[3]
    // 	console.log(addr3)
    // 	if (!addr3 || !permanent3) {
    // 	    throw new Error("Please give three parameters {string, int, bool}")
    // 	}
    // 	await acceptEntry(addr3, index3, permanent3)
    // 	break
    // case "proveID":
    // 	await proveID()
    // 	break
    default:
      console.log("unrecognized command", cmd)
  }
}

main().catch(err => {
  console.log("error", err)
})
