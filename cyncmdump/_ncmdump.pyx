# cython: language_level=3
# cython: cdivision=True
cimport cython

from cyncmdump.ncm cimport (CreateNeteaseCrypt, DestroyNeteaseCrypt, Dump,
                            FixMetadata, NeteaseCrypt)


cdef inline bytes ensure_bytes(object inp):
    if isinstance(inp, str):
        return inp.encode()
    elif isinstance(inp, (bytes, bytearray)):
        return bytes(inp)
    else:
        return inp


@cython.freelist(8)
@cython.no_gc
@cython.final
cdef class CryptContext:
    cdef NeteaseCrypt* _c

    def __cinit__(self, str path):
        cdef bytes bytes_path = ensure_bytes(path)
        self._c = CreateNeteaseCrypt(<const char *> bytes_path)
        if self._c == NULL:
            raise MemoryError

    def __dealloc__(self):
        if self._c:
            DestroyNeteaseCrypt(self._c)
            self._c = NULL

    cpdef inline int dump(self):
        cdef int ret
        with nogil:
            ret = Dump(self._c)
        return ret

    cpdef inline fix_metadata(self):
        with nogil:
            FixMetadata(self._c)
