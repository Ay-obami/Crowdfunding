// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AccessControl} from "./Accesscontrol.sol";

contract FundraiserRegisteration is AccessControl {
    struct FundRaiser {
        address fundraiserAddress;
        string fundraiserName;
        string fundraiserEmail;
        string fundraiserCountry;
        bool fundraiserRegistered;
        uint256 registerationTime;
    }
    modifier onlyFundraiser() {
        require(
            fundraisers[msg.sender].fundraiserRegistered == true,
            "Not a registered fundraiser"
        );
        _;
    }
    mapping(address => FundRaiser) public fundraisers;

    event FundraiserRegitered(address fundraiser, string name);

    function register(
        address Address,
        string memory name,
        string memory email,
        string memory country
    ) public {
        require(
            fundraisers[Address].fundraiserRegistered == false,
            "Fundraiser already registered"
        );
        fundraisers[Address] = FundRaiser(
            Address,
            name,
            email,
            country,
            true,
            block.timestamp
        );
        emit FundraiserRegitered(Address, name);
    }

    function getFundraiserDetailsByAddress(
        address Address
    )
        public
        view
        onlyServiceProvider
        returns (string memory, string memory, string memory, uint256)
    {
        require(
            fundraisers[Address].fundraiserRegistered == true,
            "Fundraiser not registered"
        );
        return (
            fundraisers[Address].fundraiserName,
            fundraisers[Address].fundraiserEmail,
            fundraisers[Address].fundraiserCountry,
            fundraisers[Address].registerationTime
        );
    }

    function getFundraiserRegisteerationStatus(
        address Address
    ) public view returns (bool) {
        return fundraisers[Address].fundraiserRegistered;
    }

    function IsRegisteredFundRaiser(
        address fundRaiser
    ) public view returns (bool) {
        return fundraisers[fundRaiser].fundraiserRegistered;
    }

    function IsRegisteredFunder(address) public pure returns (bool) {
        return false; // or revert
    }
}

contract FunderRegisteraion is AccessControl {
    struct Funder {
        address funderAddress;
        string funderName;
        string funderEmail;
        string funderCountry;
        bool funderRegistered;
        uint256 registerationTime;
    }

    mapping(address => Funder) public funders;

    event FunderRegitered(address funder, string name);

    function register(
        address Address,
        string memory name,
        string memory email,
        string memory country
    ) public {
        require(
            funders[Address].funderRegistered == false,
            "Funder already registered"
        );
        funders[Address] = Funder(
            Address,
            name,
            email,
            country,
            true,
            block.timestamp
        );
        emit FunderRegitered(Address, name);
    }

    function getFunderDetailsByAddress(
        address Address
    )
        public
        view
        onlyServiceProvider
        returns (string memory, string memory, string memory, uint256)
    {
        require(
            funders[Address].funderRegistered == true,
            "Funder not registered"
        );
        return (
            funders[Address].funderName,
            funders[Address].funderEmail,
            funders[Address].funderCountry,
            funders[Address].registerationTime
        );
    }

    function IsRegisteredFunder(address funder) public view returns (bool) {
        return funders[funder].funderRegistered;
    }

    function IsRegisteredFundRaiser(address) public pure returns (bool) {
        return false; // or revert
    }
}
