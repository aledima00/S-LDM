#include "frameBuffer.h"
#include <unistd.h>
#include <GeographicLib/Constants.hpp>
#include <string>
#include <sstream>
#include <iomanip>


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

bool FrameBuffer::addCustom(vehicleSnapshot_t* vs) {
    if(_idx>=_maxsz)
        return false;

    _data[_idx] = *vs;
    _idx++;

    return true;
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

void FrameBuffer::flushToFd(serialization_t serType) {
    switch(serType){
        case binary:
            write(_fd, &_idx, sizeof(uint16_t)); // First write the number of entries
            write(_fd, _data, sizeof(FrameBuffer::vehicleSnapshot_t)*_idx);
            break;
        case json:
            std::ostringstream ss;
            ss << "[";
            for (size_t i = 0; i < _idx; ++i) {
                const auto& v = _data[i];

                ss << "{"
                << "\"stationID\":" << v.stationID << ","
                << "\"width\":" << std::fixed << std::setprecision(3) << v.width << ","
                << "\"length\":" << std::fixed << std::setprecision(3) << v.length << ","
                << "\"stationType\":" << static_cast<int>(v.stationType) << ","
                << "\"x\":" << std::fixed << std::setprecision(6) << v.x << ","
                << "\"y\":" << std::fixed << std::setprecision(6) << v.y << ","
                << "\"speed\":" << std::fixed << std::setprecision(6) << v.speed << ","
                << "\"heading\":" << std::fixed << std::setprecision(6) << v.heading
                << "}";

                if (i != _idx - 1)
                    ss << ",";
            }
            ss << "]\n";
            std::string serialized = ss.str();
            write(_fd, serialized.c_str(), serialized.size());
    }
    _idx=0;
}

bool FrameBuffer::empty() {
    return (_idx==0);
}

