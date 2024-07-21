// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Gaussian} from "../src/Gaussian.sol";

contract GaussianTest is Test {
    Gaussian public gaussian;

    function setUp() public {
        gaussian = new Gaussian();
    }

    function diff(int256 a, int256 b) internal pure returns (uint256) {
        if (a > b) {
            return uint256(a - b);
        } else {
            return uint256(b - a);
        }
    }

    function test_Precision() public view {
        int256 x;
        // errcw-gaussian(0, 0, 1) = 0.500000015000000200
        x = gaussian.cdf(int256(0), int256(0), int256(1e18));
        assert(diff(x, 500000015000000200) < 1e10);

        // errcw-gaussian(1, 0, 1) = 0.841344738604325300
        x = gaussian.cdf(int256(1e18), int256(0), int256(1e18));
        assert(diff(x, 841344738604325300) < 1e10);

        // errcw-gaussian(2, 0, 1) = 0.977249870109875500
        x = gaussian.cdf(int256(2e18), int256(0), int256(1e18));
        assert(diff(x, 977249870109875500) < 1e10);

        // errcw-gaussian(4, 0, 1) = 0.999968328755608100
        x = gaussian.cdf(int256(4e18), int256(0), int256(1e18));
        assert(diff(x, 999968328755608100) < 1e10);

        // errcw-gaussian(1e16, 3e16, 4e16) = 0.308537516918601800
        x = gaussian.cdf(int256(1e34), int256(3e34), int256(4e34));
        assert(diff(x, 308537516918601800) < 1e10);

        // errcw-gaussian(1e20, 3e16, 4e16) = 1
        x = gaussian.cdf(int256(1e38), int256(3e34), int256(4e34));
        assert(diff(x, 1e18) < 1e10);

        // errcw-gaussian(1e13, 3e16, 4e16) = 0.226702633132218030
        x = gaussian.cdf(int256(1e31), int256(3e34), int256(4e34));
        assert(diff(x, 226702633132218030) < 1e10);
    }
}
