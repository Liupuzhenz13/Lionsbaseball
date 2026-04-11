# Lionsbaseball


MATLAB tools for batter biomechanics analysis.  バッターのスティックピクチャ作成

## batter_movie.m

Creates 3D stick figure animations of batting motion using Hawk-Eye data(jason).

1. Run `batter_movie.m` in MATLAB
2. Select a Hawk-Eye JSON file
3. Enter parameters:
   - Horizontal angle (view from 1B side: 90, from 3B side: -90)
   - Elevation angle (from above: 90)
   - Duration (max 2 seconds)
4. Animation video is generated automatically

pitcher biomechanics 2025
HalkEyeJSON_Motion2025_1.m
Batch-processes Hawk-Eye 3D motion capture JSON files to compute a comprehensive set of pitching biomechanics metrics (

utput (60 variables per pitch)
#VariablesDescription1–4Play ID, DateTime, Pitcher nameMetadata5Pitch speedkm/h6–17Event timingssec (relative to ball release)18–29Angles at foot contactElbow height, MER, stride, pelvis height, joint angles30–43Angles at ball releasePelvis, thorax, knee, arm slot (azimuth/elevation/slot)44–46Peak speeds & max separationPelvis speed, thorax-pelvis separation47–52Peak angular velocities & timingsPelvis, thorax, upper arm53–56Ball trajectoryTravel distance, 3D/horizontal/vertical curvature57–60ContextRunner on 1B/2B/3B, date
