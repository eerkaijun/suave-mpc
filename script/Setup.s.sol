// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Store} from "src/Store.sol";

contract SetupScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        vm.broadcast(deployerKey);

        Store store = new Store();
        console.log("Store deployed at: %s", address(store));
    }
}
