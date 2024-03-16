// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {KeyManagement} from "src/KeyManagement.sol";

contract SetupScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerKey);

        KeyManagement keyManagement = new KeyManagement(2305843009213693951);
        console.log("KeyManagement deployed at: %s", address(keyManagement));
    }
}
