// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;



import {Test} from "../lib/forge-std/src/Test.sol";
import {ForLoop} from  "../src/ForLoop.sol";

contract ForLoopTest is Test {

    ForLoop loop;

    function setUp() public {
        loop = new ForLoop();
    }

    function testCreateMultipleAccounts() public {
        string[] memory names = new string[](2);
        names[0] = "Moses";
        names[1] = "John";

        address[] memory addrs = new address[](2);
        addrs[0] = address(1);
        addrs[1] = address(2);

        loop.createMultipleAccounts(names, addrs);

        assertEq(loop.getTotalAccounts(), 2);
    }

    function testAccountData() public {
        string[] memory names = new string[](1);
        names[0] = "Moses";

        address[] memory addrs = new address[](1);
        addrs[0] = address(1);

        loop.createMultipleAccounts(names, addrs);

        (string memory name,, address acc, bool status) = loop.getAccount(0);

        assertEq(name, "Moses");
        assertEq(acc, address(1));
        assertEq(status, true);
    }
}