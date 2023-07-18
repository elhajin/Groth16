## 💎 💎 💎 <span style="color:#c94d68"> Elhaj </span> 💎 💎 💎

# **_Groth16 snark_** :

_in this section we gonna create a Minimalistic `zero knowledge proof` system using [Groth16](https://xn--2-umb.com/22/groth16) [snark](https://vitalik.ca/general/2021/01/26/snarks.html)_

### _<spna style= "color: #587c82"> Getting start: </span>_

- to generate the system we'll use :

  - [_`circom`_](https://docs.circom.io/)
  - [_`snarkjs`_](https://consensys.net/blog/developers/introduction-to-zk-snarks/)

- there are some steps that we will follow to generate this system : <br>
  1️⃣ create the [_circuit_](https://www.researchgate.net/publication/320654830_Design_of_Circuit_System-Based_Cryptography) that we gonna use to generate the `proof` and the `verification` system. <br>

  - this [_circuit_](https://www.researchgate.net/publication/320654830_Design_of_Circuit_System-Based_Cryptography) is gonna implement the [**_MIMC_**](https://byt3bit.github.io/primesym/mimc/) hash funciton. the reason of using this function cause it's a lightweight function and it will not cost alot of gas like the **_sha256_** for example when we apply it on the blockchain.

  - we gonna implement this [_circuit_](https://www.researchgate.net/publication/320654830_Design_of_Circuit_System-Based_Cryptography) using [`circom`](https://docs.circom.io/) language.

  2️⃣ after implementing the [_circuit_](https://www.researchgate.net/publication/320654830_Design_of_Circuit_System-Based_Cryptography) .we'll generate the setup for the [Groth16](https://xn--2-umb.com/22/groth16/#trusted-setup).

## _Dependency_:

**_Install node_**<br>
First off, make sure you have a recent version of `Node.js` installed. While any version after `v12` should work fine, we recommend you install `v16` or later.

If you’re not sure which version of Node you have installed, you can run:

```sh
node -v
```

To download the latest version of Node, see [here](https://nodejs.org/en/download/).

**_Install snarkjs_** <br>

To install `snarkjs` run:

```sh
npm install -g snarkjs@latest
```

If you're seeing an error, try prefixing both commands with `sudo` and running them again.

**_Understand the `help` command_**<br>

To see a list of all `snarkjs` commands, as well as descriptions about their inputs and outputs, run:

```sh
snarkjs --help
```

### Install circom

To install `circom`, follow the instructions at [installing circom](https://docs.circom.io/getting-started/installation).

**_Now let's implement the circuit_**

## 1. circuit:

- this is the implementation **_`circuit`_** of the [**_MIMC_**](https://byt3bit.github.io/primesym/mimc/) function in the **_`circom`_** language :

  ```circom
      /_
      --> the implementation of the MIMC hash function as a circuit :
      --> function : F(x) = (x + k + Ci)^3
      while : 1. (x) : the value that we gonna hash 2. (k) : a random constant for each round 3. (Ci): constant values that are diffrent in each round , and they are constant for each circuit
      NOTE: we choose (i)rounds , and run this function (i) times , in each round the (x) and (k) are constant and
      only the (Ci) get changed .
      NOTE: in our case we gonna use the power 5 ,for more randomness ;
      _/
    pragma circom 2.0.0;
    template mimc5() {
        // inputs and outputs :
        signal input x;
        signal input k;
        signal output out;
        var rounds = 15;
        var c[rounds] = [
            0,
            21469745217645236226405533686231592324177671190346326883245530828586381403876,
            50297292308054131785073003188640636012765603289604974664717077154647718767691,
            106253950757591248575183329665927832654891498741470681534742234294971120334749,
            16562112986402259118419179721668484133429300227020801196120440207549964854140,
            57306670214488528918457646459609688072645567370160016749464560944657195907328,
            108800175491146374658636808924848899594398629303837051145484851272960953126700,
            52091995457855965380176529746846521763751311625573037022759665111626306997253,
            4647715852037907467884498874870960430435996725635089920518875461648844420543,
            19720773146379732435540009001854231484085729453524050584265326241021328895041,
            2468135790246813579024681357902468135790246813579024681357902468,
            1357924680135792468013579246801357924680135792468013579246801357,
            8642097531864209753186420975318642097531864209753186420975318642,
            3141592653589793238462643383279502884197169399375105820974944592,
            2718281828459045235360287471352662497757247093699959574966967627
            ];//this is a hardcoded random numbers

            var base[rounds];
            signal lastOutput[16];
            signal base2[rounds];
            signal base4[rounds];
            lastOutput[0]<==x;

            for (var i = 0;i<rounds;i++){
                // calculate the first base which is x (f(x) = x^5) ;
                base[i] = lastOutput[i] + k+ c[i];
                base2[i] <== base[i] * base[i];
                base4[i] <== base2[i] * base2[i];
                lastOutput[i + 1] <== base4[i] * base[i];
            }
            out <== lastOutput[rounds] + k;

        }
        component main = mimc5();

  ```

  **_Now let's set the setup_**

## 2. Setup :

- to create a [groth16 setup](https://xn--2-umb.com/22/groth16/#trusted-setup) we gonna do the following steps :

* **_[`pawer of tau`](https://xn--2-umb.com/22/groth16/#powers-of-tau) ._**

- 1️⃣ Create a new `ceremony` with the elliptic curve [bn128](https://snyk.io/advisor/npm-package/elliptic/functions/elliptic.curve).

- 2️⃣ Second you pass the ceremony file to `N` number of contributors that add additional randomness each time and you keep the last generated file.

* **_[`phase 2`](https://xn--2-umb.com/22/groth16/#phase-2)_**

- you just need to feed this final `ceremony` file to the circuit, and it will give you a `zkey` file .

---

### _<spna style= "color: #587c82"> Coding part: </span>_

**_in our case snarkjs make it easy for us to generate random ceremony files, and contribute with randmness._**

- creat a ceremony file with snark js :

  ```bash
  snarkjs powersoftau new bn128 12 ceremony_0.ptau
  ```

- contribute with random data by runnig :

  ```bash
  snarkjs powersoftau contribute ceremony_0.ptau random_1.ptau -v
  ```

  by running the obove command you'll asked to put an input. put random input (numbers,characters ,symbols ..)

  > _`Notice`: in real world senario alot of random people are contributes in this part passing alot of random inputs. and if only one of the contributers are honest. we ensure the randomness_

  _in the real cases it's always recommended to verify the ceremony file with `snarkjs` running the command:_

  ```bash
  snarkjs powersoftau verify <fileName>.ptau
  ```

  and you should see msg like this : `"snarkJS: ZKey Ok!"`

  - _keep generation a new `ceremony` file from the last one you generated and delete the last one , as many as you want, then keep the last file.ptau ._

- now we need to prepare the phase2 by running :

  ```bash
  snarkjs powersoftau prepare phase2 lastrandom.ptau final.ptau
  ```

- now compile the `circuit` to an `r1cs` format so we can feed it to the final ceremony file that we generated randomlly (🙈 🙉 🙊 *I hope so*🙈 🙉 🙊) :

  ```bash
  circom mimc.circom --r1cs
  ```

- Finally let's set up the [Groth16](https://xn--2-umb.com/22/groth16/#trusted-setup) :

  ```bash
  snarkjs groth16 setup mimc.r1cs final.ptau outputZkey.zkey
  ```

  - _`Additional step`_ : to make sure all this is random. we could add more randomness to the `zkey` file that we computed. by running : (_this is optional_)

    ```bash
    snarkjs zkey contribute outputZkey.zkey finalZkey.zkey
    ```

  - to make sure that the `zkey` file is generated Correctly run:<br>

    > `snarkjs zkey verify r1cs [circuit.r1cs] [powersoftau.ptau] [circuit_final.zkey]`

    ```bash
    snarkjs zkey verify mimc.r1cs final.ptau finalZkey.zkey
    ```

    and you should see in the last line the msg : `"snarkJS: ZKey Ok!"`

---

- **_<span style = "color:#9fcf3a"> But how to generate a proof ❓😕 </span>_**

_To generate the proof from this setup we need :_

1. **input.json** : we need to provide the inputs that we wanna proof knowledge of to the verifier as a json format .
   - _`example :`_
     ```.json
     {
       "x": 73249023423490833,
       "y": 324235235342342423423
     }
     ```
2. **circuit.wasm** : the `wasm` format of the circuit .
3. **final.zkey** : the `zkey` file that we generated in the setup.

## let's continue with code :

- first let's generate the input that we wanna proof the knowledge of as a json file:

  ```.json
  {
    "x":1258847665265646546465,
    "k":8923410096358576854354354
  }
  ```

- second lets get the web assembly format (`wasm`) of the circuit by running : <br>

  ```bash
  circom mimc.circom --wasm
  ```

  - this will create for you a new directory named : mimc_js, and in this directory you will find the `.wasm` file that we need.

- finally run the command that generate the proof : <br>

  > `snarkjs groth16 fullprove [input.json] [circuit_final.wasm] [circuit_final.zkey] [proof.json] [public.json]`

  ```bash
  snarkjs groth16 fullprove input.json mimc_js/mimc.wasm finalZkey.zkey proof.json public.json
  ```

  - this cammand will generate two `.json` files .

    - _`public.json`_ : this contains the circuit output,in our case this will be the hash that we generated.
    - _`proof.json`_ : this is the proof that you will submit to the verifier.\_

  ***

- **_<span style = "color:#9fcf3a"> Now how the Verification ability will be implemented in the blockchain ❓😕 </span>_**

  _Well `snarkjs` have this very cool method that will generate the smart contract for you from the `zkey` file._<br>
  _you just need to run the command :_

  ```bash
  snarkjs zkey export solidityverifier finalZkey.zkey Verifier.sol
  ```

  <br>

  - this will create a solidity file named `verifier.sol`.

---

## **Deploy the contract**:

now we have our verification contract let's deploy it in the sepolia network using [foundry](https://book.getfoundry.sh/).

1. copy the file to the `src` directory in the repo.
2. deploy the contract by running the command :<br>
   ```bash
   $ export pk=<your private key>
   $ export url=https://eth-sepolia.g.alchemy.com/v2/<your apikey>
   $ export etherscan=<etherscan apikey>
   $ forge create --rpc-url $url --private-key $pk --etherscan-api-key $etherscan --verify src/Verifier.sol:Groth16Verifier
   ```

---

### Alright now we've :

- created a circuit .
- create a setup.
- generate proof.
- deployed the verfier contract on blockchain. <br>

### 🧪🧪🧪 it's time to test it 🧪🧪🧪🧪

➡️ you may already notice that our [contract](https://sepolia.etherscan.io/address/0x6C77d5Fb53212e3206691bFACBB96a0874cCa1D3#code) have only one _view_ funciton (`verifyProof()`). <br>
➡️this function takes a proof, and if the proof is **valid** it returns **`true`**, and if not it reutrns **`false`**<br>
➡️ now let's test it with a valid and non valid proof: <br>

- _in directory `test` create anew file `verifier.t.sol`_ and write this part of code :

  ```solidity
  //SPDX-License-Identifier: MIT
  pragma solidity >=0.7.0 <0.9.0;

  import "forge-std/Test.sol";
  import "forge-std/console.sol";
  import {Groth16Verifier} from "../src/Verifier.sol";

  contract groth16Test is Test{
      Groth16Verifier verifier = Groth16Verifier(0x6C77d5Fb53212e3206691bFACBB96a0874cCa1D3);
      string sepolia = vm.envString("sepolia_url");
      uint fork;
      function setUp()public  {
          // we need to create a fork :
        fork =  vm.creatFork(sepolia);
          vm.selectFork(fork);

  }}
  ```

  - so the function `verifyProof()` in our deployed contract takes the `proof` which is the `proof.json` that we get earlier. <br>
    but we need a proof that is accepted by solidity 😕 <br>
    to get the `proof` That is compatible with our solidity function run the command:

  ```bash
   snarkjs zkey export soliditycalldata public.json proof.json
  ```

  - copy the out put and pass it in to the test function like (see ⤵️)

    > _`notice`_ : make sure to remove the quotation.

  - now add the test funciton with your output calldata :

    ```solidity
      function test__verifyProof() public {
        // check that the fork is active :
        assertEq(vm.activeFork(),fork,"fork not active");
        // the valid data from zksnarks:
        bool responseValid = verifier.verifyProof(["0x07d95b6cc9c96b0d02ee0c9c40fc25b03b554054374b49e8abc0d8430ca07ab7",
         "0x19fc21f573e36f456a7217e1fe7295b5446777127446d15c4d2b480c1769fcec"],
         [["0x2d7dc8fa823020b03d695adf4c7ff3ab372555f28bc89f5308d8e2a0b43d29a9",
         "0x12521440e46c2094217c76789aa9f68cc41c4ed6921f0ca2261f9a4ee7420794"],
         ["0x155ffec1720ce460aa7948185e52649f5acf7c4f14d0efcbc68619c62c300bba",
         "0x1e3f1af20679f80675959abf85961cca057cc58522061cf6f09f935e8420039e"]],
         ["0x1d08fdd7f4b9e1e35eadf5a6c8c8b6475eeda0a59f8c9f65dfc9ad8026553086",
          "0x0ddbbaf6dd4649a5edccea28e539f368db829ba57b5325c9bce6a5dce4e2d8e3"],
          ["0x0718e749c63e0d5c73460a7ad9e6fd8670811ef8c132c662394051320e50b62f"]);

        assertTrue(responseValid,"response not valid but it should. i don't know WTF is wrong");
    }
    ```

  - then run the command : <br>
    ```bash
      forge test -vvv
    ```
