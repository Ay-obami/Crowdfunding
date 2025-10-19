// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//import {AccessControl} from "./Accesscontrol.sol";
import {Fundraising_Campaign} from "./Fundraising_Campaign.sol";
// import {FundraiserRegisteration} from "./Registeration.sol";
import {FunderRegisteration} from "./Registeration.sol";

contract Donation is FunderRegisteration {
    struct DonationDetails {
        address donor;
        uint256 campaignId;
        uint256 amount;
        uint256 timestamp;
    }

    Fundraising_Campaign public fundraisingCampaign;
    DonationDetails[] public donations;
    mapping(uint256 => uint256) public totalDonationsPerCampaign;
    mapping(address => uint256) public totalDonationsPerDonor;
    mapping(address => uint256) public campaignBalance;

    constructor(address _fundraiserRegistry, address _funderRegistry)
        FunderRegisteration(_fundraiserRegistry, _funderRegistry)
    {
        serviceProvider = msg.sender;
    }

    function donate(uint256 campaignId) public payable onlyFunders(msg.sender) {
        (bool isVerified, bool isPublished) = fundraisingCampaign.getCampaignStatus(campaignId);

        require(
            isVerified && isPublished && msg.value > 0,
            "Campaign must be verified and published and donation must be greater than 0"
        );

        donations.push(
            DonationDetails({donor: msg.sender, campaignId: campaignId, amount: msg.value, timestamp: block.timestamp})
        );
        totalDonationsPerCampaign[campaignId] += msg.value;
        totalDonationsPerDonor[msg.sender] += msg.value;
        campaignBalance[msg.sender] += msg.value;
    }
    // set up function to automate token details look up from chainlink
}
