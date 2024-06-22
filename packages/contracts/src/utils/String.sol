// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

library StringUtils {
  function stringToBytes14(string memory self) public pure returns (bytes14) {
    bytes memory tempBytes = bytes(self);

    require(tempBytes.length <= 14, "String too long");

    bytes14 converted;
    for (uint i = 0; i < tempBytes.length; i++) {
      converted |= bytes14(tempBytes[i] & 0xFF) >> (i * 8);
    }

    return converted;
  }

  function stringToBytes32(string memory self) public pure returns (bytes32) {
    bytes memory tempBytes = bytes(self);

    require(tempBytes.length <= 32, "String too long");

    bytes32 converted;
    for (uint i = 0; i < tempBytes.length; i++) {
      converted |= bytes32(tempBytes[i] & 0xFF) >> (i * 8);
    }

    return converted;
  }
}
