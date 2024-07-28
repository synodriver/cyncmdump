# cython: language_level=3
# cython: cdivision=True
cdef extern from "libncmdump.h" nogil:
    ctypedef struct NeteaseCrypt:
        pass
    NeteaseCrypt * CreateNeteaseCrypt(const char * path)
    int Dump(NeteaseCrypt * neteaseCrypt)
    void FixMetadata(NeteaseCrypt * neteaseCrypt)
    void DestroyNeteaseCrypt(NeteaseCrypt * neteaseCrypt)