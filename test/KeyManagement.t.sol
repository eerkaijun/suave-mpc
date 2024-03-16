// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/KeyManagement.sol";

contract KeyManagementTest is Test {

    KeyManagement keyManagement;

    function setUp() public {
        keyManagement = new KeyManagement(2305843009213693951);
    }

    function testSecretReconstruction() public {
        // key shares that are obtained where the secret is 3
        // only 5 of these 10 shares are needed to reconstruct the secret
        uint256[] memory keyShares = new uint256[](10);
        keyShares[0] = 1496900149669299837; 
        keyShares[1] = 907175982561104487;
        keyShares[2] = 1146663827923924004;
        keyShares[3] = 1540291843729751165;
        keyShares[4] = 127923025887755424;
        keyShares[5] = 581884235885364765;
        keyShares[6] = 677751154719795947;
        keyShares[7] = 1517720319752830308;
        keyShares[8] = 613080097069731912;
        keyShares[9] = 1107582718334023353;

        keyManagement.submitShares(keyShares);
        int256 result = keyManagement.reconstructResult();
        int256 expectedResult = 3;
        
        assertEq(result, expectedResult);
    }
}