/*
 * This exercise has been updated to use Solidity version 0.8.5
 * See the latest Solidity updates at
 * https://solidity.readthedocs.io/en/latest/080-breaking-changes.html
 */
// SPDX-License-Identifier: MIT
pragma solidity >=0.5.16 <0.9.0;

contract SimpleBank {

    //
    // State variables
    //

    /* Fill in the keyword. Hint: We want to protect our users balance from other contracts*/
    mapping (address => uint) private balances;

    /* Fill in the keyword. We want to create a getter function and allow contracts to be able to see if a user is enrolled.  */
    mapping (address => bool) public enrolled;

    /* Let's make sure everyone knows who owns the bank. Use the appropriate keyword for this*/
    address public owner;

    //
    // Events - publicize actions to external listeners
    //


    event LogEnrolled(address accountAddress);


    event LogDepositMade(address accountAddress, uint amount);


    event LogWithdrawal(address accountAddress, uint withdrawAmount, uint newBalance);

    //
    // Modifiers
    //

    // @notice onlyEnrolled
    // Ensures the msg.sender has already been enrolled before executing a function
    modifier onlyEnrolled {
        require(
            enrolled[msg.sender] == true,
            "Only enrolled accounts can call this function."
        );
        _;
    }

    // @notice notEnrolled
    // Ensures the msg.sender has not already been enrolled before executing a function
    modifier notEnrolled {
        require(
            enrolled[msg.sender] == false,
            "Only accounts not enrolled can call this function."
        );
        _;
    }

 


    constructor() public {
        owner = msg.sender;
    }


    function balance() public view returns (uint) {
        return balances[msg.sender];
    }

  
    function enroll() public notEnrolled returns (bool){ // add modifier so a user cannot enroll more than once
        enrolled[msg.sender] = true;
        emit LogEnrolled(msg.sender);
        return enrolled[msg.sender];
    }

 
       /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    // Add the appropriate keyword so that this function can receive ether
    // Use the appropriate global variables to get the transaction sender and value
    function deposit() public payable returns (uint) {
        /* Add the amount to the user's balance, call the event associated with a deposit,
          then return the balance of the user */
        balances[msg.sender] += msg.value;
        emit LogDepositMade(msg.sender, msg.value);
        return balances[msg.sender];      
    }


    function withdraw(uint withdrawAmount) public returns (uint) {

            assert(balances[msg.sender] >= withdrawAmount);
            balances[msg.sender] -= withdrawAmount;
            emit LogWithdrawal(msg.sender, withdrawAmount, balances[msg.sender]);
            return balances[msg.sender];
    }

    function() external  {
        revert();
    }
}
