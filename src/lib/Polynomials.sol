// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Polynomials {
    // Using Horner's rule (https://en.wikipedia.org/wiki/Horner%27s_method)
    function evaluateAtPoint(
        uint256 Q,
        uint256[] memory coefs,
        uint256 point
    ) internal pure returns (uint256) {
        uint256 result = 0;
        for (uint256 i = coefs.length; i > 0; i--) {
            result = (coefs[i - 1] + point * result) % Q;
        }
        return result;
    }

    function extendedGCD_recursive(
        int256 a,
        int256 b
    ) internal pure returns (int256, int256, int256) {
        if (a == 0) return (b, 0, 1);
        else {
            (int256 g, int256 y, int256 x) = extendedGCD_recursive(b % a, a);
            return (g, x - int256(b / a) * y, y);
        }
    }


    // Extended GCD using binary method
    function extendedGCD_binary(int256 a, int256 b) internal pure returns (int256, int256, int256) {
        int256 u = 1;
        int256 v = 0;
        int256 s = 0;
        int256 t = 1;
        uint256 r = 0;
        while (a % 2 == 0 && b % 2 == 0) {
            a /= 2;
            b /= 2;
            r++;
        }
        int256 alpha = int256(a);
        int256 beta = int256(b);
        while (a % 2 == 0) {
            a /= 2;
            if (u % 2 == 0 && v % 2 == 0) {
                u /= 2;
                v /= 2;
            } else {
                u = (u + beta) / 2;
                v = (v - alpha) / 2;
            }
        }
        while (a != b) {
            if (b % 2 == 0) {
                b /= 2;
                if (s % 2 == 0 && t % 2 == 0) {
                    s /= 2;
                    t /= 2;
                } else {
                    s = (s + beta) / 2;
                    t = (t - alpha) / 2;
                }
            } else if (b < a) {
                int256 temp = a;
                a = b;
                b = temp;
                temp = u;
                u = s;
                s = temp;
                temp = v;
                v = t;
                t = temp;
                // (a, b, u, v, s, t) = (b, a, s, t, u, v);
            } else {
                (b, s, t) = (b - a, s - u, t - v);
            }
        }
        return (int256(2**r) * a, s, t);
    }

    function inverse(int256 Q, int256 a) internal pure returns (int256) {
        // (, int256 b, ) = extendedGCD_recursive(a, Q);
        (, int256 b, ) = extendedGCD_binary(a, Q);
        return int256(b);
    }

    // Lagrange constants for a point
    function lagrangeConstantsForPoint(
        int256 Q,
        int256[] memory points,
        int256 point
    ) internal pure returns (int256[] memory) {
        int256[] memory constants = new int256[](points.length);
        for (uint256 i = 0; i < points.length; i++) {
            int256 xi = int256(points[i]);
            int256 num = 1;
            int256 denum = 1;
            for (uint256 j = 0; j < points.length; j++) {
                if (j != i) {
                    int256 xj = int256(points[j]);
                    // normalise results due to how solidity handles modulo's sign 
                    // https://docs.soliditylang.org/en/latest/types.html#modulo
                    num = (((num * (xj - point)) % Q) + Q) % Q;
                    denum = (((denum * (xj - xi)) % Q) + Q) % Q;
                }
            }
            constants[i] = (((num * inverse(Q, denum)) % Q) + Q) % Q;
        }
        return constants;
    }

    function interpolateAtPoint(
        int256 Q,
        uint256[][] memory pointsValues,
        int256 point
    ) internal pure returns (int256) {
        int256[] memory points = new int256[](pointsValues.length);
        int256[] memory values = new int256[](pointsValues.length);
        for (uint256 i = 0; i < pointsValues.length; i++) {
            points[i] = int256(pointsValues[i][0]);
            values[i] = int256(pointsValues[i][1]);
        }
        int256[] memory constants = lagrangeConstantsForPoint(Q, points, point);
        int256 result = 0;
        for (uint256 i = 0; i < points.length; i++) {
            result += values[i] * constants[i];
            result %= Q;
        }
        return result;
    }
}
