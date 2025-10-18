// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {
    IFunderRegisterationStatus,
    IFundraiserRegisterationStatus,
    IgetFundraiserAddress,
    IcheckTime
} from "./IAccesscontrol.sol";

abstract contract AccessControl {
    address public funderRegistry;
    address public fundraiserRegistry;
    uint256 public disbursementDelay = 2 days;
    address public serviceProvider;
    address public checktimeRegistry;
    IFunderRegisterationStatus public funderRegisterationStatusContract;
    IFundraiserRegisterationStatus public fundraiserRegisterationStatusContract;

    constructor(address _fundraiserRegistry, address _funderRegistry) {
        fundraiserRegisterationStatusContract = IFundraiserRegisterationStatus(_fundraiserRegistry);
        funderRegisterationStatusContract = IFunderRegisterationStatus(_funderRegistry);
        serviceProvider = msg.sender;
    }

    modifier onlyServiceProvider() {
        require(msg.sender == serviceProvider, "Not Authorised");
        _;
    }

    modifier onlyFunders(address funder) {
        require(funderRegisterationStatusContract.IsRegisteredFunder(funder), "Not a registered funder");
        _;
    }

    modifier onlyFundRaisers(address fundRaiser) {
        require(fundraiserRegisterationStatusContract.IsRegisteredFundRaiser(fundRaiser), "Not a registered fundraiser");
        _;
    }

    modifier onlyFundraiser(address fundraiser) {
        require(
            fundraiser == IgetFundraiserAddress(fundraiserRegistry).getFundraiserAddress(msg.sender),
            "Not your proposal"
        );
        _;
    }

    modifier confirmDelay(uint256 requestId) {
        require(IcheckTime(checktimeRegistry).checkTime(), "Delay not over");
        _;
    }

    function setServiceProvider(address _serviceProvider) public onlyServiceProvider {
        serviceProvider = _serviceProvider;
    }

    function getServiceProvider() public view returns (address) {
        return serviceProvider;
    }

    // function setFunderRegistry(address _addr) public onlyServiceProvider {
    //   funderRegistry = _addr;
    //   }

    // function setFundraiserRegistry(address _addr) public onlyServiceProvider {
    //       fundraiserRegistry = _addr;
    //   }
}
