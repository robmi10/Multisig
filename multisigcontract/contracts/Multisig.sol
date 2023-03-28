// SPDX-License-Identifier: GPL-3.0-or-later 
pragma solidity ^0.8.13;
import "hardhat/console.sol";

contract MultiSig {

    event send(address indexed _from, address indexed _to, uint256 indexed value);
    event created (address indexed _from, address indexed _to, uint256 indexed value, bytes data);

    address [] public multisigOwners;
    uint256 public transactionCounter;
    uint256 public required;
    uint256 public owner;

    mapping(uint256 => mapping(address => bool)) public approved;
    mapping(address => bool) isOwner;

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
            multisigOwners.push(_owner);
            required = _required;
        }
    }


    function createTransaction (address _to, uint256 _amount, bytes memory _data) external {
        transactionList.push(Transactions( _to, _amount, "",false));
        emit created(msg.sender, _to, _amount, "");
        transactionCounter++;
            // console.log("transactionList length ->",transactionList.length);
    }

    modifier onlySigOwners{
        owner = 0;
        for(uint256 i; i < multisigOwners.length; i++){      
        address _multisigOwners = multisigOwners[i];
         if(msg.sender == _multisigOwners){
            owner = 1;
         }
        _;
        owner = 0;
        }
    }

  
    function approve (uint256 _id) external onlySigOwners{
        approved[_id][msg.sender] = true;
    }

    function sendTx (uint256 _id) external payable {
        uint256 _votes = 0;
        address to = transactionList[_id].to;
        uint256 value = transactionList[_id].value;
        bytes memory data = transactionList[_id].data;
        bool executed = transactionList[_id].executed;

        require(msg.value == value, "To little value");
        require(!executed, "Transaction already executed");
        for(uint256 i; i < multisigOwners.length; i++){
         
            bool votes = approved[_id][multisigOwners[i]];
            if(votes){
                _votes++;
            }
            
        }

        if(_votes == required){
           (bool status, bytes memory call) =  to.call{value: value}("");
           require(status, "transaction failed");
            emit send(msg.sender, to, value);
           executed = true;
           required = 0;
        }else{
            revert("all owners havent accept the transaction");
        }
   
    } 

}