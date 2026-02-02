#include "frameBuffer.h"
#include <unistd.h>
#include <GeographicLib/Constants.hpp>


FrameBuffer::FrameBuffer(int fd, uint16_t maxsz, double lon0, double k0): _fd(fd), _maxsz(maxsz), _idx(0), _lon0(lon0), _tm_converter_ptr(nullptr), _data(nullptr) {
    const double a = GeographicLib::Constants::WGS84_a();
    const double f = GeographicLib::Constants::WGS84_f();
    _tm_converter_ptr = new GeographicLib::TransverseMercator(a,f,k0);

    _data = new vehicleSnapshot_t[_maxsz];
}

FrameBuffer::~FrameBuffer() {
    delete[] _data;
    _data = nullptr;
    delete _tm_converter_ptr;
    _tm_converter_ptr = nullptr;
}

void FrameBuffer::setMaxSize(uint16_t maxsz) {
    if(_data!=nullptr) {
        delete[] _data;
    }
    _maxsz = maxsz;
    _data = new vehicleSnapshot_t[_maxsz];
    _idx=0;
}

uint16_t FrameBuffer::getMaxSize() {
    return _maxsz;
}



bool FrameBuffer::add(ldmmap::vehicleData_t *vd) {
    if(_idx>=_maxsz)
        return false;

    double x,y;
    _tm_converter_ptr->Forward(_lon0, vd->lat, vd->lon, x, y);
    FrameBuffer::vehicleSnapshot_t frame = FrameBuffer::vehicleSnapshot_t {
        vd->stationID,
        vd->vehicleWidth.isAvailable() ? static_cast<float>(vd->vehicleWidth.getData()) : 0.0f,
        vd->vehicleLength.isAvailable() ? static_cast<float>(vd->vehicleLength.getData()) : 0.0f,
        vd->stationType,
        x,
        y,
        vd->speed_ms,
        vd->heading
    };

    _data[_idx] = frame;
    _idx++;

    return true;
}

void FrameBuffer::flushToFd() {
    write(_fd, _data, sizeof(FrameBuffer::vehicleSnapshot_t)*_idx);
    _idx=0;
}

bool FrameBuffer::empty() {
    return (_idx==0);
}

