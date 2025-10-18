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

    constructor(address _fundraiserRegistry, address _funderRegistry)
        AccessControl(_fundraiserRegistry, _funderRegistry)
    {
        serviceProvider = msg.sender;
    }

    function register(string memory name, string memory email, string memory country) public {
        address user = msg.sender;
        require(fundraisersByAddress[user].fundraiserRegistered == false, "Fundraiser already registered");
        fundraisersByAddress[user] = FundRaiser(user, name, email, country, true, block.timestamp);
        emit FundraiserRegitered(user, name);
    }

    function getFundraiserDetailsByAddress(address user)
        public
        view
        onlyServiceProvider
        returns (string memory, string memory, string memory, uint256)
    {
        require(fundraisersByAddress[user].fundraiserRegistered == true, "Fundraiser not registered");
        return (
            fundraisersByAddress[user].fundraiserName,
            fundraisersByAddress[user].fundraiserEmail,
            fundraisersByAddress[user].fundraiserCountry,
            fundraisersByAddress[user].registrationTime
        );
    }

    function isRegisteredFundRaiser(address fundraiser) public view returns (bool) {
        return fundraisersByAddress[fundraiser].fundraiserRegistered;
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

    constructor(address _fundraiserRegistry, address _funderRegistry)
        AccessControl(_fundraiserRegistry, _funderRegistry)
    {
        serviceProvider = msg.sender;
    }

    function register(string memory name, string memory email, string memory country) public {
        address user = msg.sender;
        require(funders[user].funderRegistered == false, "Funder already registered");
        funders[user] = Funder(user, name, email, country, true, block.timestamp);
        emit FunderRegistered(user, name);
    }

    function getFunderDetailsByAddress(address user)
        public
        view
        onlyServiceProvider
        returns (string memory, string memory, string memory, uint256)
    {
        require(funders[user].funderRegistered == true, "Funder not registered");
        return (
            funders[user].funderName,
            funders[user].funderEmail,
            funders[user].funderCountry,
            funders[user].registerationTime
        );
    }

    function isRegisteredFunder(address funder) public view returns (bool) {
        return funders[funder].funderRegistered;
    }

    // function IsRegisteredFundRaiser(address) public pure returns (bool) {
    //     return false; // or revert
    // }
}
