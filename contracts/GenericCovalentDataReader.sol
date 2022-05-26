// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.9;

import "@openzeppelin/contracts/token/ERC777/IERC777.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";

abstract contract GenericCovalentDataReader is ChainlinkClient, ConfirmedOwner, Context {
    using Chainlink for Chainlink.Request;

    constructor(address _msgSender) ConfirmedOwner(_msgSender) {}

    /**
     * @notice recordChainlinkFulfillment(_requestId)
     *
     * @param _jobId The Chainlink jobId
     * @param _URI The Covalent url path e.g. "v1/1/block_v2/latest/" to get the latest block height of Ethereum Mainnet.
     * @param _types the data decode types e.g. "uint256"
     * @param _path the path to find the desired data in the API response.
     *      It uses a JSONPath expression with comma(,) delimited string for nested objects. For example: "RAW,ETH,USD,VOLUME24HOUR"
     * @param _fee the Chainlink Oracle fee
     */
    function sendDataUpdateRequest(
        bytes32 _jobId,
        string memory _URI,
        string memory _types,
        string memory _path,
        uint256 _fee
    ) public returns (bytes32) {
        Chainlink.Request memory req = buildChainlinkRequest(_jobId, address(this), this.fulfillCovalentDataRequest.selector);
        req.add("uri", _URI);
        req.add("types", _types);
        req.add("path", _path);

        return sendChainlinkRequest(req, _fee);
    }

    /**
     * @notice The implementation contract must add the modifier of recordChainlinkFulfillment(_requestId).
     *
     * @param _requestId the call
     */
    function fulfillCovalentDataRequest(bytes32 _requestId, bytes memory data) public virtual;
}
