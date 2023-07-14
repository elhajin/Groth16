/*
    --> the implementation of the MIMC hash function as a circuit : 
    --> function : F(x) = (x + k + Ci)^3
        while : 
        1. (x) : the value that we gonna hash 
        2. (k) : a random constant for each round
        3. (Ci): constant values that are diffrent in each round , and they are constant for each circuit 
        NOTE: we choose (i)rounds , and run this function (i) times , in each round the (x) and (k) are constant and
            only the (Ci) get changed .
        NOTE: in our case we gonna use the power 5 ,for more randomness ;
*/
pragma circom  2.0.0;
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
