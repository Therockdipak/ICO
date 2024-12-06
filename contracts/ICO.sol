// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Token1.sol";
import "./Token2.sol";

contract ICO {
    Token1 public token;
    Token2 public usdt;
    address public owner;
    uint256 public rate; // Tokens per USDT
    uint256 public icoStart;
    uint256 public icoEnd;
    uint256 public tokenSold;

    uint256 public preSaleAmount;
    uint256 public preSaleAmount2;
    address public treasury;

    event TokenBought(address indexed buyer, uint256 amount);
    event unsoldTokensBurned(uint256 amount);

    mapping(address=>uint256) public balances;

    modifier onlyDuringICO {
        require(block.timestamp >= icoStart && block.timestamp <= icoEnd, "ICO is not running");
        _;
    }

    constructor(
        address _token,
        address _usdt,
        uint256 _rate,
        uint256 _icoStart,
        uint256 _icoEnd
    ) {
        require(_icoStart < _icoEnd, "ICO start time must be less than end time");
        require(_rate > 0, "Rate must not be zero");
      //   require(_treasury != address(0), "Invalid treasury address");
        
        token = Token1(_token); // Initialize the Token instance
        usdt = Token2(_usdt);
        rate = _rate;
        icoStart = _icoStart;
        icoEnd = _icoEnd;
      //   treasury = _treasury;
        owner = msg.sender;

        preSaleAmount = (token.totalSupply() * 20) / 100; // Calculate presale amount
        preSaleAmount2 = (token.totalSupply() * 22) / 100;
    }

    function PreSale1(uint256 _USDTamount) external onlyDuringICO  {
        require(_USDTamount > 0, "Amount should not be zero");
        uint256 tokenAmount = _USDTamount * rate;
        require(token.balanceOf(address(this)) >= tokenAmount, "Insufficient token amount");

        // Transfer USDT to the treasury
        usdt.transferFrom(msg.sender, address(this), _USDTamount);
        // require(success, "USDT transfer failed");

        // Transfer tokens to the buyer
        token.transfer(msg.sender, tokenAmount);

        emit TokenBought(msg.sender, tokenAmount);
    }

    function preSale2(uint _USDTamount) external onlyDuringICO {
        require(_USDTamount > 0,"Amount should not be zero");
        uint256 tokenAmount = _USDTamount * rate;
        require(token.balanceOf(address(this)) >= _USDTamount,"insufficient token amount");

        // transfer USDT to the contract 
        usdt.transferFrom(msg.sender, address(this), _USDTamount);

        // Transfer Tokens to the buyer
        token.transfer(msg.sender, tokenAmount);
        
        emit TokenBought(msg.sender, tokenAmount);
    }

    function BurnUnsoldTokens() external {
        require(block.timestamp > icoEnd,"ICO is still running");
        uint256 unsoldTokens = token.balanceOf(address(this));
        require(unsoldTokens > 0, "should be greater than zero");

        token.burn(unsoldTokens);
        emit unsoldTokensBurned(unsoldTokens);
    }
}
