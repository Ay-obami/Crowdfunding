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
        _onlyServiceProvider();
        _;
    }

    function _onlyServiceProvider() internal view {
        require(msg.sender == serviceProvider, "Not Authorised");
    }

    modifier onlyFunders(address funder) {
        _onlyFunders(funder);
        _;
    }

    function _onlyFunders(address funder) internal view {
        require(funderRegisterationStatusContract.isRegisteredFunder(funder), "Not a registered funder");
    }

    modifier onlyFundRaisers(address fundRaiser) {
        _onlyFundRaisers(fundRaiser);
        _;
    }

    function _onlyFundRaisers(address fundraiser) internal view {
        require(fundraiserRegisterationStatusContract.isRegisteredFundRaiser(fundraiser), "Not a registered fundraiser");
    }

    modifier onlyFundraiser(address fundraiser) {
        _onlyFundraiser(fundraiser);
        _;
    }

    function _onlyFundraiser(address fundraiser) internal view {
        require(
            fundraiser == IgetFundraiserAddress(fundraiserRegistry).getFundraiserAddress(msg.sender),
            "Not your proposal"
        );
    }

    modifier confirmDelay(uint256 requestId) {
        _confirmDelay(requestId);
        _;
    }

    function _confirmDelay(uint256 requestId) internal view {
        require(IcheckTime(checktimeRegistry).checkTime(requestId), "Delay not over");
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
