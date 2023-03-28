// SPDX-License-Identifier: GPL-3.0-or-later 
pragma solidity ^0.8.13;
import "hardhat/console.sol";

contract MultiSig {

    event send(address indexed _from, address indexed _to, uint256 indexed value);
    event created (address indexed _from, address indexed _to, uint256 indexed value, bytes data);

    address [] public multisigOwners;
    uint256 public transactionCounter;
    uint256 public required;

    mapping(uint256 => mapping(address => bool)) public approved;
    mapping(uint256 => bool) isOwner;

    struct Transactions {
        address to;
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
        }
        multisigOwners = _owners;
    }


    function createTransaction (address _to, uint256 _amount, bytes memory _data) external {
        transactionList[transactionCounter] = transactionStruct(msg.sender, _to, _amount);
        emit created(msg.sender, _to, _amount, _data);
        transactionCounter++;
    }

    modifier onlySigOwners{
        for(uint256 = i; i < multisigOwners.length; ){
            unchecked {
                i++;
            }
        address memory _multisigOwners = multisigOwners;
        require(msg.sender == _multisigOwners[i]);
        _;
        }
    }

  
    function approve (uint256 _id) external onlySigOwners{
        approved[_id][msg.sender] = true;
    }

    function sendTx (uint256 _id) external {
        uint256 _votes = 0;
        (address to, uint256 value, bytes data, bool executed ) = transactionList[_id];
        require(msg.value == _value, "To little value");
          require(!executed, "Transaction already executed");
        for(uint256 i; i < multisigOwners.length; ){
            unchecked {
                i++;
            }
            bool votes = approved[_id][multisigOwners[i]];
            while(votes){
                _votes++;
            }
            
        }
        if(_votes == required){
           (bool status, bytes memory call) =  to.call{value: value}("");
           require(status, "transaction failed");
            emit send(msg.sender, to, value, data, executed);
           executed = true;
           required = 0;
        }else{
            revert("all owners haven't accept the transaction");
        }
   
    } 

}