// SPDX-License-Identifier: UNLICENSED
// Specify version of solidity file (https://solidity.readthedocs.io/en/v0.4.24/layout-of-source-files.html#version-pragma)
pragma solidity ^0.8.6;
library SafeMath {

    /**
    * @dev Multiplies two numbkers, throws on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        require(c / a == b, "SafeMath mul failed");
        return c;
    }

    /**
    * @dev Integer division of two numbers, truncating the quotient.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    /**
    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath sub failed");
        return a - b;
    }

    /*
    * @dev Adds two numbers, throws on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        require(c >= a, "SafeMath add failed");
        return c;
    }

    /**
     * @dev gives square root of given x.
     */
    function sqrt(uint256 x) internal pure returns (uint256 y) {
        uint256 z = ((add(x,1)) / 2);
        y = x;
        while (z < y)
        {
            y = z;
            z = ((add((x / z),z)) / 2);
        }
    }

    /**
     * @dev gives square. multiplies x by x
     */
    function sq(uint256 x) internal pure returns (uint256) {
        return (mul(x,x));
    }

    /**
     * @dev x to the power of y 
     */
    function pwr(uint256 x, uint256 y) internal pure returns (uint256) {
        if (x==0)
            return (0);
        else if (y==0)
            return (1);
        else
        {
            uint256 z = x;
            for (uint256 i=1; i < y; i++)
                z = mul(z,x);
            return (z);
        }
    }
}
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }

    function _msgValue() internal view virtual returns (uint256 value) {
        return msg.value;
    }
}

contract Mass is Owner{
    struct MassStruct{
        uint8 minAmount;
        uint maxAmount;
    }
    IERC20 usdt;
    MassStruct public item;
    uint public usdtBalance;
    //合约地址
    address private _currentAddress = address(this);

    mapping(address => address) agents;//agent

    //terminator
    address private terminator_;
    bool public terminated_ = false;
    modifier onlyTerminator() {
        require(_msgSender() == terminator_);
        _;
    }
    function getTerminator() public view onlyOwner returns(address) {
        return terminator_;
    }

    modifier whenNotTerminated() {
        require(!terminated_);
        _;
    }

    //initial capital
    uint public initialCapital;

    //dever
    address private dever_;
    //operator
    address private operator_;
    modifier onlyOperator() {
        require(_msgSender() == operator_);
        _;
    }

    event Withdraw( address _operatorAddress, uint _value, uint _balance);

    function withdrawal(uint _value) public onlyOperator {
        require(usdt.balanceOf(address(this))  >= _value, 'lack of balance');
        usdt.transfer(_msgSender(), _value);
        usdtBalance -= _value;
        emit Withdraw(_msgSender(), _value,usdt.balanceOf(address(this)));
    }
    function getBalance() public view returns(uint) {
        // return usdt.balanceOf(address(this));
        return address(this).balance;
    }
   
    event Overdue( uint _txid);
    receive() external payable {}
    fallback() external payable {}
    //构造
    constructor(IERC20 _usdt, address _operator, address _terminator) {
        usdt = _usdt;
        uint8 _min = 1;
        uint _max = 1000000;
        item = MassStruct(_min, _max);
        operator_ = _operator;
        terminator_ = _terminator;
    }
    function setMinAmount(uint8 _min) public onlyOwner returns(bool){
        item.minAmount = _min;
        return true;
    }

    function setMaxAmount(uint _max) public onlyOwner returns(bool){
        item.maxAmount = _max;
        return true;
    }
}
