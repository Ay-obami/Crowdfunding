//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IFundraiserRegistry {
    function isRegistered(address user) external view returns (bool);
}

interface IFunderRegistry {
    function isRegistered(address user) external view returns (bool);
}
