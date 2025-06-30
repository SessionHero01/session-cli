cmake_minimum_required(VERSION 3.15)

project(session-cli)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)

set(LIBIDN2_VERSION 2.3.7)
set(LIBIDN2_HASH SHA512=eab5702bc0baed45492f8dde43a4d2ea3560ad80645e5f9e0cfa8d3b57bccd7fd782d04638e000ba07924a5d9f85e760095b55189188c4017b94705bef9b4a66)

set(LIBICONV_VERSION 1.18)
set(LIBICONV_HASH SHA512=a55eb3b7b785a78ab8918db8af541c9e11deb5ff4f89d54483287711ed797d87848ce0eafffa7ce26d9a7adb4b5a9891cb484f94bd4f51d3ce97a6a47b4c719a)

set(GMP_MIRROR https://ftp.gnu.org/gnu/gmp)


add_subdirectory(libsession-util)
add_subdirectory(libsession-util-ext)

add_custom_target(session-native-bundle ALL
        COMMAND ${CMAKE_COMMAND} -E echo "Building all necessary libraries for libsession-ui"
        DEPENDS session-util-ext session-util
        # config crypto onionreq util protos
        )

