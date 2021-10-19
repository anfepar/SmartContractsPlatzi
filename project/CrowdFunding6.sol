// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract CrowdFunding {
    enum FundraisingState {
        Opened,
        Closed
    }

    struct Project {
        string id;
        string name;
        string description;
        address payable author;
        FundraisingState state;
        uint256 funds;
        uint256 fundraisingGoal;
    }

    Project public project;

    event ProjectFunded(string projectId, uint256 value);

    event ProjectStateChanged(string id, FundraisingState state);

    constructor(
        string memory _id,
        string memory _name,
        string memory _description,
        uint256 _fundraisingGoal
    ) {
        project = Project(
            _id,
            _name,
            _description,
            payable(msg.sender),
            FundraisingState.Opened,
            0,
            _fundraisingGoal
        );
    }

    modifier isAuthor() {
        require(
            project.author == msg.sender,
            "You need to be the project author"
        );
        _;
    }

    modifier isNotAuthor() {
        require(
            project.author != msg.sender,
            "As author you can not fund your own project"
        );
        _;
    }

    function fundProject() public payable isNotAuthor {
        require(
            project.state != FundraisingState.Closed,
            "The project can not receive funds"
        );
        require(msg.value > 0, "Fund value must be greater than 0");
        project.author.transfer(msg.value);
        project.funds += msg.value;
        emit ProjectFunded(project.id, msg.value);
    }

    function changeProjectState(FundraisingState newState) public isAuthor {
        require(project.state != newState, "New state must be different");
        project.state = newState;
        emit ProjectStateChanged(project.id, newState);
    }
}
