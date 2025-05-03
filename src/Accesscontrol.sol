// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IFunderRegistry, IFundraiserRegistry} from "./IAccesscontrol.sol";

contract AccessControl {
    address public funderRegistry;
    address public fundraiserRegistry;

    address public serviceProvider;
    modifier onlyServiceProvider() {
        require(msg.sender == serviceProvider, "Not Authorised");
        _;
    }
    modifier onlyFunders(address funder) {
        require(
            IFunderRegistry(funderRegistry).isRegistered(funder),
            "Not a registered funder"
        );
        _;
    }
    modifier onlyFundRaisers(address fundRaiser) {
        require(
            IFundraiserRegistry(fundraiserRegistry).isRegistered(fundRaiser),
            "Not a registered fundraiser"
        );
        _;
    }

    function setServiceProvider(
        address _serviceProvider
    ) public onlyServiceProvider {
        serviceProvider = _serviceProvider;
    }

    function getServiceProvider() public view returns (address) {
        return serviceProvider;
    }
}
