#include <memory.h>
#include "hash.h"
#include "prime.h"

template<typename T, typename HashAlg>
class HashSet
{
private:
    std::size_t _capacity;
    std::size_t _size;
    std::unique_ptr<T[]> _bucket;

    size_t _hash(T item)
    {
        return HashAlg(reinterpret_cast<uint32_t*>(item), sizeof(T) / sizeof(uint32_t)) % capacity
    }

public:
    HashSet() : _capacity(97), _size(0), _bucket(new T[_capacity]) {}

    std::size_t capacity()
    {
        return _capacity;
    }

    std::size_t size()
    {
        return _size;
    }

    void add(T item)
    {
        
    }
};