// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AccessControl} from "./Accesscontrol.sol";

contract Disbursement is AccessControl {
    struct DisbursementRequest {
        uint256 requestId;
        address fundraiser;
        uint256 campaignId;
        uint256 amount;
        string purpose;
        uint256 requestTime;
        uint256 approvalTime;
        bool isVerified;
        bool isApproved;
        bool isDisbursed;
    }

    mapping(uint256 => DisbursementRequest) public disbursementRequests;
    mapping(uint256 => uint256) public campaignBaalnceById;

    event DisbursementRequested(
        uint256 requestId, address fundraiser, uint256 campaignId, uint256 amount, string purpose
    );
    event Disbursed(uint256 requestId);
    event DisbursementApproved(uint256 requestId);

    constructor(address _fundraiserRegistry, address _funderRegistry)
        AccessControl(_fundraiserRegistry, _funderRegistry)
    {
        serviceProvider = msg.sender;
    }

    function requestDisbursement(uint256 campaignId, uint256 amount, string memory purpose)
        public
        onlyFundraiser(msg.sender)
    {
        uint256 requestId = uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp)));
        disbursementRequests[requestId] = DisbursementRequest(
            requestId, msg.sender, campaignId, amount, purpose, block.timestamp, 0, false, false, false
        );
        emit DisbursementRequested(requestId, msg.sender, campaignId, amount, purpose);
    }

    function verifyDisbursement(uint256 requestId) public onlyServiceProvider {
        require(disbursementRequests[requestId].isVerified == false, "Already verified");
        disbursementRequests[requestId].isVerified = true;
    }

    function approveDisbursement(uint256 requestId) public onlyServiceProvider confirmDelay(requestId) {
        require(disbursementRequests[requestId].isVerified == true, "Not verified");
        require(disbursementRequests[requestId].isApproved == false, "Already approved");
        disbursementRequests[requestId].isApproved = true;
        emit DisbursementApproved(requestId);
    }

    function disburseFunds(uint256 requestId) public onlyServiceProvider {
        require(disbursementRequests[requestId].isApproved == true, "Not approved");
        require(disbursementRequests[requestId].isDisbursed == false, "Already disbursed");
        disbursementRequests[requestId].isDisbursed = true;
        campaignBaalnceById[disbursementRequests[requestId].campaignId] -= disbursementRequests[requestId].amount;
        emit Disbursed(requestId);
    }

    function checkTime(uint256 requestId) public view returns (bool) {
        uint256 disbursementDelay = 2 days;

        return block.timestamp >= disbursementRequests[requestId].requestTime + disbursementDelay;
    }
}
