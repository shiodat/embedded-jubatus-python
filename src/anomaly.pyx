cdef class Anomaly(_JubatusBase):
    cdef _Anomaly *_handle

    def __cinit__(self):
        self._handle = NULL

    def __dealloc__(self):
        if self._handle != NULL:
            del self._handle

    def _init(self, config):
        self._handle = new _Anomaly(config)
        self._type, self._model_ver = b'anomaly', 1

    def get_config(self):
        return self._handle.get_config().decode('utf8')

    def save_bytes(self):
        return self._handle.dump(self._type, self._model_ver)

    def load_bytes(self, x):
        return self._handle.load(x, self._type, self._model_ver)

    def clear(self):
        self._handle.clear()
        return True

    def clear_row(self, id_):
        self._handle.clear_row(id_.encode('utf8'))
        return True

    def add(self, row):
        cdef datum d
        cdef pair[string, float] r
        datum_py2native(row, d)
        r = self._handle.add(d)
        return AnomalyIdWithScore(r.first.decode('utf8'), r.second)

    def update(self, id_, row):
        cdef datum d
        datum_py2native(row, d)
        return self._handle.update(id_.encode('utf8'), d)

    def overwrite(self, id_, row):
        cdef datum d
        datum_py2native(row, d)
        return self._handle.overwrite(id_.encode('utf8'), d)

    def calc_score(self, row):
        cdef datum d
        datum_py2native(row, d)
        return self._handle.calc_score(d)

    def get_all_rows(self):
        cdef vector[string] ret = self._handle.get_all_rows()
        return [(<string>ret[i]).decode('utf8') for i in range(ret.size())]
