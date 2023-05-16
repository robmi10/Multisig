// SPDX-License-Identifier: GPL-3.0-or-later 
pragma solidity ^0.8.13;
import "forge-std/console.sol";

contract MultiSig {
    event Send(address indexed _from, address indexed _to, uint256 indexed value);
    event Created(address indexed _from, address indexed _to, uint256 indexed value, bytes data);

    address [] public multisigOwners;
    uint256 public transactionCounter;
    uint256 public required;

    mapping(uint256 => mapping(address => bool)) public approved;
    mapping(address => bool) isOwner;
    
    struct Transactions {
        address to;
        address from;
        uint256 value;
        bytes data;
        bool executed;
    }

    Transactions [] public transactionList;

    constructor(address[] memory _owners, uint256 _required) {
        require(_owners.length == _required);
        for(uint256 i; i < _owners.length; ){
            address _owner = _owners[i];
            unchecked {
                i++;
            }
            require(_owner != address(0), "Valid address");
            require(!isOwner[_owner], "Owner already exist");
            multisigOwners.push(_owner);
            required = _required;
        }
    }


    function createTransaction (address _to, uint256 _amount, bytes memory _data) external {
        transactionList.push(Transactions( _to, msg.sender, _amount, _data,false));
        emit Created(msg.sender, _to, _amount, "");
        transactionCounter++;
    }

    modifier onlySigOwners{
        uint256 ownersLength = multisigOwners.length;
        uint256 owner;
        for(uint256 i; i < ownersLength; ){      
        address _multisigOwners = multisigOwners[i];
         if(msg.sender == _multisigOwners){
            owner = 1;
         }
        unchecked{
         i++;
        }
        _;
        owner = 0;
        }
    }

    function approve (uint256 _id) external onlySigOwners{
        approved[_id][msg.sender] = true;
    }

    function sendTx (uint256 _id) external payable {
        uint256 _votes;
        address to = transactionList[_id].to;
        uint256 value = transactionList[_id].value;
        address from = transactionList[_id].from;
        bytes memory data = transactionList[_id].data;
        bool executed = transactionList[_id].executed;

        require(from == msg.sender, "Wrong Sender");
        require(msg.value == value, "To little value");
        require(!executed, "Transaction already executed");

        for(uint256 i; i < multisigOwners.length; ){
            bool votes = approved[_id][multisigOwners[i]];
            if(votes){
               _votes = _votes + 1;
            }
            unchecked {
                i++;
            }
        }
        if(_votes == required){
            (bool status, ) =  to.call{value: msg.value}(data);
            require(status, "transaction failed");
            emit Send(msg.sender, to, value);
            executed = true;
            required = 0;
        }else{
            revert("all owners havent accept the transaction");
        }
    } 
}