// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FundraiserRegisteration {
    struct FundRaiser {
        address fundraiserAddress;
        string fundraiserName;
        string fundraiserEmail;
        string fundraiserCountry;
        bool fundraiserRegistered;
        uint256 registerationTime;
    }
    mapping(address => FundRaiser) public fundraiser;
    address public serviceProvider;
    modifier onlyServiceProvider() {
        require(msg.sender == serviceProvider, "Not Authorised");
        _;
    }
    event FundraiserRegitered(address fundraiser, string name);

    function register(
        address Address,
        string memory name,
        string memory email,
        string memory country
    ) public {
        require(
            fundraiser[Address].fundraiserRegistered == false,
            "Fundraiser already registered"
        );
        fundraiser[Address] = FundRaiser(
            Address,
            name,
            email,
            country,
            true,
            block.timestamp
        );
        emit FundraiserRegitered(Address, name);
    }

    function getFundraiserDetails(
        address Address
    )
        public
        view
        returns (string memory, string memory, string memory, uint256)
    {
        require(
            fundraiser[Address].fundraiserRegistered == true,
            "Fundraiser not registered"
        );
        return (
            fundraiser[Address].fundraiserName,
            fundraiser[Address].fundraiserEmail,
            fundraiser[Address].fundraiserCountry,
            fundraiser[Address].registerationTime
        );
    }

    function setServiceProvider(
        address _serviceProvider
    ) public onlyServiceProvider {
        serviceProvider = _serviceProvider;
    }

    function getServiceProvider() public view returns (address) {
        return serviceProvider;
    }

    function getFundraiserAddress() public view returns (address) {
        return msg.sender;
    }

    function getFundraiserName() public view returns (string memory) {
        return fundraiser[msg.sender].fundraiserName;
    }

    function getFundraiserEmail() public view returns (string memory) {
        return fundraiser[msg.sender].fundraiserEmail;
    }

    function getFundraiserCountry() public view returns (string memory) {
        return fundraiser[msg.sender].fundraiserCountry;
    }

    function getFundraiserRegistered() public view returns (bool) {
        return fundraiser[msg.sender].fundraiserRegistered;
    }

    function getFundraiserRegisterationTime() public view returns (uint256) {
        return fundraiser[msg.sender].registerationTime;
    }

    function getFundraiserDetailsByAddress(
        address Address
    )
        public
        view
        returns (string memory, string memory, string memory, uint256)
    {
        require(
            fundraiser[Address].fundraiserRegistered == true,
            "Fundraiser not registered"
        );
        return (
            fundraiser[Address].fundraiserName,
            fundraiser[Address].fundraiserEmail,
            fundraiser[Address].fundraiserCountry,
            fundraiser[Address].registerationTime
        );
    }
}
