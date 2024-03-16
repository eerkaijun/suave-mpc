// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Store.sol";

contract StoreTest is Test {

    Store confidentialStore;

    function setUp() public {
        confidentialStore = new Store();
    }

    function testConfidentialStore() public {
        bytes memory result = confidentialStore.example();
        console.logBytes(result);
    }

}