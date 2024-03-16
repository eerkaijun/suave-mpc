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
        keyShares = shares;
    }

    // Function to reconstruct the original secret
    function reconstructResult() public view returns (int256) {
        int256 resultSecret = Shamir.reconstruct(Q, keyShares);
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
