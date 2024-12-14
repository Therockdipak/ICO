// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "Intelisync/token1.sol";
import "Intelisync/token2.sol";

 contract ICO {
    Token public token;
    Token2 public usdt;
     address public owner;
     uint256 public icoStart;
     uint256 public icoEnd;
     uint256 public tokenSold;
     uint256 public price;
     bool public manualPause;

     uint256 public preSaleAmount;
     uint256 public preSaleAmount2;

     bool public isPreSale1Active =true;

    enum Status { notStartedYet, Active, Pause, Ended }
    Status public icoStatus;

    event TokenBought(address indexed buyer, uint256 amount);
    event UnsoldTokensBurned(uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can make changes");
        _;
    }

    modifier onlyDuringICO() {
        _updateStatus(); // Ensure status is updated before running the function
        require(icoStatus == Status.Active, "ICO is not active");
        _;
    }

    constructor(address _token, address _usdt) {
        token = Token(_token);
        usdt = Token2(_usdt);
        owner = msg.sender;

        preSaleAmount = (token.totalSupply() * 20) / 100;
        preSaleAmount2 = (token.totalSupply() * 22) / 100;
        icoStatus = Status.notStartedYet;
    }

    // Internal function to calculate the current status based on timestamps
    function _updateStatus() internal {
        if(manualPause) {
            icoStatus = Status.Pause;
            return;
        }
        if (icoStart == 0 || icoEnd == 0) {
            icoStatus = Status.notStartedYet;
        } else if (block.timestamp < icoStart) {
            icoStatus = Status.notStartedYet;
        } else if (block.timestamp >= icoStart && block.timestamp <= icoEnd) {
            icoStatus = Status.Active;
        } else if (block.timestamp > icoEnd) {
            icoStatus = Status.Ended;
        }
    }

    function setPrice(uint256 price_) public onlyOwner {
        require(price_ > 0, "price must not be zero");
        price = price_;
    }

    function setStartTime(uint256 startTime_) public onlyOwner {
        require(startTime_ > block.timestamp, "Start time must be in the future");
        icoStart = startTime_;
        _updateStatus(); // Update the status after setting the start time
    }

    function setEndTime(uint256 endTime_) public onlyOwner {
        require(endTime_ > icoStart, "End time must be after start time");
        icoEnd = endTime_;
        _updateStatus(); // Update the status after setting the end time
    }

    function pauseICO() external onlyOwner {
        require(icoStatus == Status.Active, "Can only pause an active ICO");
        manualPause = true;
        icoStatus = Status.Pause;
    }

    function resumeICO() external onlyOwner {
        require(icoStatus == Status.Pause, "Can only resume a paused ICO");
        manualPause = false;
        if(block.timestamp >= icoStart && block.timestamp <= icoEnd) {
           icoStatus = Status.Active;
        } else {
            _updateStatus();
        }
        
    }

    function preSale1(uint256 _USDTamount) external onlyDuringICO {
        require(isPreSale1Active,"preSale1 has ended, participate in preSale2");
        require(_USDTamount > 0, "Amount should not be zero");
        uint256 tokenAmount = _USDTamount * price;
        require(token.balanceOf(address(this)) >= tokenAmount, "Insufficient token amount");

        usdt.transferFrom(msg.sender, address(this), _USDTamount);
        token.transfer(msg.sender, tokenAmount);
        tokenSold += tokenAmount;
        emit TokenBought(msg.sender, tokenAmount);
        _updateStatus(); // Check and update status after the transaction
    }

    function preSale2(uint256 _USDTamount) external onlyDuringICO {
        require(!isPreSale1Active,"presale1 is active,you can't participate in presale2");
        require(_USDTamount > 0, "Amount should not be zero");
        uint256 tokenAmount = _USDTamount * price;
        require(token.balanceOf(address(this)) >= tokenAmount, "Insufficient token amount");

        usdt.transferFrom(msg.sender, address(this), _USDTamount);
        token.transfer(msg.sender, tokenAmount);
        tokenSold += tokenAmount;
        emit TokenBought(msg.sender, tokenAmount);
        _updateStatus(); // Check and update status after the transaction
    }

    function burnUnsoldTokens() external {
        _updateStatus(); // Ensure status is updated before burning tokens
        require(icoStatus == Status.Ended, "ICO must be ended to burn tokens");
        uint256 unsoldTokens = token.balanceOf(address(this));
        require(unsoldTokens > 0, "No unsold tokens to burn");

        token.burn(unsoldTokens);
        emit UnsoldTokensBurned(unsoldTokens);
    }

    function withdraw(address _recipient, uint256 amount_) public onlyOwner {
        require(_recipient != address(0), "Enter a valid address");
        require(amount_ <= usdt.balanceOf(address(this)), "Insufficient USDT balance");
        usdt.transfer(_recipient, amount_);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Enter a valid address");
        owner = newOwner;
    }

    function checkStatus() external view returns (string memory) {
         if(manualPause) {
            return "ico is manually paused";
         }
        if (icoStart == 0  || icoEnd == 0) {
            return "ICO has not started yet";
        } else if (block.timestamp >= icoStart && block.timestamp <= icoEnd) {
            return "ICO is currently active";
        } else if (block.timestamp > icoEnd) {
            return "ICO has ended";
        } else {
            return "Invalid status";
        }
    }
}
