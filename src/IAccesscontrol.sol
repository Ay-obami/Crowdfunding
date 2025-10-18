//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IFundraiserRegisterationStatus {
    function isRegisteredFundRaiser(address user) external view returns (bool);
}

interface IFunderRegisterationStatus {
    function isRegisteredFunder(address user) external view returns (bool);
}

interface IgetFundraiserAddress {
    function getFundraiserAddress(address fundraiser) external view returns (address);
}

interface IcheckTime {
    function checkTime() external view returns (bool);
}
