#pragma once
#include <vector>

extern float playbackRate;
extern int MIXER_STATE;
extern int exists;

extern int getMixerState(void);
extern double getPlaybackPosition(void);
extern double getDuration(void);
extern void seekToPCMFrame(int64_t pos);
extern void deactivate_decoder(int index);
extern void amplify_decoder(int index, double volume);
extern void setPlaybackRate(float value);
extern void start(void);
extern void stop(void);
extern void destroy(void);
extern int stopped(void);
extern void loadFiles(std::vector<const char*> argv);