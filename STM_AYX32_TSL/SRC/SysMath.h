//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#ifndef __SysMath_H
#define __SysMath_H

#define SysABS(_v)            ((_v)<0) ? (-(_v)) : (_v)
#define SysNEG(_v,_n)         ((_n)<0) ? (-(_v)) : (_v)
#define SysMAX(_v0,_v1)       ((_v0)>(_v1)) ? (_v0) : (_v1)
#define SysMIN(_v0,_v1)       ((_v0)<(_v1)) ? (_v0) : (_v1)
#define SysIsNEG(_v)          ((_v)<0)
#define SysIsPOS(_v)          ((_v)>=0)
#define SysFrac(_v)           ((_v)>=0) ? ((_v)-((u32)(_v))) : ((_v)+((u32)(_v)))

#endif
