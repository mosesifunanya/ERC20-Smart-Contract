// SPDX-License-Identifier: MIT
pragma solidity 0.8.33;

import {Test} from "../lib/forge-std/src/Test.sol";
import {ERC20OZ} from  "../src/ERC20.sol";

contract ERC20OZTest is Test {
    ERC20OZ token;

    address owner = address(this);
    address user = address(1);

    function setUp() public {
        token = new ERC20OZ("TestToken", "TTK");
    }

    // 1. Test initial supply minted to contract
    function testInitialSupply() public {
        assertEq(token.balanceOf(address(token)), 10000000000);
    }

    // 2. Test owner can mint
    function testOwnerCanMint() public {
        token.mint(1000, user);
        assertEq(token.balanceOf(user), 1000);
    }

    // 3. Test non-owner cannot mint
    function testNonOwnerCannotMint() public {
        vm.prank(user);
        vm.expectRevert();
        token.mint(1000, user);
    }

    // 4. Test owner can burn
    function testOwnerCanBurn() public {
        uint256 initial = token.balanceOf(address(token));
        token.burn(1000);
        uint256 finalBal = token.balanceOf(address(token));
        assertEq(finalBal, initial - 1000);
    }

    // 5. Test non-owner cannot burn
    function testNonOwnerCannotBurn() public {
        vm.prank(user);
        vm.expectRevert();
        token.burn(1000);
    }
}