// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "suave-std/suavelib/Suave.sol";
import {Shamir} from "./lib/Shamir.sol";

contract KeyManagement {
    using Shamir for *; // Use the library here

    // Field size
    uint256 public Q;

    uint256[] private keyShares;

    constructor(uint256 fieldSize) {
        Q = fieldSize;
    }

    // Function to submit key shares
    function submitShares(uint256[] memory shares) public {
        // keyShares = shares;

        // submit these key shares into confidential store
        address[] memory allowedList = new address[](1);
        allowedList[0] = address(this);
        Suave.DataRecord memory dataRecord = Suave.newDataRecord(10, allowedList, allowedList, "namespace");
        Suave.confidentialStore(dataRecord.id, "key1", abi.encode(1));
        Suave.confidentialStore(dataRecord.id, "key2", abi.encode(2));
        Suave.confidentialStore(dataRecord.id, "key3", abi.encode(3));
    }

    // Function to reconstruct the original secret
    function reconstructResult() public returns (int256) {
        // read from confidential store before reconstructing
        address[] memory allowedList = new address[](1);
        allowedList[0] = address(this);
        Suave.DataRecord memory dataRecord = Suave.newDataRecord(10, allowedList, allowedList, "namespace");
        uint256[] memory retrievedKeyShares = new uint256[](2);
        retrievedKeyShares[0] = abi.decode(Suave.confidentialRetrieve(dataRecord.id, "key1"), (uint256));
        retrievedKeyShares[1] = abi.decode(Suave.confidentialRetrieve(dataRecord.id, "key2"), (uint256));

        int256 resultSecret = Shamir.reconstruct(Q, retrievedKeyShares);
        // require(resultSecret == 3, "reconstruction incorrect");
        return resultSecret;
    }

    function partialSignTransaction(bytes memory txCalldata, uint256 keyIndex) public {
        // convert uint256 to bytes (hex representation) then to string
        bytes memory keyShare = abi.encode(bytes32(keyShares[keyIndex]));
        string memory signingKey = string(keyShare);
        Suave.signEthTransaction(txCalldata, "0x1", signingKey);
    }

    function signTransaction(bytes memory txCalldata) public returns (bytes memory) {
        bytes memory key = abi.encode(bytes32(uint256(reconstructResult())));
        string memory signingKey = string(key);
        return Suave.signEthTransaction(txCalldata, "0x1", signingKey);
    }
}
