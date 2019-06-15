pragma solidity >=0.4.22 <0.7.0;

contract BookHotel {

    enum BookStatus { Created, Locked, Inactive }

    struct Booking {
        uint bookId;
        uint price;
        uint startDate;
        uint endDate;
        BookStatus status;
        address payable owner;
        address payable buyer;
    }

    uint256 public numHotels = 0;
    mapping(uint256 => Booking) public hotels;

    constructor() public {}

    function addBooking(
        uint price,
        uint startDate,
        uint endDate
    ) public payable returns(uint bookId) {
        require(msg.value > 0.1 ether, "You need at least 0.1 ETH to get a car");
        bookId = ++numHotels;
        Booking memory newBook = Booking(
            price,
            startDate,
            endDate,
            BookStatus.Created,
            msg.sender
        );
        BookHotel[bookId] = newBook;
    }

    modifier condition(bool _condition) {
        require(_condition, "ok");
        _;
    }

    modifier onlyBuyer() {
        require(
            msg.sender == buyer,
            "Only buyer can call this."
        );
        _;
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only seller can call this."
        );
        _;
    }

    modifier inState(BookStatus _state) {
        require(
            state == _state,
            "Invalid state."
        );
        _;
    }

    event Aborted();
    event PurchaseConfirmed();
    event ItemReceived();

    /// Abort the purchase and reclaim the ether.
    /// Can only be called by the owner before
    /// the contract is locked.
    function abort()
        public
        onlyOwner
        inState(BookStatus.created)
    {
        emit Aborted();
        state = State.Inactive;
        owner.transfer(address(this).balance);
    }

    /// Confirm the purchase as buyer.
    /// Transaction has to include `value` ether.
    /// The ether will be locked until confirmReceived
    /// is called.
    function checkIn(uint _bookId)
        public
        inState(BookStatus.created)
        condition(_bookId == ) //verify on check in that booking ID is correct
        payable
    {
        emit PurchaseConfirmed();
        buyer = msg.sender; //only buyer can confirm purchase
        state = State.Locked;
    }

    /// Confirm that you (the buyer) received the item.
    /// This will release the locked ether.
    function checkOut(uint _bookId)
        public
        onlyBuyer
        inState(BookStatus.Locked)
        condition(_bookId == bookId)
    {
        emit ItemReceived();
        // It is important to change the state first because
        // otherwise, the contracts called using `send` below
        // can call in again here.
        BookStatus.inactive

        // NOTE: This actually allows both the buyer and the seller to
        // block the refund - the withdraw pattern should be used.

        buyer.transfer(price);
        owner.transfer(address(this).balance);
    }
}