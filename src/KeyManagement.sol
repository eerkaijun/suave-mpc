// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

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
}
