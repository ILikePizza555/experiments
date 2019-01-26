bool isPrime(unsigned long p) {
    for(unsigned int i = 2; i < p; i++)
    {
        if(p % i == 0) return false;
    }
    return true;
}

unsigned long nextPrime(unsigned long start) {
    if(start == 0) return 1;

    //Bertrand's posulate says that we are garunteed to find a prime between (n, 2n)
    unsigned long rv = start;
    while(!isPrime(rv)) {
        rv++;
    }
    return rv;
}