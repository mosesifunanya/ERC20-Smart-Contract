// SPDX-License-Identifier:MIT
pragma solidity 0.8.33;

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract ERC20OZ is ERC20, Ownable {
    string public sName;
    string private sSymbol;

    constructor(string memory _name, string memory _symbol)
        ERC20(_name, _symbol)
        Ownable(msg.sender)
    {
        sName = _name;
        sSymbol = _symbol;
        _mint(address(this), 10000000000);
    }

    function mint(uint _amount, address meThief) public onlyOwner {
        _mint(meThief, _amount);
    }

    function burn(uint256 amount) public onlyOwner {
        _burn(address(this), amount);
    }
}