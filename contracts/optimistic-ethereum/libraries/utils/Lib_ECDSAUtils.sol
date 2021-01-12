// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

/**
 * @title Lib_ECDSAUtils
 */
library Lib_ECDSAUtils {

    /**************************************
     * Internal Functions: ECDSA Recovery *
     **************************************/

    /**
     * Recovers a signed address given a message and signature.
     * @param _message Message that was originally signed.
     * @param _isEthSignedMessage Whether or not the user used the `Ethereum Signed Message` prefix.
     * @param _v Signature `v` parameter.
     * @param _r Signature `r` parameter.
     * @param _s Signature `s` parameter.
     * @return _sender Signer address.
     */
    function recover(
        bytes memory _message,
        bool _isEthSignedMessage,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    )
        internal
        pure
        returns (
            address _sender
        )
    {
        bytes32 messageHash = getMessageHash(_message, _isEthSignedMessage);

        return ecrecover(
            messageHash,
            _v + 27,
            _r,
            _s
        );
    }

    function getMessageHash(
        bytes memory _message,
        bool _isEthSignedMessage
    )
        internal
        pure
        returns (bytes32) {
        if (_isEthSignedMessage) {
            return getEthSignedMessageHash(_message);
        }
        return getNativeMessageHash(_message);
    }


    /*************************************
     * Private Functions: ECDSA Recovery *
     *************************************/

    /**
     * Gets the native message hash (simple keccak256) for a message.
     * @param _message Message to hash.
     * @return _messageHash Native message hash.
     */
    function getNativeMessageHash(
        bytes memory _message
    )
        private
        pure
        returns (
            bytes32 _messageHash
        )
    {
        return keccak256(_message);
    }

    /**
     * Gets the hash of a message with the `Ethereum Signed Message` prefix.
     * @param _message Message to hash.
     * @return _messageHash Prefixed message hash.
     */
    function getEthSignedMessageHash(
        bytes memory _message
    )
        private
        pure
        returns (
            bytes32 _messageHash
        )
    {
        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        bytes32 messageHash = keccak256(_message);
        return keccak256(abi.encodePacked(prefix, messageHash));

// @note: this message is reachable via Lib_ECDSAUtils.recover()... 
// probably not a big deal, but need to check. 
// ## SWC-128: DoS With Block Gas Limit
// Potentially unbounded data structure passed to builtin.
// Gas consumption in function "getEthSignedMessageHash" in contract "Lib_ECDSAUtils" depends on the size of data structures that may grow unboundedly. Specifically the "1-st" argument to builtin "abi.encodePacked" may be able to grow unboundedly causing the builtin to consume more gas than the block gas limit, effectively causing a denial-of-service condition.Consider that an attacker might attempt to cause this condition on purpose.

// ### Severity: Low

// ### Code
// ```
// 92 |              )
// 93 |          {
// 94 |              bytes memory prefix = "\x19Ethereum Signed Message:\n32";
// 95 |              bytes32 messageHash = keccak256(_message);
// 96 |  >>>         return keccak256(abi.encodePacked(prefix, messageHash)); <<<
// ```
        


    }
}