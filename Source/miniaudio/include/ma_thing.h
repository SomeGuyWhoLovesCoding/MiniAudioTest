#pragma once
#include <vector>

int getMixerState(void);
double getPlaybackPosition(void);
double getDuration(void);
void seekToPCMFrame(int64_t pos);
void deactivate_decoder(int index);
void amplify_decoder(int index, double volume);
void setPlaybackRate(float value);
void start(void);
void stop(void);
void destroy(void);
int stopped(void);
void loadFiles(std::vector<const char*> argv);