// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Disbursement} from "../src/Disbursement.sol";
import {Fundraising_Campaign} from "../src/Fundraising_Campaign.sol";
import {FunderRegisteration} from "../src/Registeration.sol";
import {FundraiserRegisteration} from "../src/Registeration.sol";
import {Donation} from "../src/Donation.sol";

contract deployment is Script {
    FunderRegisteration funderRegisteration;
    FundraiserRegisteration fundraiserRegisteration;

    function deployCrowdfunding()
        public
        returns (
            // AccessControl,
            FundraiserRegisteration,
            Disbursement,
            Fundraising_Campaign,
            FunderRegisteration,
            Donation
        )
    {
        vm.startBroadcast();
        funderRegisteration = new FunderRegisteration(address(fundraiserRegisteration), address(funderRegisteration));
        fundraiserRegisteration =
            new FundraiserRegisteration(address(fundraiserRegisteration), address(funderRegisteration));
        Disbursement disbursement = new Disbursement(address(fundraiserRegisteration), address(funderRegisteration));

        Fundraising_Campaign fundraisingCampaign =
            new Fundraising_Campaign(address(fundraiserRegisteration), address(funderRegisteration));

        Donation donation = new Donation(address(fundraiserRegisteration), address(funderRegisteration));
        vm.stopBroadcast();
        return
            (
                // accessControl,
                fundraiserRegisteration, disbursement, fundraisingCampaign, funderRegisteration, donation
            );
    }

    function run()
        external
        returns (
            //AccessControl,
            FundraiserRegisteration,
            Disbursement,
            Fundraising_Campaign,
            FunderRegisteration,
            Donation
        )
    {
        return deployCrowdfunding();
    }
}
