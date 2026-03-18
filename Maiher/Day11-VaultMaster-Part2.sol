// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

//子合约。一个让用户存入 ETH 的金库，但只有所有者可以提取资金。


import "./Day11-Ownable-Part1.sol";

//VaultMaster 继承自 Ownable
contract VaultMaster is Ownable{

//事件声明：DepositSuccessful 当有人向合约发送 ETH 时触发。
 event DepositSuccessful(address indexed account, uint256 value);
 //WithdrawSuccessful 当所有者从合约提取 ETH 触发。记录接收资金地址和提取数量。
    event WithdrawSuccessful(address indexed recipient, uint256 value);

//返回合约当前持有的 ETH 数量。
function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

//允许任何人向合约发送 ETH
function deposit() public payable {
        require(msg.value > 0, "Enter a valid amount");
        //require` 语句要求发送人必须发送>0的数值.
        //如果检查通过，函数发出 `DepositSuccessful` 事件，记录：发送者的地址和发送的 ETH 数量）。
        emit DepositSuccessful(msg.sender, msg.value);
    }
//这个函数允许从合约中提取 ETH——但只有所有者有权限。
    function withdraw(address _to, uint256 _amount) public onlyOwner {
        require(_amount <= getBalance(), "Insufficient balance");
    //使用 .call 将指定数量发送到给定地址。
        (bool success, ) = payable(_to).call{value: _amount}("");
        require(success, "Transfer Failed");

        emit WithdrawSuccessful(_to, _amount);
    }

}