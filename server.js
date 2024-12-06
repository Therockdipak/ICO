require("dotenv").config();

const express = require("express");
const bodyParser = require("express");
const {ethers} = require("ethers"); 

const app = express();
const PORT = 3000;

// middleware
app.use(express.json());

// Load environment variable
const PRIVATE_KEY = process.env.PRIVATE_KEY;
// const INFURA_API_URL = process.env.INFURA_API_URL;
const rpcEndpoints = "http://127.0.0.1:8545";
const CONTRACT_ADDRESS = process.env.ICO_CONTRACT_ADDRESS;

//setup provider and wallet 
const provider = new ethers.JsonRpcProvider(rpcEndpoints);
const wallet = new ethers.Wallet(PRIVATE_KEY,provider);

// ICO contract abi 
const ICOabi = 
  [
    {
      "inputs": [],
      "name": "BurnUnsoldTokens",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "_USDTamount",
          "type": "uint256"
        }
      ],
      "name": "PreSale1",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "_USDTamount",
          "type": "uint256"
        }
      ],
      "name": "preSale2",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_token",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "_usdt",
          "type": "address"
        },
        {
          "internalType": "uint256",
          "name": "_rate",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "_icoStart",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "_icoEnd",
          "type": "uint256"
        }
      ],
      "stateMutability": "nonpayable",
      "type": "constructor"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "address",
          "name": "buyer",
          "type": "address"
        },
        {
          "indexed": false,
          "internalType": "uint256",
          "name": "amount",
          "type": "uint256"
        }
      ],
      "name": "TokenBought",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "internalType": "uint256",
          "name": "amount",
          "type": "uint256"
        }
      ],
      "name": "unsoldTokensBurned",
      "type": "event"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "name": "balances",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "icoEnd",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "icoStart",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "owner",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "preSaleAmount",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "preSaleAmount2",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "rate",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "token",
      "outputs": [
        {
          "internalType": "contract Token",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "tokenSold",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "treasury",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "usdt",
      "outputs": [
        {
          "internalType": "contract Token2",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    }
  
];

const contract = new ethers.Contract(
    CONTRACT_ADDRESS,
    ICOabi, 
    wallet
);

// Buy preSale tokens
app.post("/buy-presale1", async (req, res) => {
    const {usdtAmount, buyerAddress} = req.body;

    if(!usdtAmount || !buyerAddress) {
        return res.status(400).send({error: "invalid input data"});
    }

    try {
    console.log("usdtAmount:", usdtAmount);
    console.log("buyerAddress:", buyerAddress);
    const tx = await contract.PreSale1(ethers.parseUnits(usdtAmount.toString(), 18));
    console.log("Transaction Sent:", tx);
    await tx.wait();
    console.log("Transaction Mined:", tx.hash);

    res.status(200).send({
        message: "Tokens bought successfully!",
        txHash: tx.hash,
    });
} catch (error) {
    console.error("Error in PreSale1: ", error);
    res.status(500).send({ error: "Failed to buy tokens" });
}

});  

//   burn unsold tokens
app.post("/burn-unsold-tokens", async (req, res) => {
    try {
         const tx = await contract.BurnUnsoldTokens();
         await tx.wait();

         res.status(200).send({
            message: "unsold tokens burned sucessfully!",
            txHash: tx.hash,
         });
    } catch(error) {
        console.error("error in burnUnsold tokens", error);
        res.status(500).send({error:"failed to burn unsold tokens"});
    }
});

//  start the server 
app.listen(PORT,(res, req)=> {
    console.log(`Server running on http://localhost:${PORT}`);
});