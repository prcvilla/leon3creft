#include <stdio.h>

int checksum(const char*);

int checksum(const char *s) {
    int c = 0;

    while(*s)
        c ^= *s++;

    return c;
}

const char *nmeamsg = "GPGGA,092750.000,5321.6802,N,00630.3372,W,1,8,1.03,61.7,M,55.2,M,,";

int main(void) {
    char chksum[2];

    sprintf(chksum, "%X", checksum(nmeamsg));
    printf("NMEA Msg: %s\nChecksum: 0x%s\n", nmeamsg, chksum);

    return 0;
}
