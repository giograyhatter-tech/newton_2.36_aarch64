# Newton 2.36 -- Changes vs Newton 2.00

**Source:** rastullahs-lockenpracht/newton\
**Version:** Newton 2.36 (replacement of original Newton 2.00)

------------------------------------------------------------------------

## 📁 File: coreLibrary_200/source/CMakeLists.txt

### 🔧 Build system changes

-   Removed x86-specific flags:

    ``` bash
    -msse*
    -mfpmath=sse
    ```

-   Added global definition:

    ``` bash
    -D_SCALAR_ARITHMETIC_ONLY
    ```

📌 Impact: - Forces scalar arithmetic only (no x86 SIMD usage) -
Improves portability (especially ARM/aarch64)

------------------------------------------------------------------------

## 📁 File: coreLibrary_200/source/core/dgTypes.cpp (line \~200)

### 🔧 ARM64 compatibility

Added ARM64 branch:

``` cpp
#elif defined(__aarch64__)
```

📌 Location: Before:

``` cpp
#else
// x86 inline asm cpuid
```

📌 Impact: - Prevents use of x86 cpuid inline assembly on ARM - Enables
clean compilation on aarch64

------------------------------------------------------------------------

## 📁 File: coreLibrary_200/source/core/dgMemory.h

### 🔧 Memory alignment update

Changed:

``` cpp
#ifdef __x86_64__
```

to:

``` cpp
#if defined(__x86_64__) || defined(__aarch64__)
```

Retains:

``` cpp
DG_MEMORY_GRANULARITY_BITS = 6
```

📌 Impact: - ARM64 uses same memory granularity as x86_64 - Ensures
consistent alignment behavior

------------------------------------------------------------------------

## 📁 File: coreLibrary_200/source/core/dgThreads.cpp

### 🔧 Concurrency fix (ARM)

In `dgSpinUnlock`, added:

``` cpp
__sync_synchronize();
*spin = 0;
```

📌 Impact: - Adds explicit memory barrier - Fixes ARM weak memory
ordering issues - Prevents race conditions on unlock

------------------------------------------------------------------------

## 🧹 Line ending normalization

Converted CRLF → LF:

``` bash
sed -i 's/\r//' <files>
```

📌 Impact: - Fixes Linux/CI build issues - Normalizes text format

------------------------------------------------------------------------

## ⚙️ Build instructions (copy & paste)

``` bash
git clone https://github.com/rastullahs-lockenpracht/newton.git
cd newton/coreLibrary_200

mkdir build
cd build

cmake ..   -DCMAKE_BUILD_TYPE=Release   -DCMAKE_POLICY_VERSION_MINIMUM=3.5   -D_SCALAR_ARITHMETIC_ONLY=ON

make -j$(nproc)
```

------------------------------------------------------------------------

## 🧠 Summary

-   Removed legacy x86 SIMD dependencies
-   Added full ARM64 (aarch64) support
-   Fixed spinlock memory ordering issues
-   Improved portability and consistency
-   Modernized build configuration
