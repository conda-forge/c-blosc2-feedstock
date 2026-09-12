#include <blosc2.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

int main(void) {
    const char *codecs[] = {"blosclz", "lz4", "lz4hc", "zlib", "zstd"};
    int32_t input[4096], restored[4096];
    uint8_t compressed[sizeof(input) + BLOSC2_MAX_OVERHEAD];
    for (int i = 0; i < 4096; ++i) input[i] = i / 8;
    blosc2_init();
    blosc2_set_nthreads(2);
    for (unsigned i = 0; i < sizeof(codecs) / sizeof(codecs[0]); ++i) {
        if (blosc1_set_compressor(codecs[i]) < 0) return 1;
        int size = blosc1_compress(5, BLOSC_BITSHUFFLE, sizeof(input[0]), sizeof(input),
                                  input, compressed, sizeof(compressed));
        if (size <= 0) return 2;
        if (blosc1_decompress(compressed, restored, sizeof(restored)) != sizeof(input) ||
            memcmp(input, restored, sizeof(input))) return 3;
        printf("Installed %s bitshuffle round trip passed\n", codecs[i]);
    }
    blosc2_destroy();
    return 0;
}
