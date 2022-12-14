// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}


contract StableFundBUSD  is Ownable, ReentrancyGuard{
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    
    uint256 public developerFee = 300; // 300 : 3 %. 10000 : 100 %
    uint256 public rewardPeriod = 1 days;
    uint256 public withdrawPeriod = 4 weeks;
    uint256 public apr = 150; // 150 : 1.5 %. 10000 : 100 %
    uint256 public percentRate = 10000;
    address private devWallet;
    address public BUSDContract;
    uint256 public _currentDepositID = 0;

    uint256 public totalInvestors = 0;
    uint256 public totalReward = 0;
    uint256 public totalInvested = 0;

    uint256 public startDate;

    struct DepositStruct{
        address investor;
        uint256 depositAmount;
        uint256 depositAt; // deposit timestamp
        uint256 claimedAmount; // claimed busd amount
        bool state; // withdraw capital state. false if withdraw capital
    }

    struct InvestorStruct{
        address investor;
        uint256 totalLocked;
        uint256 startTime;
        uint256 lastCalculationDate;
        uint256 claimableAmount;
        uint256 claimedAmount;
    }

    // mapping from depost Id to DepositStruct
    mapping(uint256 => DepositStruct) public depositState;
    // mapping form investor to deposit IDs
    mapping(address => uint256[]) public ownedDeposits;

    //mapping from address to investor
    mapping(address => InvestorStruct) public investors;

    constructor(address _devWallet,address _busdContract, uint256 _startDate) {
        require(_devWallet!=address(0),"Please provide a valid dev wallet address");
        require(_busdContract!=address(0),"Please provide a valid busd contract address");
        devWallet = _devWallet;
        BUSDContract = _busdContract;
        startDate = _startDate;
    }

    function resetContract(address _devWallet) public onlyOwner {
        require(_devWallet!=address(0),"Please provide a valid address");
        devWallet = _devWallet;
    }

    function changeBUSDContractAddress(address _busdContract) public onlyOwner{
        require(_busdContract!=address(0),"Please provide a valid address");
        BUSDContract = _busdContract;
    }

    function _getNextDepositID() private view returns (uint256) {
        return _currentDepositID + 1;
    }

    function _incrementDepositID() private {
        _currentDepositID++;
    }

    function deposit(uint256 _amount) external {
        require(block.timestamp>=startDate,"Cannot deposit at this moment");
        require(_amount > 0, "you can deposit more than 0 busd");

        IERC20(BUSDContract).safeTransferFrom(msg.sender,address(this),_amount);

        uint256 _id = _getNextDepositID();
        _incrementDepositID();

        uint256 depositFee = (_amount * developerFee).div(percentRate);
        // transfer 3% fee to dev wallet
        IERC20(BUSDContract).safeTransfer(devWallet,depositFee);

        depositState[_id].investor = msg.sender;
        depositState[_id].depositAmount = _amount - depositFee;
        depositState[_id].depositAt = block.timestamp;
        depositState[_id].state = true;

        if(investors[msg.sender].investor==address(0)){
            totalInvestors = totalInvestors.add(1);

            investors[msg.sender].investor = msg.sender;
            investors[msg.sender].startTime = block.timestamp;
            investors[msg.sender].lastCalculationDate = block.timestamp;
        }

        uint256 lastRoiTime = block.timestamp - investors[msg.sender].lastCalculationDate;
        uint256 allClaimableAmount = (lastRoiTime *
            investors[msg.sender].totalLocked *
            apr).div(percentRate * rewardPeriod);

        investors[msg.sender].claimableAmount = investors[msg.sender].claimableAmount.add(allClaimableAmount);
        investors[msg.sender].totalLocked = investors[msg.sender].totalLocked.add( _amount - depositFee);
        investors[msg.sender].lastCalculationDate = block.timestamp;

        totalInvested = totalInvested.add(_amount);

        ownedDeposits[msg.sender].push(_id);
    }

    // claim all rewards of user
    function claimAllReward() public nonReentrant {
        require(ownedDeposits[msg.sender].length > 0, "you can deposit once at least");
            
        uint256 lastRoiTime = block.timestamp - investors[msg.sender].lastCalculationDate;
        uint256 allClaimableAmount = (lastRoiTime *
            investors[msg.sender].totalLocked *
            apr).div(percentRate * rewardPeriod);
         investors[msg.sender].claimableAmount = investors[msg.sender].claimableAmount.add(allClaimableAmount);

        uint256 amountToSend = investors[msg.sender].claimableAmount;
        
        if(getBalance()<amountToSend){
            amountToSend = getBalance();
        }
        
        investors[msg.sender].claimableAmount = investors[msg.sender].claimableAmount.sub(amountToSend);
        investors[msg.sender].claimedAmount = investors[msg.sender].claimedAmount.add(amountToSend);
        investors[msg.sender].lastCalculationDate = block.timestamp;
        IERC20(BUSDContract).safeTransfer(msg.sender,amountToSend);
        totalReward = totalReward.add(amountToSend);
    }
    
    // withdraw capital by deposit id
    function withdrawCapital(uint256 id) public nonReentrant {
        require(
            depositState[id].investor == msg.sender,
            "only investor of this id can claim reward"
        );
        require(
            block.timestamp - depositState[id].depositAt > withdrawPeriod,
            "withdraw lock time is not finished yet"
        );
        require(depositState[id].state, "you already withdrawed capital");

        uint256 claimableReward = getAllClaimableReward(msg.sender);

        require(
            depositState[id].depositAmount + claimableReward <= getBalance(),
            "no enough busd in pool"
        );


        investors[msg.sender].claimableAmount = 0;
        investors[msg.sender].claimedAmount = investors[msg.sender].claimedAmount.add(claimableReward);
        investors[msg.sender].lastCalculationDate = block.timestamp;
        investors[msg.sender].totalLocked = investors[msg.sender].totalLocked.sub(depositState[id].depositAmount);

        uint256 amountToSend = depositState[id].depositAmount + claimableReward;

        // transfer capital to the user
        IERC20(BUSDContract).safeTransfer(msg.sender,amountToSend);
        totalReward = totalReward.add(claimableReward);

        depositState[id].state = false;
    }

    function getOwnedDeposits(address investor) public view returns (uint256[] memory) {
        return ownedDeposits[investor];
    }

    function getAllClaimableReward(address _investor) public view returns (uint256) {
         uint256 lastRoiTime = block.timestamp - investors[_investor].lastCalculationDate;
          uint256 allClaimableAmount = (lastRoiTime *
            investors[_investor].totalLocked *
            apr).div(percentRate * rewardPeriod);

         return investors[_investor].claimableAmount.add(allClaimableAmount);
    }

    
    function depositFunds(uint256 _amount) external onlyOwner returns(bool) {
        require(_amount > 0, "you can deposit more than 0 BUSD");
        IERC20(BUSDContract).safeTransferFrom(msg.sender,address(this),_amount);
        return true;
    }

    function withdrawFunds(uint256 _amount) external onlyOwner nonReentrant {
        // transfer fund
        IERC20(BUSDContract).safeTransfer(msg.sender,_amount);
    }

    function getBalance() public view returns(uint256) {
        return IERC20(BUSDContract).balanceOf(address(this));
    }

    // calculate total rewards
    function getTotalRewards() public view returns (uint256) {
        return totalReward;
    }

    // calculate total invests
    function getTotalInvests() public view returns (uint256) {
        return totalInvested;
    }
}
