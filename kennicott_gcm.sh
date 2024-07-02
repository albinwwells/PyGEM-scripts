# KENNICOTT AND ROOT GLACIER SIMULATIONS FOR GCM AND SSP SCENARIOS

# define variables
startyr=2000
endyr=2100
start=$SECONDS

mamba activate oggm_env_emulator

rgi_no=1.15645 # 1.15645, 1.26722
ssp_list=('ssp126' 'ssp245' 'ssp370' 'ssp585')
model_list=('BCC-CSM2-MR' 'CESM2' 'CESM2-WACCM' 'EC-EARTH3' 'EC-EARTH3-Veg' 'FGOALS-f3-L' 'GFDL-ESM4' 'INM-CM4-8' 'INM-CM5-0' 'MPI-ESM1-2-HR' 'MRI-ESM2-0' 'NorESM2-MM')

# # for ERA5
# ssp_list=('ssp126')
# model_list=('ERA5')

# # Kennicott optimal params
# rgi_no=1.15645
# kp_opt=1.1 # CHANGE TO 'option_calibration=None'; CHECK glena_reg_fullfn
# tbias_opt=0.8
# ddfsnow_opt=0.002

# # Root optimal params
rgi_no=1.26722
# kp_opt=0.3 # CHANGE TO 'option_calibration=None'; CHECK glena_reg_fullfn
# tbias_opt=-1.8
# ddfsnow_opt=0.003
kp_opt=0.5 # CHANGE TO 'option_calibration=None'; CHECK glena_reg_fullfn
tbias_opt=0.8
ddfsnow_opt=0.002

# Iterate over the lists
for model_ in "${model_list[@]}"; do
    for ssp_ in "${ssp_list[@]}"; do
        echo "RGI: $rgi_no, GCM: $model_, SSP: $ssp_"
        # # ERA5
        # # python /Users/albinwells/Desktop/PyGEM-docs/PyGEM-scripts/run_simulation.py -rgi_glac_number $rgi_no -gcm_name $model_ -gcm_startyear $startyr -gcm_endyear $endyr
        # python /Users/albinwells/Desktop/PyGEM-docs/PyGEM-scripts/run_simulation.py -rgi_glac_number $rgi_no -gcm_name $model_ -gcm_startyear $startyr -gcm_endyear $endyr -kp $kp_opt -tbias $tbias_opt -ddfsnow $ddfsnow_opt
        
        # # CHANGE TO 'option_calibration='MCMC''
        # python /Users/albinwells/Desktop/PyGEM-docs/PyGEM-scripts/run_simulation.py -rgi_glac_number $rgi_no -gcm_name $model_ -scenario $ssp_ -gcm_startyear $startyr -gcm_endyear $endyr
        
        # # CHANGE TO 'option_calibration=None'
        python /Users/albinwells/Desktop/PyGEM-docs/PyGEM-scripts/run_simulation.py -rgi_glac_number $rgi_no -gcm_name $model_ -scenario $ssp_ -gcm_startyear $startyr -gcm_endyear $endyr -kp $kp_opt -tbias $tbias_opt -ddfsnow $ddfsnow_opt
    done
done
echo "TOTAL RUNTIME: "$(($SECONDS / 3600)) hrs $((($SECONDS / 60) % 60)) min $(($SECONDS % 60)) sec $((i)) iterations""
