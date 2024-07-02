# KENNICOTT AND ROOT GLACIER SIMULATION PARAMETER GRIDSEARCH

# TO RUN
    # navigate to folder in terminal
    # ./kennicott_gs.sh
    # 1200 iterations take ~1 hr

# define variables
startyr=1940
endyr=2022
start=$SECONDS

mamba activate oggm_env_emulator

# use our glen_a
# binned results

# from Rounce et al., 2023:
# Kennicott (1.15645)
# kp range: [0.293,3.022]
# tbias range: [-3.017,4.249]
# ddfsnow range: [0.001,0.007]

# Root (01.26722)
# kp range: [0.124,3.655]
# tbias range: [-2.646,4.866]
# ddfsnow range: [0.002,0.009]

# # -------- --------   --------   -------- -------- # #
# # Kennicott                                                                                     # first test  # dense test (4hrs)
# kp=($(seq 0.0 0.5 3.2)) # precipitation factor                                                  (0, .5,3)     (0.2 0.2 3.2)
# tbias=($(seq -3 .5 4)) # temperature bias (tbias) - [C]                                        (-3, .5, 4)    (-3 .5 4.5)
# ddfsnow=($(seq 0.001 .001 .007)) # degree day factor of snot (ddfsnow) - [m w.e. d^-1 C^-1]    (1, 1, 7)      (1.5 .5 7.5)

# # Root                                                                                        # first test      # dense test
# kp=($(seq 0.2 0.2 3.2)) # precipitation factor                                                (.2, .5, 3.6)     (0.2, 0.1, 1.3)
# tbias=($(seq -3.0 .5 4.5)) # temperature bias (tbias) - [C]                                   (-2.6, .5, 4.8)   (-3 .2 3)
# ddfsnow=($(seq 0.0015 .0005 .0075)) # degree day factor of snot (ddfsnow) - [m w.e. d^-1 C^-1]   (1, 1, 9)      (1.5 .5 7.5)

# denser gridsearch
kp=($(seq 2.7 0.1 3.0)) # precipitation factor   # 16 (7)
tbias=($(seq -3.0 .2 3.5)) # temperature bias (tbias) - [C] # 16 (15)
ddfsnow=($(seq 0.001 .001 .008)) # 13 (7)

i=0
i_total=$(( ${#kp[@]} * ${#tbias[@]} * ${#ddfsnow[@]} ))

# build parameter set text file that will be passed to python call as CLI
for kp_ in ${kp[@]}; do
    for tbias_ in ${tbias[@]}; do
        for ddfsnow_ in ${ddfsnow[@]}; do
            if [ ! -f /Users/albinwells/Desktop/PyGEM-docs/Output/simulations/01/ERA5/stats/1.15645_ERA5_kp"$kp_"_ddfsnow"$ddfsnow_"_tbias"$tbias_"_ba0_1sets_"$startyr"_"$endyr"_all.nc ]; then
                i_percent=$(echo "scale=3; ($i / $i_total) * 100" | bc -l)
                echo "kp: $kp_, tbias: $tbias_, -ddfsnow: $ddfsnow_, i: $i out of $i_total, $i_percent% complete"
                # python /Users/albinwells/Desktop/PyGEM-docs/PyGEM-scripts/run_simulation.py -rgi_glac_number 1.15645 -gcm_startyear $startyr -gcm_endyear $endyr -tbias $tbias_ -kp $kp_ -ddfsnow $ddfsnow_ -gcm_name 'ERA5'
                python /Users/albinwells/Desktop/PyGEM-docs/PyGEM-scripts/run_simulation.py -rgi_glac_number 1.26722 -gcm_startyear $startyr -gcm_endyear $endyr -tbias $tbias_ -kp $kp_ -ddfsnow $ddfsnow_ -gcm_name 'ERA5'
                i=$((i+1));
            fi
        done
    done
done
echo "TOTAL RUNTIME: "$(($SECONDS / 3600)) hrs $((($SECONDS / 60) % 60)) min $(($SECONDS % 60)) sec $((i)) iterations""
