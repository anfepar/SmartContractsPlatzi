// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Sum {
    int256 number = 100;

    function sum(int256 a, int256 b) public pure returns (int256 result) {
        result = a + b;
    }
}
