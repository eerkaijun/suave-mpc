// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "suave-std/suavelib/Suave.sol";
import {Shamir} from "./lib/Shamir.sol";

contract KeyManagement {
    using Shamir for *; // Use the library here

    // Field size
    uint256 public Q;

    uint256[] private keyShares;

    Suave.DataRecord dataRecord;

    constructor(uint256 fieldSize) {
        Q = fieldSize;
    }

    function callback() external {}

    function initializeCallback(Suave.DataRecord memory record) external {
        dataRecord = record;
    }

    function initialize() public returns (bytes memory) {
        address[] memory allowedList = new address[](1);
        allowedList[0] = address(this);
        Suave.DataRecord memory record = Suave.newDataRecord(10, allowedList, allowedList, "namespace");
        return abi.encodeWithSelector(this.initializeCallback.selector, record);
    } 

    // Function to submit key shares
    function submitShares(uint256[] memory shares) public returns (bytes memory) {
        // keyShares = shares;

        // submit these key shares into confidential store
        Suave.confidentialStore(dataRecord.id, "key1", abi.encode(shares[0]));
        Suave.confidentialStore(dataRecord.id, "key2", abi.encode(shares[1]));
        Suave.confidentialStore(dataRecord.id, "key3", abi.encode(shares[2]));

        return abi.encodeWithSelector(this.callback.selector);
    }

    // Function to reconstruct the original secret
    function reconstructResult() public returns (bytes memory) {
        // read from confidential store before reconstructing
        uint256[] memory retrievedKeyShares = new uint256[](2);
        retrievedKeyShares[0] = abi.decode(Suave.confidentialRetrieve(dataRecord.id, "key1"), (uint256));
        retrievedKeyShares[1] = abi.decode(Suave.confidentialRetrieve(dataRecord.id, "key2"), (uint256));

        int256 resultSecret = Shamir.reconstruct(Q, retrievedKeyShares);
        // require(resultSecret == 3, "reconstruction incorrect");

        return abi.encodeWithSelector(this.callback.selector);
    }

    // function partialSignTransaction(bytes memory txCalldata, uint256 keyIndex) public {
    //     // convert uint256 to bytes (hex representation) then to string
    //     bytes memory keyShare = abi.encode(bytes32(keyShares[keyIndex]));
    //     string memory signingKey = string(keyShare);
    //     Suave.signEthTransaction(txCalldata, "0x1", signingKey);
    // }

    // function signTransaction(bytes memory txCalldata) public returns (bytes memory) {
    //     bytes memory key = abi.encode(bytes32(uint256(reconstructResult())));
    //     string memory signingKey = string(key);
    //     return Suave.signEthTransaction(txCalldata, "0x1", signingKey);
    // }

    function sanityCheck(uint256[] memory keyShares) public returns(uint256) {
        int256 resultSecret = Shamir.reconstruct(Q, keyShares);
        return uint256(resultSecret);
    }
}
