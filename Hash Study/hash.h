#include <cstddef>

/**
 * A hashing algorithm based on a Linear Congruential Generator
 */
class LCRHash
{
private:
    const unsigned long modulus;
    const unsigned long multiplier;
    const unsigned long increment;

public:
    explicit LCRHash(unsigned long modulus      = 2147483648,
                     unsigned long multiplier   = 1103515245,
                     unsigned long increment    = 12345) :
                     modulus(modulus),
                     multiplier(multiplier),
                     increment(increment) {}

    unsigned long hash(unsigned short* data, std::size_t size)
    {
        unsigned long rv = 0;

        for(std::size_t i = 0; i < size; i++)
        {
            unsigned long seed = (rv << (sizeof(unsigned long) / 2)) | data[i];
            rv = (multiplier * seed + increment) % modulus;
        }

        return rv;
    }
};