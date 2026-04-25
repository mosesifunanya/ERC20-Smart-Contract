// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract ForLoop {

    struct Account {
        string name;
        uint256 accountBalance;
        address accountAddress;
        bool accountStatus;
    }

    Account[] public accounts;

    function createMultipleAccounts(
        string[] memory _names,
        address[] memory _addresses
    ) public {

        require(_names.length == _addresses.length, "Length mismatch");

        for (uint256 i = 0; i < _names.length; i++) {
            accounts.push(Account({
                name: _names[i],
                accountBalance: 0,
                accountAddress: _addresses[i],
                accountStatus: true
            }));
        }
    }

    function getTotalAccounts() public view returns (uint256) {
        return accounts.length;
    }

    function getAccount(uint256 index)
        public
        view
        returns (
            string memory name,
            uint256 balance,
            address accountAddress,
            bool status
        )
    {
        Account memory acc = accounts[index];
        return (acc.name, acc.accountBalance, acc.accountAddress, acc.accountStatus);
    }
}