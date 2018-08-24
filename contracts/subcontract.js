const ora = require("ora")
const parseArgs = require("minimist")

const {
  Qtum,
} = require("qtumjs")

const repoData = require("../solar.development.json")
const qtum = new Qtum("http://qtum:test@localhost:3889", repoData)
const myToken = qtum.contract("../globalID/contracts/globalID.sol")

async function addWhitelist(_subKey, _hashData, _hashKey){
    var params = [_subKey, _hashData, _hashKey]
    const res = await myToken.send("addWhitelist", params)
    console.log("waiting for transaction confirmation")
    const receipt = await res.confirm(1, (updatedTx) => {
	console.log("new confirmation", updatedTx.txid, updatedTx.confirmations)
    })
    console.log("tx receipt:", JSON.stringify(receipt, null, 2))
    console.log("Transaction completed")
}

async function removeWhiteList(_subKey){
    var params = [_subKey]
    const res = await myToken.send("removeWhiteList", params)
    console.log("waiting for transaction confirmation")
    const receipt = await res.confirm(1, (updatedTx) => {
	console.log("new confirmation", updatedTx.txid, updatedTx.confirmations)
    })
    console.log("tx receipt:", JSON.stringify(receipt, null, 2))
    console.log("Transaction completed")
}

async function addDocs(){
    var params = []
    const res = await myToken.send("addDocs", params)
    console.log("waiting for transaction confirmation")
    const receipt = await res.confirm(1, (updatedTx) => {
	console.log("new confirmation", updatedTx.txid, updatedTx.confirmations)
    })
    console.log("tx receipt:", JSON.stringify(receipt, null, 2))
    console.log("Transaction completed")
}

async function removeDocs(){
    var params = []
    const res = await myToken.send("removeDocs", params)
    console.log("waiting for transaction confirmation")
    const receipt = await res.confirm(1, (updatedTx) => {
	console.log("new confirmation", updatedTx.txid, updatedTx.confirmations)
    })
    console.log("tx receipt:", JSON.stringify(receipt, null, 2))
    console.log("Transaction completed")
}

async function main() {
  const argv = parseArgs(process.argv.slice(2))

  const cmd = argv._[0]

  if (process.env.DEBUG) {
    console.log("argv", argv)
    console.log("cmd", cmd)
  }

    switch (cmd) {
    case "addWhitelist":
	var _subKey = argv._[1]
	var _hashData = argv._[2]
     	var _hashKey = argv._[3]
    	if (!_hashData || ! _hashKey) {
     	    throw new Error("Please give three parameters")
    	}
    	await addWhitelist(_subKey , _hashData, _hashKey)
    	break
    case "removeWhiteList":
	var _subKey = argv._[1]
    	if (!_subKey) {
     	    throw new Error("Please give one parameter")
    	}
    	await removeWhiteList(_subKey)
    	break
    case "addDocs":
	var _subKey = argv._[1]
    	if (!_subKey) {
     	    throw new Error("Please give one parameter")
    	}
    	await addDocs()
    	break
    case "removeDocs":
	var _subKey = argv._[1]
    	if (!_subKey) {
     	    throw new Error("Please give one parameter")
    	}
    	await removeDocs()
    	break
    default:
      console.log("unrecognized command", cmd)
  }
}

main().catch(err => {
  console.log("error", err)
})
