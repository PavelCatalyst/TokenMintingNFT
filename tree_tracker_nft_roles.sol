// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

//Start by setting correct address of erc20 smart contract
contract TreeTracker is ERC1155, AccessControl {
    bytes32 public constant URI_SETTER_ROLE = keccak256("URI_SETTER_ROLE"); //Role: 0x7804d923f43a17d325d77e781528e0793b2edd9890ab45fc64efd7b4b427744c
    uint256 public constant TREE1 = 0;
    uint256 public constant TREE2 = 1;
    address public erc20_address = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;

    mapping (uint256 => string) private _uris;
    mapping (uint256 => uint256) private _carbonStores;
    //carbon stores are initialized to zero and then added to

    constructor() ERC1155("") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(URI_SETTER_ROLE, msg.sender);
        _mint(msg.sender, TREE1, 1, "");
        _mint(msg.sender, TREE2, 1, "");
        setURI(0, "https://bafkreidh5tkinsbpewpv2jjhzxxs56r6pvseb3nuimhucosr4fqmrt72hq.ipfs.nftstorage.link/");
        setURI(1, "https://bafkreia2452woyydxxe4u4gsofbfyinif7nlfkfjfe3wrmnlozy5ghssmq.ipfs.nftstorage.link/");
    }

    function uri(uint256 tokenID) override public view returns (string memory) {
        return(_uris[tokenID]);
    }

    function carbonStore(uint256 tokenID) public view returns (uint256) {
        return(_carbonStores[tokenID]);
    }

    function setURI(uint256 tokenID, string memory newuri) public onlyRole(URI_SETTER_ROLE) {
        // require(bytes(_uris[tokenID]).length == 0, "Cannot set uri twice");
        _uris[tokenID] = newuri;
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data) public onlyRole(URI_SETTER_ROLE) {
        _mint(account, id, amount, data);
        //data = 0x0000000000000000000000000000000000000000000000000000000000000000
    }

    function setErc20Address(address contractad) public onlyRole(URI_SETTER_ROLE) {
        erc20_address = contractad;
    }

    function mintTokens(address to, uint256 amount) public onlyRole(URI_SETTER_ROLE) {
        TreeCarbon ERCContract = TreeCarbon(erc20_address);
        ERCContract.mint(to, amount);
    }

    function addCarbonStore(uint256 tokenID, address tokenHolder, uint256 addedCarbon) public onlyRole(URI_SETTER_ROLE) {
        _carbonStores[tokenID] += addedCarbon;
        mintTokens(tokenHolder, addedCarbon);
    }


    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC1155, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}