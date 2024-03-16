pragma solidity ^0.8.0;

library IntegerField {

    // Lift integer in field
    function encode(uint256 Q, uint256 x) internal pure returns (uint256) {
        return x % Q;
    }

    function decode(uint256 Q, uint256 x) internal pure returns (uint256) {
        return x <= Q/2 ? x : x - Q;
    }
}
