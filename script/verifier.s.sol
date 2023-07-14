//SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import {Groth16Verifier} from "../src/Verifier.sol";

contract verifierScript is Script{
    // declare the contract here : 
    Groth16Verifier verifier;
    function run() public {
        vm.startBroadcast();
        verifier = new Groth16Verifier();
        console.log(address(verifier));
        vm.stopBroadcast();
    }
}
