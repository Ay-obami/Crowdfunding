//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {AccessControl} from "../src/Accesscontrol.sol";
import {Disbursement} from "../src/Disbursement.sol";
import {Fundraising_Campaign} from "../src/Fundraising_Campaign.sol";
import {FunderRegisteration} from "../src/Registeration.sol";
import {FundraiserRegisteration} from "../src/Registeration.sol";
import {Donation} from "../src/Donation.sol";

contract CrowdfundingTest is Test {
    FunderRegisteration funderRegisteration;
    FundraiserRegisteration fundRaiserRegisteration;
    Fundraising_Campaign fundraising_Campaign;
    address Owner = address(0xBEEF);

    event CampaignSubmitted(uint256 id, address fundraiser);

    function setUp() external {
        funderRegisteration = new FunderRegisteration(address(fundRaiserRegisteration), address(funderRegisteration));
        fundRaiserRegisteration =
            new FundraiserRegisteration(address(fundRaiserRegisteration), address(funderRegisteration));
        fundraising_Campaign = new Fundraising_Campaign(address(fundRaiserRegisteration), address(funderRegisteration));
    }

    function testFunderRegisteration() external {
        funderRegisteration.register("John Doe", "w8M9d@example.com", "United States");
        assertEq(funderRegisteration.IsRegisteredFunder(address(this)), true);
    }

    function testgetFunderDetailsByAddress() external {
        funderRegisteration.register("John Doe", "w8M9d@example.com", "United States");
        (string memory name, string memory email, string memory country,) =
            funderRegisteration.getFunderDetailsByAddress(address(this));
        assertEq(name, "John Doe");
        assertEq(email, "w8M9d@example.com");
        assertEq(country, "United States");
    }

    function testRegisterRevert() external {
        funderRegisteration.register("John Doe", "w8M9d@example.com", "United States");
        vm.expectRevert("Funder already registered");
        funderRegisteration.register("John Doe", "w8M9d@example.com", "United States");
    }

    function testFundraiserRegisteration() external {
        fundRaiserRegisteration.register("John Doe", "w8M9d@example.com", "United States");
        assertEq(fundRaiserRegisteration.IsRegisteredFundRaiser(address(this)), true);
    }

    function testgetFundraiserDetailsByAddress() external {
        fundRaiserRegisteration.register("John Doe", "w8M9d@example.com", "United States");
        (string memory name, string memory email, string memory country,) =
            fundRaiserRegisteration.getFundraiserDetailsByAddress(address(this));
        assertEq(name, "John Doe");
        assertEq(email, "w8M9d@example.com");
        assertEq(country, "United States");
    }

    function testSubmitCampaignAndGetCampaigndetails() external {
        vm.startPrank(Owner);

        fundRaiserRegisteration.register("John Doe", "w8M9d@example.com", "United States");
        // vm.prank(Owner);
        vm.recordLogs();
        fundraising_Campaign.submitCampaign(
            "Test Campaign", "This is a test campaign", 100 ether, block.timestamp + 1 weeks, "Charity"
        );
        vm.stopPrank();
        bool isRegistered = fundRaiserRegisteration.IsRegisteredFundRaiser(Owner);
        console.log("Registered?", isRegistered);
        assertTrue(isRegistered);

        Vm.Log[] memory logs = vm.getRecordedLogs();
        uint256 campaignId = abi.decode(logs[0].data, (uint256));

        fundraising_Campaign.getCampaignDetails(campaignId);

        assertEq(fundraising_Campaign.getCampaignDetails(campaignId).title, "Test Campaign");
        assertEq(fundraising_Campaign.getCampaignDetails(campaignId).description, "This is a test campaign");
        assertEq(fundraising_Campaign.getCampaignDetails(campaignId).goalAmount, 100 ether);
        assertEq(fundraising_Campaign.getCampaignDetails(campaignId).deadline, block.timestamp + 1 weeks);
        assertEq(fundraising_Campaign.getCampaignDetails(campaignId).category, "Charity");
    }
}
