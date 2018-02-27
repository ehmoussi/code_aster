! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------
! person_in_charge: mickael.abbas at edf.fr
!
module NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
!
! --------------------------------------------------------------------------------------------------
!
! Non-Linear operators
!
! Define types for datastructures
!
! --------------------------------------------------------------------------------------------------
!

!
! - Type: column for table
! 
    type NL_DS_Column
        character(len=16)  :: name
        character(len=16)  :: title(3)
        character(len=1)   :: mark
        aster_logical      :: l_vale_affe
        aster_logical      :: l_vale_inte
        aster_logical      :: l_vale_real
        aster_logical      :: l_vale_cplx
        aster_logical      :: l_vale_strg
        integer            :: vale_inte
        real(kind=8)       :: vale_real
        complex(kind=8)    :: vale_cplx
        character(len=16)  :: vale_strg
    end type NL_DS_Column
!
! - Type: table in output datastructure
! 
    type NL_DS_TableIO
! ----- Name of result datastructure
        character(len=8)           :: result = ' '
! ----- Parameters for table in output Datastructure
        character(len=19)          :: table_name = ' '
        character(len=24)          :: table_type = ' '
! ----- List of parameters
        integer                    :: nb_para = 0
        integer                    :: nb_para_inte = 0
        integer                    :: nb_para_real = 0
        integer                    :: nb_para_cplx = 0
        integer                    :: nb_para_strg = 0
        character(len=24), pointer :: list_para(:) => null()
        character(len=8), pointer  :: type_para(:) => null()
    end type NL_DS_TableIO
!
! - Type: table 
! 
    type NL_DS_Table
! ----- Number of active columns
        integer                :: nb_cols
! ----- Maximum number of columns in table
        integer                :: nb_cols_maxi = 39
! ----- List of columns in table
        type(NL_DS_Column)     :: cols(39)
! ----- List of _active_ columns in table
        aster_logical          :: l_cols_acti(39)
! ----- Total width of table
        integer                :: width
! ----- Number of lines for title
        integer                :: title_height
! ----- Separation line
        character(len=512)     :: sep_line
! ----- Flag for outside file (CSV)
        aster_logical          :: l_csv
! ----- Logical unit for outside file (CSV)
        integer                :: unit_csv
! ----- Table in output datastructure
        type(NL_DS_TableIO)    :: table_io
! ----- Index to values
        integer                :: indx_vale(39)
    end type NL_DS_Table
!
! - Type: print
! 
    type NL_DS_Print
        aster_logical :: l_print
        type(NL_DS_Table) :: table_cvg
        aster_logical :: l_info_resi
        aster_logical :: l_info_time
        aster_logical :: l_tcvg_csv
        integer :: tcvg_unit
        integer :: reac_print
        character(len=512) :: sep_line
    end type NL_DS_Print
!
! - Type: residuals
! 
    type NL_DS_Resi
        character(len=16) :: type
        character(len=24) :: col_name
        character(len=24) :: col_name_locus
        character(len=16) :: event_type
        real(kind=8)      :: vale_calc
        character(len=16) :: locus_calc
        real(kind=8)      :: user_para
        aster_logical     :: l_conv
    end type NL_DS_Resi
!
! - Type: reference residuals
! 
    type NL_DS_RefeResi
        character(len=16) :: type
        real(kind=8)      :: user_para
        character(len=8)  :: cmp_name
    end type NL_DS_RefeResi
!
! - Type: convergence management
! 
    type NL_DS_Conv
        integer :: nb_resi
        integer :: nb_resi_maxi = 7
        type(NL_DS_Resi)     :: list_resi(7)
        aster_logical        :: l_resi_test(7)
        integer :: nb_refe
        integer :: nb_refe_maxi = 11
        type(NL_DS_RefeResi) :: list_refe(11)
        aster_logical        :: l_refe_test(11)
        integer :: iter_glob_maxi
        integer :: iter_glob_elas
        aster_logical :: l_stop
        aster_logical :: l_stop_pene
        aster_logical :: l_iter_elas
        real(kind=8)  :: swap_trig
        real(kind=8)  :: line_sear_coef
        integer       :: line_sear_iter
    end type NL_DS_Conv
!
! - Type: Line search parameters
! 
    type NL_DS_LineSearch
        character(len=16) :: method
        real(kind=8)      :: resi_rela
        integer           :: iter_maxi
        real(kind=8)      :: rho_mini
        real(kind=8)      :: rho_maxi
        real(kind=8)      :: rho_excl
    end type NL_DS_LineSearch
!
! - Type: algorithm parameters
! 
    type NL_DS_AlgoPara
        character(len=16)      :: method
        character(len=16)      :: matrix_pred
        character(len=16)      :: matrix_corr
        integer                :: reac_incr
        integer                :: reac_iter
        real(kind=8)           :: pas_mini_elas
        integer                :: reac_iter_elas
        aster_logical          :: l_line_search
        type(NL_DS_LineSearch) :: line_search
        aster_logical          :: l_pilotage
        aster_logical          :: l_dyna
        character(len=8)       :: result_prev_disp
        aster_logical          :: l_matr_rigi_syme
    end type NL_DS_AlgoPara
!
! - Type: fields for input/output management
!
!     type            Name of field (type) in results datastructure
!     gran_name       Type of GRANDEUR
!     field_read      Name of field read in ETAT_INIT
!     disc_type       Spatial discretization of field (ELEM, ELGA, ELNO)
!     init_keyw       Keyword for ETAT_INIT
!     obsv_keyw       Keyword for OBSERVATION
!     l_read_init     Field can been read for initial state
!     l_store         Field can been store (ARCHIVAGE)
!     l_obsv          Field can been observed (OBSERVATION)
!     algo_name       Name of field in algorithm
!     init_name       Name of field for initial state (ETAT_INIT)
!     init_type       State of field during initialization
!                       ZERO: field for zero field (given by init_name)
!                       RESU: field from result datastructure
!                       READ: field from ETAT_INIT field by field
    type NL_DS_Field
        character(len=16) :: type           
        character(len=8)  :: gran_name
        character(len=8)  :: field_read
        character(len=4)  :: disc_type
        character(len=8)  :: init_keyw
        character(len=16) :: obsv_keyw
        aster_logical     :: l_read_init
        aster_logical     :: l_store
        aster_logical     :: l_obsv
        character(len=24) :: algo_name
        character(len=24) :: init_name
        character(len=4)  :: init_type                                                              
    end type NL_DS_Field
!
! - Type: input/output management
! 
    type NL_DS_InOut
        character(len=8)  :: result
        aster_logical     :: l_temp_nonl
        integer           :: nb_field
        integer           :: nb_field_maxi = 19
        type(NL_DS_Field) :: field(19)
        character(len=8)  :: stin_evol
        aster_logical     :: l_stin_evol
        aster_logical     :: l_field_acti(19)
        aster_logical     :: l_field_read(19)
        aster_logical     :: l_state_init
        aster_logical     :: l_reuse
        integer           :: didi_nume
        character(len=8)  :: criterion
        real(kind=8)      :: precision
        real(kind=8)      :: user_time
        aster_logical     :: l_user_time
        integer           :: user_nume
        aster_logical     :: l_user_nume
        real(kind=8)      :: stin_time
        aster_logical     :: l_stin_time
        real(kind=8)      :: init_time
        integer           :: init_nume
        character(len=19) :: list_load_resu
        aster_logical     :: l_init_stat
        aster_logical     :: l_init_vale
        real(kind=8)      :: temp_init
! ----- Table of parameters in output datastructure
        type(NL_DS_TableIO) :: table_io
    end type NL_DS_InOut
!
! - Type: loop management
! 
    type NL_DS_Loop
        character(len=4)  :: type
        integer           :: counter
        aster_logical     :: conv
        aster_logical     :: error
        real(kind=8)      :: vale_calc
        character(len=16) :: locus_calc
    end type NL_DS_Loop
!
! - Type: contact management
! 
    type NL_DS_Contact
        aster_logical     :: l_contact
        aster_logical     :: l_meca_cont
        aster_logical     :: l_meca_unil
        character(len=8)  :: sdcont
        character(len=24) :: sdcont_defi
        character(len=24) :: sdcont_solv
        character(len=24) :: sdunil_defi
        character(len=24) :: sdunil_solv
        aster_logical     :: l_form_cont
        aster_logical     :: l_form_disc
        aster_logical     :: l_form_xfem
        aster_logical     :: l_form_lac
! ----- Name of <LIGREL> for slave elements (create in DEFI_CONTACT)
        character(len=8)  :: ligrel_elem_slav
        aster_logical     :: l_elem_slav
! ----- Name of <LIGREL> for contact elements (create in MECA_NON_LINE)
        character(len=19) :: ligrel_elem_cont
        aster_logical     :: l_elem_cont
! ----- Identity relations between dof (XFEM with ELIM_ARETE or LAC method)
        aster_logical     :: l_iden_rela
        character(len=24) :: iden_rela
! ----- Relations between dof (QUAD8 in discrete methods or XFEM, create in DEFI_CONTACT)
        aster_logical     :: l_dof_rela
        character(len=8)  :: ligrel_dof_rela
! ----- Name of <CHELEM> - Input field
        character(len=19) :: field_input
! ----- NUME_DOF for discrete friction methods 
        character(len=14) :: nume_dof_frot
! ----- Fields for CONT_NODE 
        character(len=19) :: field_cont_node
        character(len=19) :: fields_cont_node
        character(len=19) :: field_cont_perc
! ----- Fields for CONT_ELEM 
        character(len=19) :: field_cont_elem
        character(len=19) :: fields_cont_elem
! ----- Loops
        integer           :: nb_loop
        integer           :: nb_loop_maxi = 3
        integer           :: iteration_newton = 0
        integer           :: it_cycl_maxi = 0
        integer           :: it_adapt_maxi = 0
        type(NL_DS_Loop)  :: loop(3)
! ----- Flag for (re) numbering
        aster_logical     :: l_renumber
! ----- Geometric loop control
        real(kind=8)      :: geom_maxi
        real(kind=8)      :: arete_min
        real(kind=8)      :: arete_max=0.0
! ----- Get-off indicator
        aster_logical     :: l_getoff
! ----- First geometric loop
        aster_logical     :: l_first_geom
! ----- Flag for pairing
        aster_logical     :: l_pair
! ----- Total number of patches (for LAC method)
        integer           :: nt_patch
! ----- Total number of contact pairs
        integer           :: nb_cont_pair
! ----- Automatic update of penalised coefficient
        real(kind=8)      :: estimated_coefficient = 100.0
        real(kind=8)      :: max_coefficient = 100.0
        real(kind=8)      :: update_init_coefficient = 0.0
        real(kind=8)      :: calculated_penetration  = 1.0
        real(kind=8)      :: critere_penetration  = 0.0
        real(kind=8)      :: continue_pene  = 0.0
        real(kind=8)      :: time_curr  = -1.0

    end type NL_DS_Contact
!
! - Type: timer management
! 
    type NL_DS_Timer
! ----- Type of timer
        character(len=9)  :: type
! ----- Internal name of timer
        character(len=24) :: cpu_name
! ----- Initial time
        real(kind=8)      :: time_init
    end type NL_DS_Timer
!
! - Type: device for measure
! 
    type NL_DS_Device
! ----- Type of device
        character(len=10) :: type
! ----- Name of timer
        character(len=9)  :: timer_name
! ----- Times: for Newton iteration, time step and complete computation
        real(kind=8)      :: time_iter
        real(kind=8)      :: time_step
        real(kind=8)      :: time_comp
        integer           :: time_indi_step
        integer           :: time_indi_comp
! ----- Counters: for Newton iteration, time step and complete computation
        aster_logical     :: l_count_add
        integer           :: count_iter
        integer           :: count_step
        integer           :: count_comp
        integer           :: count_indi_step
        integer           :: count_indi_comp
    end type NL_DS_Device
!
! - Type: measure and statistics management
! 
    type NL_DS_Measure
! ----- Output in table
        aster_logical      :: l_table
! ----- Table in results datastructures
        type(NL_DS_Table)  :: table
        integer            :: indx_cols(2*23)
! ----- List of timers
        integer            :: nb_timer
        integer            :: nb_timer_maxi = 7
        type(NL_DS_Timer)  :: timer(7)
! ----- List of devices
        integer            :: nb_device
        integer            :: nb_device_maxi = 23
        type(NL_DS_Device) :: device(23)
        integer            :: nb_device_acti
        aster_logical      :: l_device_acti(23)
! ----- Some special times
        real(kind=8)       :: store_mean_time
        real(kind=8)       :: iter_mean_time
        real(kind=8)       :: step_mean_time
        real(kind=8)       :: iter_remain_time
        real(kind=8)       :: step_remain_time
    end type NL_DS_Measure
!
! - Type: energy management
! 
    type NL_DS_Energy
! ----- Flag for energy computation
        aster_logical         :: l_comp
! ----- Command (MECA_NON_LINE or DYNA_VIBRA)
        character(len=16)     :: command
! ----- Table in results datastructures
        type(NL_DS_Table)     :: table
    end type NL_DS_Energy
!
! - Type: constitutive laws management
! 
    type NL_DS_Constitutive
! ----- Name of field for constitutive laws
        character(len=24)     :: compor
! ----- Name of field for criteria of constitutive laws
        character(len=24)     :: carcri
! ----- Name of field for constitutive laws - Special crystal
        character(len=24)     :: mult_comp
! ----- Name of field for error field from constitutive laws
        character(len=24)     :: comp_error
! ----- Flag for De Borst algorithm
        aster_logical         :: l_deborst
! ----- Flag for DIS_CHOC
        aster_logical         :: l_dis_choc
! ----- Flag for POST_INCR
        aster_logical         :: l_post_incr
! ----- Flag for large strains in tangent matrix
        aster_logical         :: l_matr_geom
    end type NL_DS_Constitutive
!
! - Type: selection list
! 
    type NL_DS_SelectList
! ----- List of values
        integer               :: nb_value   = 0
        real(kind=8)          :: incr_mini  = 0.d0
        real(kind=8), pointer :: list_value(:) => null()
! ----- Parameters to detect real in list
        real(kind=8)          :: precision  = 0.d0
        aster_logical         :: l_abso     = ASTER_FALSE
        real(kind=8)          :: tolerance  = 0.d0
        integer               :: freq_step  = 0
! ----- Type of selection
        aster_logical         :: l_by_freq  = ASTER_FALSE
    end type NL_DS_SelectList
!
! - Type: spectral analysis for stability
! 
    type NL_DS_Stability
! ----- Use geometric matrix (only CRIT_STAB)
        aster_logical             :: l_geom_matr
! ----- Use modified rigidity matrix (only CRIT_STAB)
        aster_logical             :: l_modi_rigi
! ----- Excluded DOF (only CRIT_STAB)
        integer                   :: nb_dof_excl
        character(len=8), pointer :: list_dof_excl(:) => null()
! ----- Stabilized DOF (only CRIT_STAB)
        integer                   :: nb_dof_stab
        character(len=8), pointer :: list_dof_stab(:) => null()
! ----- Instability parameters
        character(len=16)         :: instab_sign
        real(kind=8)              :: instab_prec
! ----- Previous frequency
        real(kind=8)              :: prev_freq = 1.d50
    end type NL_DS_Stability
!
! - Type: spectral analysis
! 
    type NL_DS_Spectral
! ----- Name of option to compute
        character(len=16)      :: option
! ----- Type of rigidity matrix
        character(len=16)      :: type_matr_rigi
! ----- Type of eigenvalues research
        aster_logical          :: l_small
        aster_logical          :: l_strip
! ----- Bounds of strip (STRIP option)
        real(kind=8)           :: strip_bounds(2)
! ----- Number of eigenvalues to search (SMALL option)
        integer                :: nb_eigen
! ----- Parameter for eigen solver
        integer                :: coef_dim_espace
! ----- Selector (when spectral analysis occurs)
        type(NL_DS_SelectList) :: selector
! ----- Level of computation (number of eigenvalues or eigenvalue+eigenvector)
        character(len=16)      :: level
    end type NL_DS_Spectral
!
! - Type: post_treatment at each time step
! 
    type NL_DS_PostTimeStep
! ----- Table in output datastructure
        type(NL_DS_TableIO)   :: table_io
! ----- Compute CRIT_STAB / MODE_VIBR
        aster_logical         :: l_crit_stab
        aster_logical         :: l_mode_vibr
! ----- Spectral analyses
        type(NL_DS_Spectral)  :: crit_stab
        type(NL_DS_Spectral)  :: mode_vibr
        type(NL_DS_Stability) :: stab_para
! ----- Small strain hypothese for geometry matrix
        aster_logical         :: l_hpp
    end type NL_DS_PostTimeStep
!
! - Type: material properties
! 
    type NL_DS_Material
! ----- Field of material parameters
        character(len=24) :: field_mate
! ----- Field for reference of external state variables
        character(len=24) :: varc_refe


    end type NL_DS_Material
!
end module
