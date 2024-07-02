# KENNICOTT AND ROOT GLACIER SIMULATIONS FOR GCM AND SSP SCENARIOS

# define variables -- CHECK glena_reg_fullfn, option_calibration=None
startyr=2000
endyr=2100
start=$SECONDS
glac='Kennicott' # 'Kennicott', 'Root'

mamba activate oggm_env_emulator

ssp_list=('ssp126' 'ssp245' 'ssp370' 'ssp585')
model_list=('BCC-CSM2-MR' 'CESM2' 'CESM2-WACCM' 'EC-EARTH3' 'EC-EARTH3-Veg' 'FGOALS-f3-L' 'GFDL-ESM4' 'INM-CM4-8' 'INM-CM5-0' 'MPI-ESM1-2-HR' 'MRI-ESM2-0' 'NorESM2-MM')
model_list=('NorESM2-MM')
# model_list=('ERA5')
# ssp_list=('')

# Get optimal parameter sets
if [[ $glac == "Kennicott" ]]; then
    rgi_no=1.15645 # Kenicott
    csv_file="../Output/simulations/opt_params/kenn_opt_params.csv" # Kennicott
    # csv_file="../Output/simulations/opt_params/kenn_opt_params_n312.csv" # Kennicott
else
    rgi_no=1.26722 # Root
    csv_file="../Output/simulations/opt_params/root_opt_params.csv" # Root
fi

params=$(awk -F, 'NR>1 {print $2,$3,$4}' "$csv_file")

i_total=$(echo "$params" | wc -l | tr -d '[:space:]')
i=0

# Iterate through parameter space
for model_ in "${model_list[@]}"; do
    for ssp_ in "${ssp_list[@]}"; do
        echo "$params" | while read -r kp_ tbias_ ddfsnow_; do
            i_percent=$(echo "scale=3; ($i / $i_total) * 100" | bc -l)
            ddfsnow_=$(echo "scale=3; $ddfsnow_ / 1000" | bc -l)
            echo "model: $model_, ssp: $ssp_, kp: $kp_, tbias: $tbias_, ddfsnow: $ddfsnow_, i: $i out of $i_total, $i_percent% complete"
            i=$((i+1));

            # FOR ERA5
            # python /Users/albinwells/Desktop/PyGEM-docs/PyGEM-scripts/run_simulation.py -rgi_glac_number $rgi_no -gcm_name $model_ -gcm_startyear $startyr -gcm_endyear $endyr -kp $kp_ -tbias $tbias_ -ddfsnow $ddfsnow_

            # FOR GCMs
            python /Users/albinwells/Desktop/PyGEM-docs/PyGEM-scripts/run_simulation.py -rgi_glac_number $rgi_no -gcm_name $model_ -scenario $ssp_ -gcm_startyear $startyr -gcm_endyear $endyr -kp $kp_ -tbias $tbias_ -ddfsnow $ddfsnow_
        done
    done
done

echo "TOTAL RUNTIME: "$(($SECONDS / 3600)) hrs $((($SECONDS / 60) % 60)) min $(($SECONDS % 60)) sec $((i)) iterations""

