export const KeyManagementAbi = [
  {
    "type": "constructor",
    "inputs": [
      {
        "name": "fieldSize",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "Q",
    "inputs": [],
    "outputs": [
      {
        "name": "",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "callback",
    "inputs": [],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "initialize",
    "inputs": [],
    "outputs": [
      {
        "name": "",
        "type": "bytes",
        "internalType": "bytes"
      }
    ],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "initializeCallback",
    "inputs": [
      {
        "name": "record",
        "type": "tuple",
        "internalType": "struct Suave.DataRecord",
        "components": [
          {
            "name": "id",
            "type": "bytes16",
            "internalType": "Suave.DataId"
          },
          {
            "name": "salt",
            "type": "bytes16",
            "internalType": "Suave.DataId"
          },
          {
            "name": "decryptionCondition",
            "type": "uint64",
            "internalType": "uint64"
          },
          {
            "name": "allowedPeekers",
            "type": "address[]",
            "internalType": "address[]"
          },
          {
            "name": "allowedStores",
            "type": "address[]",
            "internalType": "address[]"
          },
          {
            "name": "version",
            "type": "string",
            "internalType": "string"
          }
        ]
      }
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "sanityCheck",
    "inputs": [
      {
        "name": "keyShares",
        "type": "uint256[]",
        "internalType": "uint256[]"
      }
    ],
    "outputs": [
      {
        "name": "",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "signTransaction",
    "inputs": [
      {
        "name": "txCalldata",
        "type": "bytes",
        "internalType": "bytes"
      },
      {
        "name": "chainId",
        "type": "string",
        "internalType": "string"
      }
    ],
    "outputs": [
      {
        "name": "",
        "type": "bytes",
        "internalType": "bytes"
      }
    ],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "signTransactionCallback",
    "inputs": [
      {
        "name": "signedTx",
        "type": "bytes",
        "internalType": "bytes"
      }
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "submitShares",
    "inputs": [
      {
        "name": "shares",
        "type": "uint256[]",
        "internalType": "uint256[]"
      }
    ],
    "outputs": [
      {
        "name": "",
        "type": "bytes",
        "internalType": "bytes"
      }
    ],
    "stateMutability": "nonpayable"
  },
  {
    "type": "error",
    "name": "PeekerReverted",
    "inputs": [
      {
        "name": "",
        "type": "address",
        "internalType": "address"
      },
      {
        "name": "",
        "type": "bytes",
        "internalType": "bytes"
      }
    ]
  }
]