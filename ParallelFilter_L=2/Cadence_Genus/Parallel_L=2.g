#import_oa_db -ref_lib cds.lib
set_db init_lib_search_path /cad/cds/GF_PDK/45SPCLO/45spclo_SC_BASE_9T_SG40RVT_2023q4v1/
set_db library /cad/cds/GF_PDK/45SPCLO/45spclo_SC_BASE_9T_SG40RVT_2023q4v1/liberty/ccs_lib/45spclo_SC_BASE_9T_SG40RVT_TT_1P00V_85C_ccs.lib
read_hdl -sv ../filter.sv
elaborate
read_sdc ./timing.sdc
syn_generic
syn_map
report_timing >  ./2ParallelFilter_Timing.rpt
report_area   >> ./2ParallelFilter_Area.rpt
report_power >> ./2ParallelFilter_Power.rpt

