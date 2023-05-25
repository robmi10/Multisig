// SPDX-License-Identifier: GPL-3.0-or-later 
pragma solidity ^0.8.4;

contract Multisig {
    event Send(address indexed _from, address indexed _to, uint256 indexed counter, uint256  value);
    event Created(address indexed _from, address indexed _to, uint256 indexed counter , bytes data, uint256  value);
    event Approve(address indexed _from, address indexed _to, uint256 indexed counter , address _approver, uint256 _amount);


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


    function createTransaction (address _to, uint256 _amount, bytes memory _data) external payable {
        require(msg.value == _amount, "To little amount");
        transactionList.push(Transactions( _to, msg.sender, _amount, _data,false));
        transactionCounter++;
        emit Created(msg.sender, _to, transactionCounter, "", _amount);
    }

           modifier onlySigOwners {
                uint256 owner = 0;
                for (uint256 i = 0; i < multisigOwners.length; i++) {      
                    if (msg.sender == multisigOwners[i]) {
                        owner = 1;
                        break;
                    }
                }
                require(owner == 1, "Not a multisig owner");
                _;
            }

    function approve (uint256 _id) external onlySigOwners{
        bool isApproved = approved[_id][msg.sender];
        require(!isApproved, "approved already by the signer");
        approved[_id][msg.sender] = true;
        address to = transactionList[_id].to;
        address from = transactionList[_id].from;
        uint256 amount = transactionList[_id].value;
        emit Approve (from, to, _id, msg.sender, amount);


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
            executed = true;
            required = 0;
            emit Send(msg.sender, to, _id, value);
        }else{
            revert("all owners havent accept the transaction");
        }
    } 
}