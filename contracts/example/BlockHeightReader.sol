// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.9;

import "./GenericCovalentDataReader.sol";

contract BlockHeightReader is GenericCovalentDataReader {
    using Chainlink for Chainlink.Request;

    uint256 public latestHeight;

    bytes32 private jobId;
    uint256 private fee;

    constructor() GenericCovalentDataReader(_msgSender()) {
        setChainlinkToken(0xa36085F69e2889c224210F603D836748e7dC0088);
        setChainlinkOracle(0x74EcC8Bdeb76F2C6760eD2dc8A46ca5e581fA656);
        jobId = "c515bbbf48774d0f97df67333f092d91";
        fee = (1 * LINK_DIVISIBILITY) / 10; // 0,1 * 10**18 (Varies by network and job)
    }

    function getTheCurrentNFTOwner() external {
        sendDataUpdateRequest(jobId, "v1/1/block_v2/latest/", "uint256", "items,0,quote_rate,height", fee);
    }

    /**
     * @notice override the fulfillCovalentDataRequest func
     *
     * @param _requestId the Oracle requestId
     * @param data the returnned data
     */
    function fulfillCovalentDataRequest(bytes32 _requestId, bytes memory data) public override recordChainlinkFulfillment(_requestId) {
        (uint256 height) = abi.decode(data, (uint256));
        latestHeight = height;
    }
}
