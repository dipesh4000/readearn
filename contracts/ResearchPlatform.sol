// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ResearchPlatform {
    struct Paper {
        uint256 id;
        string title;
        uint256 readingTime; // in minutes
        uint256 pointsReward;
        bool isActive;
    }

    struct UserStats {
        uint256 totalPoints;
        mapping(uint256 => bool) papersRead;
    }

    mapping(address => UserStats) private userStats;
    mapping(uint256 => Paper) public papers;
    uint256 public paperCount;
    uint256 public totalPoints;
    uint256 public rewardPool;
    
    event PaperAdded(uint256 id, string title, uint256 readingTime, uint256 pointsReward);
    event PointsEarned(address user, uint256 paperId, uint256 points);
    event RewardsDistributed(uint256 totalDistributed);

    constructor() {
        paperCount = 0;
        totalPoints = 0;
        rewardPool = 0;
    }

    function addPaper(string memory _title, uint256 _readingTime, uint256 _pointsReward) public {
        paperCount++;
        papers[paperCount] = Paper(paperCount, _title, _readingTime, _pointsReward, true);
        emit PaperAdded(paperCount, _title, _readingTime, _pointsReward);
    }

    function readPaper(uint256 _paperId) public {
        require(_paperId > 0 && _paperId <= paperCount, "Paper does not exist");
        require(papers[_paperId].isActive, "Paper is not active");
        require(!userStats[msg.sender].papersRead[_paperId], "Paper already read");

        userStats[msg.sender].papersRead[_paperId] = true;
        userStats[msg.sender].totalPoints += papers[_paperId].pointsReward;
        totalPoints += papers[_paperId].pointsReward;
        
        emit PointsEarned(msg.sender, _paperId, papers[_paperId].pointsReward);
    }

    function getUserPoints(address _user) public view returns (uint256) {
        return userStats[_user].totalPoints;
    }

    function hasPaperBeenRead(address _user, uint256 _paperId) public view returns (bool) {
        return userStats[_user].papersRead[_paperId];
    }

    function addToRewardPool() public payable {
        rewardPool += msg.value;
    }

    function distributeRewards() public {
        require(totalPoints > 0, "No points earned yet");
        uint256 totalRewards = rewardPool;
        rewardPool = 0;
        
        // Reset for next month
        totalPoints = 0;
        
        emit RewardsDistributed(totalRewards);
    }
}
