// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
// router address for fuji = 0x13093E05Eb890dfA6DacecBdE51d24DabAb2Faa1
// fuji usdc address = 0x4A0D1092E9df255cf95D72834Ea9255132782318
// chain id base =10160
// deployment address for fuji = 0x39aBAA9CFE3f4D6B0d094De77cE3A6D12E00627D

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@layerzerolabs/solidity-examples/contracts/interfaces/IStargateRouter.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

contract CrossChain {
    IERC20 public token;
    address public owner;
    IUniswapV2Router02 public uniswap;
    IStargateRouter public starGate;

    mapping(address => uint) public balances;

    modifier onlyOWner() {
        require(msg.sender == owner);
        _;
    }

    constructor(address _token, address _router) {
        owner = msg.sender;
        token = IERC20(_token);
        starGate = IStargateRouter(_router);
    }

    function addTokens(uint256 _amount) public payable {
        uint256 fLiqui = _amount / 2;
        uint256 bLiqui = fLiqui;
        uint256 minAmount = fLiqui - (1 * 10 ** 6);
        token.transferFrom(msg.sender, address(this), _amount); // From user to contract
        balances[msg.sender] = _amount;
        token.approve(address(starGate), 1000000000000000); //For contract to router
        starGate.swap{value: msg.value}(
            10106,
            1,
            1,
            payable(msg.sender),
            bLiqui,
            minAmount,
            IStargateRouter.lzTxObj(0, 0, "0x"),
            abi.encodePacked(msg.sender),
            bytes("")
        );
    }

    function withdrawTokens(uint256 _amount) public {}
}
