// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "../lib/forge-std/src/Test.sol";
import {BankProject1} from  "../src/BankProject1.sol";


contract BankProject1Test is Test {

    BankProject1 bank;

    address user1 = address(1);
    address user2 = address(2);

    function setUp() public {
        bank = new BankProject1();

        vm.deal(user1, 10 ether);
        vm.deal(user2, 10 ether);
    }

    function testCreateAccount() public {
        vm.prank(user1);
        bank.createAccount("Moses");

        (string memory name,, , bool status) = bank.getAccount(user1);

        assertEq(name, "Moses");
        assertEq(status, true);
    }

    function testDeposit() public {
        vm.prank(user1);
        bank.createAccount("Moses");

        vm.prank(user1);
        bank.userDeposit{value: 1 ether}();

        (, uint256 balance,,) = bank.getAccount(user1);

        assertEq(balance, 1 ether);
    }

    function testWithdraw() public {
        vm.prank(user1);
        bank.createAccount("Moses");

        vm.prank(user1);
        bank.userDeposit{value: 2 ether}();

        vm.prank(user1);
        bank.userWithdraw(1 ether);

        (, uint256 balance,,) = bank.getAccount(user1);

        assertEq(balance, 1 ether);
    }

    function testTransfer() public {
        vm.prank(user1);
        bank.createAccount("User1");

        vm.prank(user2);
        bank.createAccount("User2");

        vm.prank(user1);
        bank.userDeposit{value: 2 ether}();

        vm.prank(user1);
        bank.transferTo(user2, 1 ether);

        (, uint256 bal1,,) = bank.getAccount(user1);
        (, uint256 bal2,,) = bank.getAccount(user2);

        assertEq(bal1, 1 ether);
        assertEq(bal2, 1 ether);
    }

    function testCloseAccount() public {
        vm.prank(user1);
        bank.createAccount("Moses");

        vm.prank(user1);
        bank.userDeposit{value: 1 ether}();

        vm.prank(user1);
        bank.closeAccount();

        (, , , bool status) = bank.getAccount(user1);

        assertEq(status, false);
    }
}