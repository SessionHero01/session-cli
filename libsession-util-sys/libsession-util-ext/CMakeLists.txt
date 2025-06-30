
add_library(
        session-util-ext
        STATIC
        src/session_config.cpp
        src/session_config.h
        src/session_encoding.h
        src/session_encoding.cpp
)

target_link_libraries(
        session-util-ext
        PUBLIC
        config
        oxenc
        util
        fmt
)
