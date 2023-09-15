#!/bin/bash

# Date - 13th March 2023
# Author - Joydeep Pal
# Description - Traffic Manager Configuration for setting Shaper rates and then enabling Shaper.

nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMShaperReg.ShaperRate{{0..3},144}.Rate=0x3fff
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMShaperReg.ShaperRate2.Rate=1
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMShaperReg.ShaperRate144.Rate=2
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TrafficManagerReg.TrafficManagerConfig.ShaperEnable=1

nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMShaperReg.ShaperRate{{0..3},144}.Rate
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TrafficManagerReg.TrafficManagerConfig.ShaperEnable