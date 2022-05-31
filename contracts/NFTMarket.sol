// SPDX license identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";


contract NFTMarket is ReentrancyGuard{
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    Counters.Counter private _itemsSold;

    address payable owner;
    uint256 listingPrice = 0.025 ether;

    constructor(){
        owner = payable(msg.sender);
    }
    struct MarketItem {
        uint itemId;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }
    mapping(uint256 => MarketItem) private idToMarketItems;
    event MarketItemCreated (
        uint indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    function getListingPrice() public view returns (uint256){
        return listingPrice;
    }

    function createMarketItem(
        address nftContract,
        uint256 tokenId,
        uint256 price
    ) public payable nonReentrant {
        require(price > 0 ,"Price must be atleast 1 wei");
        require(msg.value == listingPrice, "Price must match listing price");

        _itemIds.increment();
        uint256 itemId = _itemIds.current();
        idToMarketItems[itemId] = MarketItem(
            itemId, nftContract, tokenId, payable(msg.sender), payable(address(0)),
             price, false
        );

        IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);

        emit MarketItemCreated(itemId, nftContract, tokenId, payable(msg.sender), payable(address(0)), price, false);
    }
    function createMarketSale(
        address nftContract,
        uint256 itemId
    ) public payable nonReentrant {
        uint price = idToMarketItems[itemId].price;
        uint tokenId = idToMarketItems[itemId].tokenId;
        require(msg.value == price, "Price must match asking price");

        idToMarketItems[itemId].seller.transfer(msg.value);
        IERC721(nftContract).transferFrom( address(this),msg.sender, tokenId);
        idToMarketItems[itemId].owner = payable(msg.sender);
        idToMarketItems[itemId].sold = true;
        _itemsSold.increment();
        payable(owner).transfer(listingPrice);
    
    }
    function fetchMarketItems() public view returns (MarketItem[] memory) {
        
    }
}