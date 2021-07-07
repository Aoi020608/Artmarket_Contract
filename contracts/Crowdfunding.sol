//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

contract Crowdfunding {
    uint256 id = 0;

    struct CrowdFundingDetail {
        uint256 id;
        address payable publisher;
        uint256 goalAmount;
        uint256 endTime;
        uint256 currentAmount;
        uint256 numberOfSupporter;
    }

    //id => crowdfundingdetail
    mapping(uint256 => CrowdFundingDetail) crowdfundingDetail;

    event CrowdfundingStarted(address publisher, uint256 goalAmount);
    event CrowdfundingEnded(address publisher);
    event CrowdfundingSucceed(
        address publisher,
        uint256 achivedAmount,
        bool isSucceed
    );
    event CrowdfundingFailed(
        address publisher,
        uint256 currentAmount,
        bool isSucceed
    );

    function startCrowdfunding(uint256 _goalAmount, uint256 _endTime) public {
        require(_goalAmount > 0, "Amount should be more than o");
        require(_endTime > block.timestamp, "Crowdfunding already ended");

        CrowdFundingDetail memory newCrowdFunding = CrowdFundingDetail({
            id: id,
            publisher: payable(msg.sender),
            goalAmount: _goalAmount,
            endTime: _endTime,
            currentAmount: 0,
            numberOfSupporter: 0
        });

        crowdfundingDetail[id] = newCrowdFunding;

        emit CrowdfundingStarted(msg.sender, _goalAmount);

        id++;
    }

    function getCrowdFunding(uint256 _id)
        public
        view
        returns (CrowdFundingDetail memory)
    {
        return crowdfundingDetail[_id];
    }

    function support(uint256 _id) public payable {
        require(msg.value > 0, "Amount should be more than 0");

        CrowdFundingDetail memory existCrowdFunding = crowdfundingDetail[_id];
        require(
            existCrowdFunding.endTime > block.timestamp,
            "Crowdfunding already finished"
        );

        existCrowdFunding.currentAmount += msg.value;
        existCrowdFunding.numberOfSupporter++;

        crowdfundingDetail[_id] = existCrowdFunding;
    }

    function endCrowdfunding(uint256 _id) public {
        CrowdFundingDetail memory existCrowdFunding = crowdfundingDetail[_id];
        require(existCrowdFunding.publisher == msg.sender, "You can not end");
        require(
            existCrowdFunding.endTime <= block.timestamp,
            "Crowdfunding processed"
        );
        emit CrowdfundingEnded(existCrowdFunding.publisher);

        if (existCrowdFunding.goalAmount < existCrowdFunding.currentAmount) {
            existCrowdFunding.publisher.transfer(
                existCrowdFunding.currentAmount
            );
            emit CrowdfundingSucceed(
                existCrowdFunding.publisher,
                existCrowdFunding.currentAmount,
                true
            );
        } else {
            emit CrowdfundingFailed(
                existCrowdFunding.publisher,
                existCrowdFunding.currentAmount,
                false
            );
        }

        delete existCrowdFunding;
    }
}
