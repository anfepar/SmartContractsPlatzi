// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract CrowdFunding {
    string public id;
    string public name;
    string public description;
    address payable public author;
    uint256 public state;
    uint256 public funds;
    uint256 public fundraisingGoal;

    event ProjectFunded(string projectId, uint256 value);

    event ProjectStateChanged(string id, uint256 state);

    constructor(
        string memory _id,
        string memory _name,
        string memory _description,
        uint256 _fundraisingGoal
    ) {
        id = _id;
        name = _name;
        description = _description;
        fundraisingGoal = _fundraisingGoal;
        author = payable(msg.sender);
    }

    modifier isAuthor() {
        require(author == msg.sender, "You need to be the project author");
        _;
    }

    modifier isNotAuthor() {
        require(
            author != msg.sender,
            "As author you can not fund your own project"
        );
        _;
    }

    function fundProject() public payable isNotAuthor {
        require(state != 1, "The project can not receive funds");
        require(msg.value > 0, "Fund value must be greater than 0");
        author.transfer(msg.value);
        funds += msg.value;
        emit ProjectFunded(id, msg.value);
    }

    function changeProjectState(uint256 newState) public isAuthor {
        require(state != newState, "New state must be different");
        state = newState;
        emit ProjectStateChanged(id, newState);
    }
}
