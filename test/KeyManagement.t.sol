// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.13;

// import "forge-std/Test.sol";
// import "src/KeyManagement.sol";

// contract KeyManagementTest is Test {

//     KeyManagement keyManagement;

//     function setUp() public {
//         keyManagement = new KeyManagement(2305843009213693951);
//     }

//     function testSecretReconstruction() public {
//         // key shares that are obtained where the secret is 3
//         // only 2 of these 3 shares are needed to reconstruct the secret
//         uint256[] memory keyShares = new uint256[](3);
//         keyShares[0] = 1204783606085636997; 
//         keyShares[1] = 103724202957580040;
//         keyShares[2] = 1308507809043217034;

//         keyManagement.submitShares(keyShares);
//         int256 result = keyManagement.reconstructResult();
//         int256 expectedResult = 3;
        
//         assertEq(result, expectedResult);

//         // reconstruct key to sign transaction
//         keyManagement.signTransaction("testing");
//     }
// }