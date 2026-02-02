#ifndef FRAMEBUFFER_H
#define FRAMEBUFFER_H
#include "vehicleDataDef.h"
#include <GeographicLib/TransverseMercator.hpp>

// Class that stores a map frame snapshot by accumulating multiple vehicle data entries, then allowing to serialize them as a block
class FrameBuffer {
    public:

        // basic block: vehicle snapshot
        typedef struct {
            // id
            uint64_t stationID;
            
            // vinfo
            float width;
            float length;
            ldmmap::e_StationTypeLDM stationType;

            // time info
            double x;
            double y;
            double speed;
            double heading;
        } vehicleSnapshot_t;

        FrameBuffer(int fd, uint16_t maxsz, double lon0, double k0=0.9996);
        ~FrameBuffer();

        void setMaxSize(uint16_t maxsz);
        uint16_t getMaxSize();

        bool add(ldmmap::vehicleData_t *vd);
        void flushToFd();
        // #TODO:CHECK if add here filtering on time and veh uniqueness or in main add looped function
        bool empty();
    private:
        int _fd;
        uint16_t _maxsz;
        uint16_t _idx;
        double _lon0;
        GeographicLib::TransverseMercator *_tm_converter_ptr;
        vehicleSnapshot_t *_data;
};

#endif // FRAMEBUFFER_H