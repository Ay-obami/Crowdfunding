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
        uint256 registrationTime;
    }

    mapping(address => FundRaiser) public fundraisersByAddress;

    event FundraiserRegitered(address fundraiser, string name);

    constructor(
        address _fundraiserRegistry,
        address _funderRegistry
    ) AccessControl(_fundraiserRegistry, _funderRegistry) {
        serviceProvider = msg.sender;
    }

    function register(
        string memory name,
        string memory email,
        string memory country
    ) public {
        address Address = msg.sender;
        require(
            fundraisersByAddress[Address].fundraiserRegistered == false,
            "Fundraiser already registered"
        );
        fundraisersByAddress[Address] = FundRaiser(
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
            fundraisersByAddress[Address].fundraiserRegistered == true,
            "Fundraiser not registered"
        );
        return (
            fundraisersByAddress[Address].fundraiserName,
            fundraisersByAddress[Address].fundraiserEmail,
            fundraisersByAddress[Address].fundraiserCountry,
            fundraisersByAddress[Address].registrationTime
        );
    }

    function IsRegisteredFundRaiser(
        address fundRaiser
    ) public view returns (bool) {
        return fundraisersByAddress[fundRaiser].fundraiserRegistered;
    }

    // function IsRegisteredFunder(address) public pure returns (bool) {
    //     return false; // or revert
    // }
}

contract FunderRegisteration is AccessControl {
    struct Funder {
        address funderAddress;
        string funderName;
        string funderEmail;
        string funderCountry;
        bool funderRegistered;
        uint256 registerationTime;
    }

    mapping(address => Funder) public funders;

    event FunderRegistered(address funder, string name);

    constructor(
        address _fundraiserRegistry,
        address _funderRegistry
    ) AccessControl(_fundraiserRegistry, _funderRegistry) {
        serviceProvider = msg.sender;
    }

    function register(
        string memory name,
        string memory email,
        string memory country
    ) public {
        address Address = msg.sender;
        require(
            funders[msg.sender].funderRegistered == false,
            "Funder already registered"
        );
        funders[msg.sender] = Funder(
            Address,
            name,
            email,
            country,
            true,
            block.timestamp
        );
        emit FunderRegistered(Address, name);
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

    // function IsRegisteredFundRaiser(address) public pure returns (bool) {
    //     return false; // or revert
    // }
}
