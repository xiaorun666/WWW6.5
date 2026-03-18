// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
//母合约，这个合约跟踪谁是所有者，并使用 onlyOwner 修饰符保护敏感函数。
contract Ownable{

//存储合约所有者的地址， 所有者也就是部署该合约的人。
address private owner;

//事件存储在区块链上，前端可监听/查询/收听/查看事件
//该事件记录所有权从谁转移到到谁
//indexed 关键字有助于轻松过滤日志——所以可以搜索涉及特定地址的所有事件
event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

//这在合约部署时运行一次。
//它将部署者（msg.sender）设置为初始所有者，并发出 OwnershipTransferred 事件来记录该更改。
constructor() {
    owner = msg.sender;
    emit OwnershipTransferred(address(0), msg.sender);
}

//自定义修饰符{确保只有所有者可以调用它}。
modifier onlyOwner() {
    require(msg.sender == owner, "Only owner can perform this action");
    _;
}
//提供一个公共函数，以便任何人都可以检查当前所有者是谁。
function ownerAddress() public view returns (address) {
    return owner;
}

//允许当前所有者转移所有权给其他人。检查新所有者地址是否有效（不是 0x0）。
//更新所有者并通过 OwnershipTransferred 事件记录更改
function transferOwnership(address _newOwner) public onlyOwner {
    require(_newOwner != address(0), "Invalid address");
    address previous = owner;
    owner = _newOwner;
    emit OwnershipTransferred(previous, _newOwner);
}

}