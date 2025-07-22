// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract CallAnything {
    address public s_address;
    uint256 public s_amount;
    string private constant FUNCTION_SIGNATURE = "transfer(address,uint256)";

    function transfer(address someAddress, uint256 amount) public {
        s_address = someAddress;
        s_amount = amount;
    }

    function getFunctionSelector() public pure returns (bytes4) {
        return bytes4(keccak256(bytes(FUNCTION_SIGNATURE)));
    }

    function callFunctionWithSelector(address someAddress, uint256 someAmount) public returns (bytes4, bool) {
        (bool success, bytes memory returnData) = address(this).call(
            abi.encodeWithSelector(getFunctionSelector(), someAddress, someAmount)
        );
        return (bytes4(returnData), success);
    }

    function callFunctionWithSignature(address someAddress, uint256 someAmount) public returns (bytes4, bool) {
        (bool success, bytes memory returnData) = address(this).call(
            abi.encodeWithSignature(FUNCTION_SIGNATURE, someAddress, someAmount)
        );
        return (bytes4(returnData), success);
    }

    function getAddress() public view returns (address) {
        return s_address;
    }

    function getTotalAmount() public view returns (uint256) {
        return s_amount;
    }

}