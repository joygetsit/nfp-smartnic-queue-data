#!/bin/bash

# Date: 	13-Mar-2023
# Author:	Joydeep Pal
# Description:	Traffic Manager Configuration for setting Shaper rates 
# 		and then enabling Shaper.

echo 'Enabling Level 2 shapers 0-3 and Level 0 shaper'
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMShaperReg.ShaperRate{{0..3},144}.Rate=0x3fff
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMShaperReg.ShaperRate2.Rate=1
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMShaperReg.ShaperRate144.Rate=2
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TrafficManagerReg.TrafficManagerConfig.ShaperEnable=1

nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMShaperReg.ShaperRate{{0..3},144}.Rate
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TrafficManagerReg.TrafficManagerConfig.ShaperEnable
