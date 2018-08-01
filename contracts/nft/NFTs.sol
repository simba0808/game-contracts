pragma solidity ^0.4.23;

import "../../node_modules/zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";
import "../../node_modules/zeppelin-solidity/contracts/ownership/Superuser.sol";
/**
 * @title LDBNFTs - LORDLESS BUILDING NFTs Contract
 * @dev This contract records the relationship of TOKEN ID ownership.
 * 
 * ██╗      ██████╗  ██████╗  ███╗   ██╗ ███████╗ ████████╗ ███████╗ ██╗
 * ██║      ██╔══██╗ ██╔══██╗ ████╗  ██║ ██╔════╝ ╚══██╔══╝ ██╔════╝ ██║
 * ██║      ██║  ██║ ██████╔╝ ██╔██╗ ██║ █████╗      ██║    ███████╗ ██║
 * ██║      ██║  ██║ ██╔══██╗ ██║╚██╗██║ ██╔══╝      ██║    ╚════██║ ╚═╝
 * ███████╗ ██████╔╝ ██████╔╝ ██║ ╚████║ ██║         ██║    ███████║ ██╗
 * ╚══════╝ ╚═════╝  ╚═════╝  ╚═╝  ╚═══╝ ╚═╝         ╚═╝    ╚══════╝ ╚═╝
 *
 * Visit the https://github.com/lordlessio/ldb-nft for more details
 * 
 */

interface IBuilding {
  function building(uint256 tokenId) external view returns (uint256, int, int, uint8, uint256);
  function isBuildingContract() external view returns (bool);
}

contract LDBNFTs is ERC721Token, IBuilding, Superuser {
  constructor(string name, string symbol) public
    ERC721Token(name, symbol)
  { }

  IBuilding public buildingContract;

  function mint(address _to, uint256 _tokenId) onlySuperuser public {
    super._mint(_to, _tokenId);
  }

  function burn(uint256 _tokenId) onlySuperuser public {
    super._burn(ownerOf(_tokenId), _tokenId);
  }

  function setTokenURI(uint256 _tokenId, string _uri) onlyOwnerOrSuperuser public {
    super._setTokenURI(_tokenId, _uri);
  }

  /**
   * @dev set the LDB contract address
   * @return building LDB contract address
   */
  function setBuildingContract(address building) onlySuperuser external {
    require(IBuilding(building).isBuildingContract());
    buildingContract = IBuilding(building);
  }

  function isBuildingContract() external view returns (bool) {
    return buildingContract.isBuildingContract();
  }

  /**
   * @dev get a Building's infomation 
   * @param tokenId tokenId
   * @return uint256 LDB's construction time
   * @return int LDB's longitude value 
   * @return int LDB's latitude value
   * @return uint8 LDB's reputation
   * @return uint256 LDB's activity
   */
  function building(uint256 tokenId) external view returns (uint256, int, int, uint8, uint256){
    return buildingContract.building(tokenId);
  }

}
