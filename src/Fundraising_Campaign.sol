// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {FundraiserRegisteration} from "./Registeration.sol";
import {AccessControl} from "./Accesscontrol.sol";

contract Fundraising_Campaign is AccessControl {
    FundraiserRegisteration fundraiserRegisteration;

    struct CampaignProposal {
        uint256 id;
        address fundraiser;
        string title;
        string description;
        uint256 goalAmount;
        uint256 deadline;
        string category;
        bool isVerified;
        bool isPublished;
        uint256 submissionTime;
    }

    mapping(uint256 => CampaignProposal) public campaignProposalById;
    mapping(address => CampaignProposal) public campaignProposalByAddress;

    event CampaignSubmitted(uint256 id, address fundraiser);
    event CampaignVerified(uint256 id);
    event CampaignPublished(uint256 id);

    constructor(address _fundraiserRegistry, address _funderRegistry)
        AccessControl(_fundraiserRegistry, _funderRegistry)
    {
        serviceProvider = msg.sender;
    }

    function submitCampaign(
        string memory title,
        string memory description,
        uint256 goalAmount,
        uint256 deadline,
        string memory category
    ) public onlyFundRaisers(msg.sender) {
        uint256 campaignId = uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp)));
        campaignProposalById[campaignId] = CampaignProposal({
            id: campaignId,
            fundraiser: msg.sender,
            title: title,
            description: description,
            goalAmount: goalAmount,
            deadline: deadline,
            category: category,
            isVerified: false,
            isPublished: false,
            submissionTime: block.timestamp
        });

        emit CampaignSubmitted(campaignId, msg.sender);
    }

    function verifyCampaign(uint256 campaignId) public onlyServiceProvider {
        require(campaignProposalById[campaignId].isVerified == false, "Already verified");
        campaignProposalById[campaignId].isVerified = true;
        emit CampaignVerified(campaignId);
    }

    function publishCampaign(uint256 campaignId) public onlyServiceProvider {
        require(campaignProposalById[campaignId].isVerified == true, "Not verified yet");
        require(campaignProposalById[campaignId].isPublished == false, "Already published");
        campaignProposalById[campaignId].isPublished = true;
        emit CampaignPublished(campaignId);
    }

    function getCampaignDetails(uint256 campaignId) public view returns (CampaignProposal memory) {
        return CampaignProposal({
            id: campaignProposalById[campaignId].id,
            fundraiser: campaignProposalById[campaignId].fundraiser,
            title: campaignProposalById[campaignId].title,
            description: campaignProposalById[campaignId].description,
            goalAmount: campaignProposalById[campaignId].goalAmount,
            deadline: campaignProposalById[campaignId].deadline,
            category: campaignProposalById[campaignId].category,
            isVerified: campaignProposalById[campaignId].isVerified,
            isPublished: campaignProposalById[campaignId].isPublished,
            submissionTime: campaignProposalById[campaignId].submissionTime
        });
    }

    function getCampaignStatus(uint256 campaignId) public view returns (bool, bool) {
        return (campaignProposalById[campaignId].isVerified, campaignProposalById[campaignId].isPublished);
    }

    function getFundraiserAddress(address fundraiser) public view returns (address) {
        return campaignProposalByAddress[fundraiser].fundraiser;
    }

    // function getCampaignId(
    //   address fundraiser,
    // uint256 timestamp
    // ) public pure returns (uint256) {
    // return uint256(keccak256(abi.encodePacked(fundraiser, timestamp)));
    // }
    // function getCampaignId() public view returns(uint256){}
}
