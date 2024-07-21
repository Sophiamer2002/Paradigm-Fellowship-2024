// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract Gaussian {

    // The numbers have fixed point precision of 1e18
    function cdf(int256 x, int256 mu, int256 sigma) public pure returns (int256) {
        assert(sigma > 0 && sigma <= 1e37);
        assert(x >= -1e41 && x <= 1e41);
        assert(mu >= -1e38 && mu <= 1e38);
        int256 z = -((x - mu) * 1e34) / (sigma * 14142135623730951); // z \in [-1e59, 1e59]
        return erf(z) / 2;
    }

    // All int256 variables have fixed point precision of 1e18
    // Comments show the calculation in floating point numbers
    function erf(int256 x) public pure returns (int256) {
        int256 z = x < 0 ? -x : x;

        if (z >= 5e18) {  // Avoid overflow, erf(x) = 1 for x > 5
            return x < 0 ? int256(2e18) : int256(0);
        }

        // t = 1 / (1 + z / 2)
        int256 t = 1e52 / (1e34 + z * 5 * 1e15);

        // u = t * Math.exp(-z * z - 1.26551223 + t * (1.00002368 +
        // t * (0.37409196 + t * (0.09678418 + t * (-0.18628806 +
        // t * (0.27886807 + t * (-1.13520398 + t * (1.48851587 +
        // t * (-0.82215223 + t * 0.17087277)))))))))
        int256 u = t * 17087277 / 1e8 - 82215223 * 1e10;
        u = t * u / 1e18 + 148851587 * 1e10;
        u = t * u / 1e18 - 113520398 * 1e10;
        u = t * u / 1e18 + 27886807 * 1e10;
        u = t * u / 1e18 - 18628806 * 1e10;
        u = t * u / 1e18 + 9678418 * 1e10;
        u = t * u / 1e18 + 37409196 * 1e10;
        u = t * u / 1e18 + 100002368 * 1e10;
        u = t * u / 1e18 - 126551223 * 1e10;
        u = u - z * z / 1e18;
        u = -u;

        // u, k = Math.floor(u), u % 1
        int256 e = 2718281828459045235;  // e = Math.exp(1)
        int256 k = u / 1e18;
        u = u - k * 1e18;

        // f = Math.pow(e, k)
        assert(k < 32);
        int256 f = 1000000000000000000;  // 1
        for(int256 i = 16; i > 0; i>>=1) {
            f = f * f / 1e18;
            if(k & i != 0) {
                f = f * e / 1e18;
            }
        }

        // v = Math.exp(u) 
        //   = 1 + u * (1 + u / 2 * (1 + u / 3 * (...))
        int256 v = u / 12 + 1e18;
        v = u * v / 11e18 + 1e18;
        v = u * v / 10e18 + 1e18;
        v = u * v / 9e18 + 1e18;
        v = u * v / 8e18 + 1e18;
        v = u * v / 7e18 + 1e18;
        v = u * v / 6e18 + 1e18;
        v = u * v / 5e18 + 1e18;
        v = u * v / 4e18 + 1e18;
        v = u * v / 3e18 + 1e18;
        v = u * v / 2e18 + 1e18;
        v = u * v / 1e18 + 1e18;
        v = v;

        // v = v * f
        v = v * f / 1e18;

        // r = 1 / v / (1 + z / 2)
        int256 r = 1e70 / v / (1e34 + z * 5 * 1e15);

        return x >= 0 ? r : 2e18 - r;
    }
}
