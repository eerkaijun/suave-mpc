// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "suave-std/Test.sol";
import "src/KeyManagement.sol";

contract KeyManagementTest is Test, SuaveEnabled {

    KeyManagement keyManagement;

    function testSecretReconstruction() public {
        // deploy contract
        keyManagement = new KeyManagement(2305843009213693951);

        // key shares that are obtained where the secret is 3
        // only 2 of these 3 shares are needed to reconstruct the secret
        uint256[] memory keyShares = new uint256[](3);
        keyShares[0] = 1204783606085636997; 
        keyShares[1] = 103724202957580040;
        keyShares[2] = 1308507809043217034;

        uint256 expectedResult = 3;
        uint256 result = keyManagement.sanityCheck(keyShares);
        
        assertEq(result, expectedResult);

        // keyManagement.initialize();
        // keyManagement.submitShares(keyShares);
        // keyManagement.reconstructResult();
    }
}