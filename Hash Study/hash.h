#include <cstddef>
#include <cstdint>

/**
 * A hashing algorithm based on a Linear Congruential Generator
 */
template<uint64_t modulus = INT64_MAX, uint64_t multiplier = 6364136223846793005, uint64_t increment = 12345>
uint64_t LCRHash(uint32_t* data, std::size_t length)
{
    uint64_t rv = 0;
    for(std::size_t i = 0; i < length; i++)
    {
        uint64_t seed = (rv << (sizeof(uint64_t) / 2)) | data[i];
        rv = (multiplier * seed + increment) % modulus;
    }

    return rv;
}