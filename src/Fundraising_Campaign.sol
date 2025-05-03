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
    mapping(uint256 => CampaignProposal) public campaignProposal;
    modifier onlyFundraiser(uint256 campaignId) {
        require(
            msg.sender == campaignProposal[campaignId].fundraiser,
            "Not your proposal"
        );
        _;
    }
    event CampaignSubmitted(uint256 id, address fundraiser);
    event CampaignVerified(uint256 id);
    event CampaignPublished(uint256 id);

    function submitCampaign(
        string memory title,
        string memory description,
        uint256 goalAmount,
        uint256 deadline,
        string memory category
    ) public {
        require(
            fundraiserRegisteration.getFundraiserRegisteerationStatus(
                msg.sender
            ) == true,
            "Not a registered fundraiser"
        );
        uint256 campaignId = uint256(
            keccak256(abi.encodePacked(msg.sender, block.timestamp))
        );
        campaignProposal[campaignId] = CampaignProposal(
            campaignId,
            msg.sender,
            title,
            description,
            goalAmount,
            deadline,
            category,
            false,
            false,
            block.timestamp
        );
        emit CampaignSubmitted(campaignId, msg.sender);
    }

    function verifyCampaign(uint256 campaignId) public onlyServiceProvider {
        require(
            campaignProposal[campaignId].isVerified == false,
            "Already verified"
        );
        campaignProposal[campaignId].isVerified = true;
        emit CampaignVerified(campaignId);
    }

    function publishCampaign(uint256 campaignId) public onlyServiceProvider {
        require(
            campaignProposal[campaignId].isVerified == true,
            "Not verified yet"
        );
        require(
            campaignProposal[campaignId].isPublished == false,
            "Already published"
        );
        campaignProposal[campaignId].isPublished = true;
        emit CampaignPublished(campaignId);
    }

    function getCampaignDetails(
        uint256 campaignId
    ) public view returns (CampaignProposal memory) {
        return
            CampaignProposal(
                campaignProposal[campaignId].id,
                campaignProposal[campaignId].fundraiser,
                campaignProposal[campaignId].title,
                campaignProposal[campaignId].description,
                campaignProposal[campaignId].goalAmount,
                campaignProposal[campaignId].deadline,
                campaignProposal[campaignId].category,
                campaignProposal[campaignId].isVerified,
                campaignProposal[campaignId].isPublished,
                campaignProposal[campaignId].submissionTime
            );
    }

    function getCampaignStatus(
        uint256 campaignId
    ) public view returns (bool, bool) {
        return (
            campaignProposal[campaignId].isVerified,
            campaignProposal[campaignId].isPublished
        );
    }

    // function getCampaignId(
    //   address fundraiser,
    // uint256 timestamp
    // ) public pure returns (uint256) {
    // return uint256(keccak256(abi.encodePacked(fundraiser, timestamp)));
    // }
    // function getCampaignId() public view returns(uint256){}
}
