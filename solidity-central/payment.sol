// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

import './ownable.sol';

contract Payment is Ownable{

    uint256 public totalFee;

    event PaymentReceived(address indexed sender, uint256 amount);

    PaymentInfo[] public payments;

    struct PaymentInfo{
        address senderId;
        string email;
        uint256 amount;
    }

    constructor(uint256 _totalFee) Ownable(msg.sender){
        totalFee = _totalFee;
    }

    function makePayment(string memory _email) public payable{
        require(msg.value == totalFee, "Payment::makePayment: Payment amount is not equal to total fee");
        PaymentInfo memory payment = PaymentInfo(msg.sender, _email, msg.value);
        payments.push(payment);
        emit PaymentReceived(msg.sender, msg.value);
    }

    function getPaymentsByUser(address userAddress) public view returns (PaymentInfo[] memory) {
        uint256 count = 0;

        for (uint i = 0; i < payments.length; i++) {
            if (payments[i].senderId == userAddress) {
                count++;
            }
        }

        PaymentInfo[] memory userPayments = new PaymentInfo[](count);

        uint256 index = 0;
        for (uint i = 0; i < payments.length; i++) {
            if (payments[i].senderId == userAddress) {
                userPayments[index] = payments[i];
                index++;
            }
        }

        return userPayments;
    }

    function getAllPayments() public view returns(PaymentInfo[] memory){
        return payments;
    }
}