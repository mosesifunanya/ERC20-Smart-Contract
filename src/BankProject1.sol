// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract BankProject1 {

    struct Account {
        string name;
        uint256 accountBalance;
        address accountAddress;
        bool accountStatus;
    }

    uint256 public totalAmountInBank;

    mapping(address => Account) public differentAccounts;

    event AccountCreated(address indexed accountHolder, string name);
    event Deposited(address indexed accountHolder, uint256 amount);
    event Withdrawn(address indexed accountHolder, uint256 amount);
    event Transferred(address indexed from, address indexed to, uint256 amount);
    event AccountClosed(address indexed accountHolder, uint256 remainingBalance);

    // 1. Create account
    function createAccount(string memory _name) public {
        require(!differentAccounts[msg.sender].accountStatus, "Account already exists");

        differentAccounts[msg.sender] = Account({
            name: _name,
            accountBalance: 0,
            accountAddress: msg.sender,
            accountStatus: true
        });

        emit AccountCreated(msg.sender, _name);
    }

    // 2. Deposit
    function userDeposit() public payable {
        require(differentAccounts[msg.sender].accountStatus, "Account does not exist");
        require(msg.value > 0, "Deposit must be greater than zero");

        differentAccounts[msg.sender].accountBalance += msg.value;
        totalAmountInBank += msg.value;

        emit Deposited(msg.sender, msg.value);
    }

    // 3. Withdraw
    function userWithdraw(uint256 amount) public {
        Account storage userAccount = differentAccounts[msg.sender];

        require(userAccount.accountStatus, "Account does not exist");
        require(amount > 0, "Amount must be greater than zero");
        require(userAccount.accountBalance >= amount, "Insufficient balance");

        userAccount.accountBalance -= amount;
        totalAmountInBank -= amount;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Withdrawal failed");

        emit Withdrawn(msg.sender, amount);
    }

    // 4. Transfer
    function transferTo(address _to, uint256 amount) public {
        Account storage senderAccount = differentAccounts[msg.sender];
        Account storage receiverAccount = differentAccounts[_to];

        require(senderAccount.accountStatus, "Sender account does not exist");
        require(receiverAccount.accountStatus, "Receiver account does not exist");
        require(_to != address(0), "Invalid recipient address");
        require(msg.sender != _to, "Cannot transfer to self"); // FIX ADDED
        require(amount > 0, "Amount must be greater than zero");
        require(senderAccount.accountBalance >= amount, "Insufficient balance");

        senderAccount.accountBalance -= amount;
        receiverAccount.accountBalance += amount;

        emit Transferred(msg.sender, _to, amount);
    }

    // 5. Close account
    function closeAccount() public {
        Account storage userAccount = differentAccounts[msg.sender];

        require(userAccount.accountStatus, "Account does not exist");

        uint256 remainingBalance = userAccount.accountBalance;

        userAccount.accountBalance = 0;
        userAccount.accountStatus = false;
        totalAmountInBank -= remainingBalance;

        if (remainingBalance > 0) {
            (bool success, ) = payable(msg.sender).call{value: remainingBalance}("");
            require(success, "Transfer of remaining balance failed");
        }

        emit AccountClosed(msg.sender, remainingBalance);
    }

    // 6. Get account
    function getAccount(address _user)
        public
        view
        returns (
            string memory name,
            uint256 balance,
            address accountAddress,
            bool status
        )
    {
        Account memory acc = differentAccounts[_user];
        return (acc.name, acc.accountBalance, acc.accountAddress, acc.accountStatus);
    }
}