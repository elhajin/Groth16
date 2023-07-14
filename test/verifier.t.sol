//SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import {Groth16Verifier} from "../src/Verifier.sol";

contract groth16Test is Test{
    Groth16Verifier verifier = Groth16Verifier(0x6C77d5Fb53212e3206691bFACBB96a0874cCa1D3);
    string sepolia = vm.envString("sepolia_url");
    uint fork;
    function setUp()public  {
        // we need to create a fork : 
       fork =  vm.createFork(sepolia);
        vm.selectFork(fork);
        
    }

    function test__verifyProof() public {
        // check that the fork is active : 
        assertEq(vm.activeFork(),fork,"fork not active");
        // the valid data from zksnarks: 
        bool responseValid = verifier.verifyProof([0x07d95b6cc9c96b0d02ee0c9c40fc25b03b554054374b49e8abc0d8430ca07ab7, 
         0x19fc21f573e36f456a7217e1fe7295b5446777127446d15c4d2b480c1769fcec],
         [[0x2d7dc8fa823020b03d695adf4c7ff3ab372555f28bc89f5308d8e2a0b43d29a9,
         0x12521440e46c2094217c76789aa9f68cc41c4ed6921f0ca2261f9a4ee7420794],
         [0x155ffec1720ce460aa7948185e52649f5acf7c4f14d0efcbc68619c62c300bba, 
         0x1e3f1af20679f80675959abf85961cca057cc58522061cf6f09f935e8420039e]],
         [0x1d08fdd7f4b9e1e35eadf5a6c8c8b6475eeda0a59f8c9f65dfc9ad8026553086,
          0x0ddbbaf6dd4649a5edccea28e539f368db829ba57b5325c9bce6a5dce4e2d8e3],
          [0x0718e749c63e0d5c73460a7ad9e6fd8670811ef8c132c662394051320e50b62f]);

        assertTrue(responseValid,"response not valid but it should i don't know WTF is wrong");
        if(responseValid){
            console.log(unicode"\n🎉 Congratulations, Proof is Valid 🎉");
        }
    }
}