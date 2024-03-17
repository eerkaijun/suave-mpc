// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "suave-std/suavelib/Suave.sol";
import {Shamir} from "./lib/Shamir.sol";

contract KeyManagement {
    using Shamir for *; // Use the library here

    // Field size
    uint256 public Q;

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
        // submit these key shares into confidential store
        Suave.confidentialStore(dataRecord.id, "key1", abi.encode(shares[0]));
        Suave.confidentialStore(dataRecord.id, "key2", abi.encode(shares[1]));
        Suave.confidentialStore(dataRecord.id, "key3", abi.encode(shares[2]));

        return abi.encodeWithSelector(this.callback.selector);
    }

    // Function to reconstruct the original secret
    function signTransaction(bytes memory txCalldata, string memory chainId) public returns (bytes memory) {
        // read from confidential store before reconstructing
        uint256[] memory retrievedKeyShares = new uint256[](2);
        retrievedKeyShares[0] = abi.decode(Suave.confidentialRetrieve(dataRecord.id, "key1"), (uint256));
        retrievedKeyShares[1] = abi.decode(Suave.confidentialRetrieve(dataRecord.id, "key2"), (uint256));

        // parse signing key
        int256 privateKey = Shamir.reconstruct(Q, retrievedKeyShares);
        bytes memory key = abi.encode(bytes32(uint256(privateKey)));
        string memory signingKey = string(key);

        // sign transaction
        bytes memory signedTx = "";
        // signedTx = Suave.signEthTransaction(txCalldata, chainId, "12345");

        // signed transaction to be passed to callback function
        return abi.encodeWithSelector(this.signTransactionCallback.selector, signedTx);
    }

    function signTransactionCallback(bytes memory signedTx) public {
        // TODO: we can send this transaction to different chains
    }

    // TODO: partialSignTransaction - sign using each share of key

    function sanityCheck(uint256[] memory keyShares) public view returns(uint256) {
        int256 resultSecret = Shamir.reconstruct(Q, keyShares);
        return uint256(resultSecret);
    }
}
