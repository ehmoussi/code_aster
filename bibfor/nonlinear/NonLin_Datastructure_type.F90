! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
! aslint: disable=W1303, W1501
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
        character(len=16)  :: name        = ' '
        character(len=16)  :: title(3)    = ' '
        character(len=1)   :: mark        = ' '
        aster_logical      :: l_vale_affe = ASTER_FALSE
        aster_logical      :: l_vale_inte = ASTER_FALSE
        aster_logical      :: l_vale_real = ASTER_FALSE
        aster_logical      :: l_vale_cplx = ASTER_FALSE
        aster_logical      :: l_vale_strg = ASTER_FALSE
        integer            :: vale_inte   = 0
        real(kind=8)       :: vale_real   = 0.d0
        complex(kind=8)    :: vale_cplx   = (0.d0,0.d0)
        character(len=16)  :: vale_strg   = ' '
    end type NL_DS_Column
!
! - Type: table in output datastructure
!
    type NL_DS_TableIO
! ----- Name of result datastructure
        character(len=8)           :: resultName   = ' '
! ----- Parameters for table in output Datastructure
        character(len=24)          :: tablName     = ' '
        character(len=16)          :: tablSymbName = ' '
! ----- List of parameters
        integer                    :: nbPara       = 0
        integer                    :: nbParaInte   = 0
        integer                    :: nbParaReal   = 0
        integer                    :: nbParaCplx   = 0
        integer                    :: nbParaStrg   = 0
        character(len=24), pointer :: paraName(:)  => null()
        character(len=8), pointer  :: paraType(:)  => null()
    end type NL_DS_TableIO
!
! - Type: table
!
    type NL_DS_Table
! ----- Number of active columns
        integer                :: nb_cols         = 0
! ----- Maximum number of columns in table
        integer                :: nb_cols_maxi    = 40
! ----- List of columns in table
        type(NL_DS_Column)     :: cols(40)
! ----- List of _active_ columns in table
        aster_logical          :: l_cols_acti(40) = ASTER_FALSE
! ----- Total width of table
        integer                :: width           = 0
! ----- Number of lines for title
        integer                :: title_height    = 0
! ----- Separation line
        character(len=512)     :: sep_line        = ' '
! ----- Flag for outside file (CSV)
        aster_logical          :: l_csv           = ASTER_FALSE
! ----- Logical unit for outside file (CSV)
        integer                :: unit_csv        = 0
! ----- Table in output datastructure
        type(NL_DS_TableIO)    :: table_io
! ----- Index to values
        integer                :: indx_vale(40)   = 0
    end type NL_DS_Table
!
! - Type: print
!
    type NL_DS_Print
        aster_logical :: l_print        = ASTER_FALSE
        type(NL_DS_Table) :: table_cvg
        aster_logical :: l_info_resi    = ASTER_FALSE
        aster_logical :: l_info_time    = ASTER_FALSE
        aster_logical :: l_tcvg_csv     = ASTER_FALSE
        integer :: tcvg_unit            = 0
        integer :: reac_print           = 0
        real(kind=8) :: resi_pressure   = 0.d0
        character(len=512) :: sep_line  = ' '
    end type NL_DS_Print
!
! - Type: residuals
!
    type NL_DS_Resi
        character(len=16) :: type           = ' '
        character(len=24) :: col_name       = ' '
        character(len=24) :: col_name_locus = ' '
        character(len=16) :: event_type     = ' '
        real(kind=8)      :: vale_calc      = 0.d0
        character(len=16) :: locus_calc     = ' '
        real(kind=8)      :: user_para      = 0.d0
        aster_logical     :: l_conv         = ASTER_FALSE
    end type NL_DS_Resi
!
! - Type: reference residuals
!
    type NL_DS_RefeResi
        character(len=16) :: type      = ' '
        real(kind=8)      :: user_para = 0.d0
        character(len=8)  :: cmp_name  = ' '
    end type NL_DS_RefeResi
!
! - Type: convergence management
!
    type NL_DS_Conv
        integer :: nb_resi                      = 0
        integer :: nb_resi_maxi                 = 7
        type(NL_DS_Resi)     :: list_resi(7)
        aster_logical        :: l_resi_test(7)  = ASTER_FALSE
        integer :: nb_refe                      = 0
        integer :: nb_refe_maxi                 = 11
        type(NL_DS_RefeResi) :: list_refe(11)
        aster_logical        :: l_refe_test(11) = ASTER_FALSE
        integer :: iter_glob_maxi               = 0
        integer :: iter_glob_elas               = 0
        aster_logical :: l_stop                 = ASTER_FALSE
        aster_logical :: l_stop_pene            = ASTER_FALSE
        real(kind=8)  :: swap_trig              = 0.d0
        real(kind=8)  :: line_sear_coef         = 0.d0
        integer       :: line_sear_iter         = 0
    end type NL_DS_Conv
!
! - Type: Line search parameters
!
    type NL_DS_LineSearch
        character(len=16) :: method     = ' '
        real(kind=8)      :: resi_rela  = 0.d0
        integer           :: iter_maxi  = 0
        real(kind=8)      :: rho_mini   = 0.d0
        real(kind=8)      :: rho_maxi   = 0.d0
        real(kind=8)      :: rho_excl   = 0.d0
    end type NL_DS_LineSearch
!
! - Type: algorithm parameters
!
    type NL_DS_AlgoPara
        character(len=16)      :: method           = ' '
        character(len=16)      :: matrix_pred      = ' '
        character(len=16)      :: matrix_corr      = ' '
        integer                :: reac_incr        = 0
        integer                :: reac_iter        = 0
        real(kind=8)           :: pas_mini_elas    = 0.d0
        integer                :: reac_iter_elas   = 0
        aster_logical          :: l_line_search    = ASTER_FALSE
        type(NL_DS_LineSearch) :: line_search
        aster_logical          :: l_pilotage       = ASTER_FALSE
        aster_logical          :: l_dyna           = ASTER_FALSE
        character(len=8)       :: result_prev_disp = ' '
        aster_logical          :: l_matr_rigi_syme = ASTER_FALSE
        aster_logical          :: l_precalc_hho    = ASTER_FALSE
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
        character(len=16) :: type        = ' '
        character(len=8)  :: gran_name   = ' '
        character(len=8)  :: field_read  = ' '
        character(len=4)  :: disc_type   = ' '
        character(len=8)  :: init_keyw   = ' '
        character(len=16) :: obsv_keyw   = ' '
        aster_logical     :: l_read_init = ASTER_FALSE
        aster_logical     :: l_store     = ASTER_FALSE
        aster_logical     :: l_obsv      = ASTER_FALSE
        character(len=24) :: algo_name   = ' '

        character(len=24) :: init_name   = ' '
        character(len=4)  :: init_type   = ' '
    end type NL_DS_Field
!
! - Type: input/output management
!
    type NL_DS_InOut
        character(len=8)  :: result           = ' '
        aster_logical     :: l_temp_nonl      = ASTER_FALSE
        integer           :: nb_field         = 0
        integer           :: nb_field_maxi    = 21
        type(NL_DS_Field) :: field(21)
        character(len=8)  :: stin_evol        = ' '
        aster_logical     :: l_stin_evol      = ASTER_FALSE
        aster_logical     :: l_field_acti(21) = ASTER_FALSE
        aster_logical     :: l_field_read(21) = ASTER_FALSE
        aster_logical     :: l_state_init     = ASTER_FALSE
        aster_logical     :: l_reuse          = ASTER_FALSE
        integer           :: didi_nume        = 0
        character(len=8)  :: criterion        = ' '
        real(kind=8)      :: precision        = 0.d0
        real(kind=8)      :: user_time        = 0.d0
        aster_logical     :: l_user_time      = ASTER_FALSE
        integer           :: user_nume        = 0
        aster_logical     :: l_user_nume      = ASTER_FALSE
        real(kind=8)      :: stin_time        = 0.d0
        aster_logical     :: l_stin_time      = ASTER_FALSE
        real(kind=8)      :: init_time        = 0.d0
        integer           :: init_nume        = 0
        character(len=19) :: list_load_resu   = ' '
        aster_logical     :: l_init_stat      = ASTER_FALSE
        aster_logical     :: l_init_vale      = ASTER_FALSE
        real(kind=8)      :: temp_init        = 0.d0
! ----- Table of parameters in output datastructure
        type(NL_DS_TableIO) :: table_io
    end type NL_DS_InOut
!
! - Type: loop management
!
    type NL_DS_Loop
        character(len=4)  :: type       = ' '
        integer           :: counter    = 0
        aster_logical     :: conv       = ASTER_FALSE
        aster_logical     :: error      = ASTER_FALSE
        real(kind=8)      :: vale_calc  = 0.d0
        character(len=16) :: locus_calc = ' '
    end type NL_DS_Loop
!
! - Type: contact management
!
    type NL_DS_Contact
! ----- Flag for contact (CONTACT keyword is present)
        aster_logical     :: l_contact               = ASTER_FALSE
! ----- Flag for contact XFEM/CONTINUE/DISCRET
        aster_logical     :: l_meca_cont             = ASTER_FALSE
! ----- Flag for contact LIAISON_UNIL
        aster_logical     :: l_meca_unil             = ASTER_FALSE
! ----- Flag for contact CONTINUE
        aster_logical     :: l_form_cont             = ASTER_FALSE
! ----- Flag for contact DISCRET
        aster_logical     :: l_form_disc             = ASTER_FALSE
! ----- Flag for contact XFEM
        aster_logical     :: l_form_xfem             = ASTER_FALSE
! ----- Flag for contact LAC
        aster_logical     :: l_form_lac              = ASTER_FALSE
! ----- Flag if create CONT_NOEU
        aster_logical     :: l_cont_node             = ASTER_FALSE
! ----- Flag if create CONT_ELEM
        aster_logical     :: l_cont_elem             = ASTER_FALSE
! ----- Flag for THM in contact
        aster_logical     :: l_cont_thm              = ASTER_FALSE
        character(len=8)  :: sdcont                  = ' '
        character(len=24) :: sdcont_defi             = ' '
        character(len=24) :: sdcont_solv             = ' '
        character(len=24) :: sdunil_defi             = ' '
        character(len=24) :: sdunil_solv             = ' '
! ----- Name of <LIGREL> for slave elements (create in DEFI_CONTACT)
        character(len=8)  :: ligrel_elem_slav        = ' '
        aster_logical     :: l_elem_slav             = ASTER_FALSE
! ----- Name of <LIGREL> for contact elements (create in MECA_NON_LINE)
        character(len=19) :: ligrel_elem_cont        = ' '
        aster_logical     :: l_elem_cont             = ASTER_FALSE
! ----- Identity relations between dof (XFEM with ELIM_ARETE or LAC method)
        aster_logical     :: l_iden_rela             = ASTER_FALSE
        character(len=24) :: iden_rela               = ' '
! ----- Relations between dof (QUAD8 in discrete methods or XFEM, create in DEFI_CONTACT)
        aster_logical     :: l_dof_rela              = ASTER_FALSE
        character(len=8)  :: ligrel_dof_rela         = ' '
! ----- Name of <CHELEM> - Input field
        character(len=19) :: field_input             = ' '
! ----- NUME_DOF for discrete friction methods
        character(len=14) :: nume_dof_frot           = ' '
! ----- NUME_DOF for unil methods
        character(len=14) :: nume_dof_unil           = ' '
! ----- Fields for CONT_NODE
        character(len=19) :: field_cont_node         = ' '
        character(len=19) :: fields_cont_node        = ' '
        character(len=19) :: field_cont_perc         = ' '
! ----- Fields for CONT_ELEM
        character(len=19) :: field_cont_elem         = ' '
        character(len=19) :: fields_cont_elem        = ' '
! ----- Loops
        integer           :: nb_loop                 = 0
        integer           :: nb_loop_maxi            = 3
        integer           :: iteration_newton        = 0
        integer           :: it_cycl_maxi            = 0
        integer           :: it_adapt_maxi           = 0
        type(NL_DS_Loop)  :: loop(3)
! ----- Flag for (re) numbering
        aster_logical     :: l_renumber              = ASTER_FALSE
! ----- Geometric loop control
        real(kind=8)      :: geom_maxi               = 0.d0
        real(kind=8)      :: arete_min               = 0.d0
        real(kind=8)      :: arete_max               = 0.d0
        real(kind=8)      :: cont_pressure           = 0.d0
        real(kind=8)      :: resi_pressure           = 1.d3
        real(kind=8)      :: resi_press_glob         = 1.d3
! ----- Get-off indicator
        aster_logical     :: l_getoff                = ASTER_FALSE
! ----- First geometric loop
        aster_logical     :: l_first_geom            = ASTER_FALSE
! ----- Flag for pairing
        aster_logical     :: l_pair                  = ASTER_FALSE
! ----- Total number of patches (for LAC method)
        integer           :: nt_patch                = 0
! ----- Total number of contact pairs
        integer           :: nb_cont_pair            = 0
! ----- Number of stored values from precedent Newton iteration
        integer           :: n_cychis                = 75
        integer           :: cycl_long_acti          = 3
! ----- Automatic update of penalised coefficient
        real(kind=8)      :: estimated_coefficient   = 100.d0
        real(kind=8)      :: max_coefficient         = 100.d0
        real(kind=8)      :: update_init_coefficient = 0.d0
        real(kind=8)      :: calculated_penetration  = 1.d0
        real(kind=8)      :: critere_penetration     = 0.d0
        real(kind=8)      :: continue_pene           = 0.d0
        real(kind=8)      :: time_curr               = -1.d0
! ----- Automatic update of resi_geom
        real(kind=8)      :: critere_geom            = 0.d0
        character(len=16) :: crit_geom_noeu          = ' '
        integer           :: flag_mast_nume          = 1
! ----- Force for DISCRETE contact (friction)
        aster_logical     :: l_cnctdf                = ASTER_FALSE
        character(len=19) :: cnctdf                  = ' '
! ----- Force for DISCRETE contact (contact)
        aster_logical     :: l_cnctdc                = ASTER_FALSE
        character(len=19) :: cnctdc                  = ' '
! ----- Force for DISCRETE contact (LIAISON_UNIL)
        aster_logical     :: l_cnunil                = ASTER_FALSE
        character(len=19) :: cnunil                  = ' '
! ----- Force for CONTINUE contact (contact)
        aster_logical     :: l_cneltc                = ASTER_FALSE
        character(len=19) :: cneltc                  = ' '
        character(len=19) :: veeltc                  = ' '
! ----- Force for CONTINUE contact (friction)
        aster_logical     :: l_cneltf                = ASTER_FALSE
        character(len=19) :: cneltf                  = ' '
        character(len=19) :: veeltf                  = ' '
    end type NL_DS_Contact
!
! - Type: timer management
!
    type NL_DS_Timer
! ----- Type of timer
        character(len=9)  :: type      = ' '
! ----- Internal name of timer
        character(len=24) :: cpu_name  = ' '
! ----- Initial time
        real(kind=8)      :: time_init = 0.d0
    end type NL_DS_Timer
!
! - Type: device for measure
!
    type NL_DS_Device
! ----- Type of device
        character(len=10) :: type            = ' '
! ----- Name of timer
        character(len=9)  :: timer_name      = ' '
! ----- Times: for Newton iteration, time step and complete computation
        real(kind=8)      :: time_iter       = 0.d0
        real(kind=8)      :: time_step       = 0.d0
        real(kind=8)      :: time_comp       = 0.d0
        integer           :: time_indi_step  = 0
        integer           :: time_indi_comp  = 0
! ----- Counters: for Newton iteration, time step and complete computation
        aster_logical     :: l_count_add     = ASTER_FALSE
        integer           :: count_iter      = 0
        integer           :: count_step      = 0
        integer           :: count_comp      = 0
        integer           :: count_indi_step = 0
        integer           :: count_indi_comp = 0
    end type NL_DS_Device
!
! - Type: measure and statistics management
!
    type NL_DS_Measure
! ----- Output in table
        aster_logical      :: l_table           = ASTER_FALSE
! ----- Table in results datastructures
        type(NL_DS_Table)  :: table
        integer            :: indx_cols(2*26)   = 0
! ----- List of timers
        integer            :: nb_timer          = 0
        integer            :: nb_timer_maxi     = 8
        type(NL_DS_Timer)  :: timer(8)
! ----- List of devices
        integer            :: nb_device         = 0
        integer            :: nb_device_maxi    = 26
        type(NL_DS_Device) :: device(26)
        integer            :: nb_device_acti    = 0
        aster_logical      :: l_device_acti(26) = ASTER_FALSE
! ----- Some special times
        real(kind=8)       :: store_mean_time   = 0.d0
        real(kind=8)       :: iter_mean_time    = 0.d0
        real(kind=8)       :: step_mean_time    = 0.d0
        real(kind=8)       :: iter_remain_time  = 0.d0
        real(kind=8)       :: step_remain_time  = 0.d0
    end type NL_DS_Measure
!
! - Type: energy management
!
    type NL_DS_Energy
! ----- Flag for energy computation
        aster_logical         :: l_comp  = ASTER_FALSE
! ----- Command (MECA_NON_LINE or DYNA_VIBRA)
        character(len=16)     :: command = ' '
! ----- Table in results datastructures
        type(NL_DS_Table)     :: table
    end type NL_DS_Energy
!
! - Type: for external comportement
!
    type NL_DS_ComporExte
! ----- Flag for UMAT law
        aster_logical      :: l_umat         = ASTER_FALSE
! ----- Flag for non-official MFront law
        aster_logical      :: l_mfront_proto = ASTER_FALSE
! ----- Flag for official MFront law
        aster_logical      :: l_mfront_offi  = ASTER_FALSE
! ----- Name of subroutine for external law
        character(len=255) :: subr_name      = ' '
! ----- Name of library for external law
        character(len=255) :: libr_name      = ' '
! ----- Model for MFront law
        character(len=16)  :: model_mfront   = ' '
! ----- Number of dimension for MFront law
        integer            :: model_dim      = 0
! ----- Number of internal variables for UMAT
        integer            :: nb_vari_umat   = 0
! ----- Identifier for strains model
        integer            :: strain_model   = 0
    end type NL_DS_ComporExte
!
! - Type: for comportement
!
    type NL_DS_Compor
        character(len=16) :: rela_comp       = ' '
        character(len=16) :: defo_comp       = ' '
        character(len=16) :: type_comp       = ' '
        character(len=16) :: type_cpla       = ' '
        character(len=16) :: kit_comp(4)     = ' '
        character(len=16) :: mult_comp       = ' '
        character(len=16) :: post_iter       = ' '
        character(len=16) :: defo_ldc        = ' '
        character(len=16) :: rigi_geom       = ' '
        integer           :: nb_vari         = 0
        integer           :: nb_vari_comp(4) = 0
        integer           :: nume_comp(4)    = 0
    end type NL_DS_Compor
!
! - Type: for preparation of comportment
!
    type NL_DS_ComporPrep
! ----- Number of comportements
        integer                         :: nb_comp   = 0
! ----- List of comportements
        type(NL_DS_Compor), pointer     :: v_comp(:) => null()
! ----- List of external comportements
        type(NL_DS_ComporExte), pointer :: v_exte(:) => null()
! ----- Flag for IMPLEX method
        aster_logical                   :: l_implex  = ASTER_FALSE
    end type NL_DS_ComporPrep
!
! - Type: for parameters for constitutive laws
!
    type NL_DS_ComporPara
        aster_logical :: l_comp_external          = ASTER_FALSE
        integer       :: type_matr_t              = 0
        real(kind=8)  :: parm_theta               = 0.d0
        integer       :: iter_inte_pas            = 0
        real(kind=8)  :: vale_pert_rela           = 0.d0
        real(kind=8)  :: resi_deborst_max         = 0.d0
        integer       :: iter_deborst_max         = 0
        real(kind=8)  :: resi_radi_rela           = 0.d0
        integer       :: ipostiter                = 0
        integer       :: ipostincr                = 0
        integer       :: iveriborne               = 0
        aster_logical :: l_matr_unsymm            = ASTER_FALSE
        character(len=16)         :: rela_comp    = ' '
        character(len=16)         :: meca_comp    = ' '
        character(len=16)         :: defo_comp    = ' '
        character(len=16)         :: kit_comp(4)  = ' '
        type(NL_DS_ComporExte)    :: comp_exte
    end type NL_DS_ComporPara
!
! - Type: for preparation of parameters for constitutive laws
!
    type NL_DS_ComporParaPrep
! ----- Number of comportements
        integer                         :: nb_comp        = 0
! ----- Parameters for THM scheme
        real(kind=8)                    :: parm_alpha_thm = 0.d0
        real(kind=8)                    :: parm_theta_thm = 0.d0
! ----- List of parameters
        type(NL_DS_ComporPara), pointer :: v_para(:)      => null()
    end type NL_DS_ComporParaPrep
!
! - Type: constitutive laws management
!
    type NL_DS_Constitutive
! ----- Name of field for constitutive laws
        character(len=24)     :: compor      = '&&OP00XX.COMPOR'
! ----- Name of field for criteria of constitutive laws
        character(len=24)     :: carcri      = '&&OP00XX.CARCRI'
! ----- Name of field for constitutive laws - Special crystal
        character(len=24)     :: mult_comp   = '&&OP00XX.MULT_COMP'
! ----- Name of field for error field from constitutive laws
        character(len=24)     :: comp_error  = '&&OP00XX.COMP_ERROR'
! ----- Name of field for coefficient in prediction
        character(len=24)     :: code_pred   = '&&OP00XX.CODE_PRED'
! ----- Name of field for stress at prediction
        character(len=24)     :: sigm_pred   = '&&OP00XX.SIGM_PRED'
! ----- Flag for De Borst algorithm
        aster_logical         :: l_deborst   = ASTER_FALSE
! ----- Flag for DIS_CHOC
        aster_logical         :: l_dis_choc  = ASTER_FALSE
! ----- Flag for POST_INCR
        aster_logical         :: l_post_incr = ASTER_FALSE
! ----- Flag for if large strains are in tangent matrix
        aster_logical         :: l_matr_geom = ASTER_FALSE
! ----- Flag for if everything is linear in behaviour
        aster_logical         :: lLinear     = ASTER_FALSE
! ----- Flag for if everything is only DIS_CHOC/DIS_CONTACT in behaviour
        aster_logical         :: lDisCtc     = ASTER_FALSE
    end type NL_DS_Constitutive
!
! - Type: selection list
!
    type NL_DS_SelectList
! ----- List of values
        integer               :: nb_value      = 0
        real(kind=8)          :: incr_mini     = 0.d0
        real(kind=8), pointer :: list_value(:) => null()
! ----- Parameters to detect real in list
        real(kind=8)          :: precision     = 0.d0
        aster_logical         :: l_abso        = ASTER_FALSE
        real(kind=8)          :: tolerance     = 0.d0
        integer               :: freq_step     = 0
! ----- Type of selection
        aster_logical         :: l_by_freq     = ASTER_FALSE
    end type NL_DS_SelectList
!
! - Type: spectral analysis for stability
!
    type NL_DS_Stability
! ----- Use geometric matrix (only CRIT_STAB)
        aster_logical             :: l_geom_matr      = ASTER_FALSE
! ----- Use modified rigidity matrix (only CRIT_STAB)
        aster_logical             :: l_modi_rigi      = ASTER_FALSE
! ----- Excluded DOF (only CRIT_STAB)
        integer                   :: nb_dof_excl      = 0
        character(len=8), pointer :: list_dof_excl(:) => null()
! ----- Stabilized DOF (only CRIT_STAB)
        integer                   :: nb_dof_stab      = 0
        character(len=8), pointer :: list_dof_stab(:) => null()
! ----- Instability parameters
        character(len=16)         :: instab_sign      = ' '
        real(kind=8)              :: instab_prec      = 0.d0
! ----- Previous frequency
        real(kind=8)              :: prev_freq        = 1.d50
    end type NL_DS_Stability
!
! - Type: spectral analysis
!
    type NL_DS_Spectral
! ----- Name of option to compute
        character(len=16)      :: option          = ' '
! ----- Type of rigidity matrix
        character(len=16)      :: type_matr_rigi  = ' '
! ----- Type of eigenvalues research
        aster_logical          :: l_small         = ASTER_FALSE
        aster_logical          :: l_strip         = ASTER_FALSE
! ----- Bounds of strip (STRIP option)
        real(kind=8)           :: strip_bounds(2) = 0.d0
! ----- Number of eigenvalues to search (SMALL option)
        integer                :: nb_eigen        = 0
! ----- Parameter for eigen solver
        integer                :: coef_dim_espace = 0
! ----- Selector (when spectral analysis occurs)
        type(NL_DS_SelectList) :: selector
! ----- Level of computation (number of eigenvalues or eigenvalue+eigenvector)
        character(len=16)      :: level           = ' '
    end type NL_DS_Spectral
!
! - Type: post_treatment at each time step
!
    type NL_DS_PostTimeStep
! ----- Table in output datastructure
        type(NL_DS_TableIO)   :: table_io
! ----- Compute CRIT_STAB / MODE_VIBR
        aster_logical         :: l_crit_stab = ASTER_FALSE
        aster_logical         :: l_mode_vibr = ASTER_FALSE
! ----- Spectral analyses
        type(NL_DS_Spectral)  :: crit_stab
        type(NL_DS_Spectral)  :: mode_vibr
        type(NL_DS_Stability) :: stab_para
! ----- Small strain hypothese for geometry matrix
        aster_logical         :: l_hpp       = ASTER_FALSE
    end type NL_DS_PostTimeStep
!
! - Type: material properties
!
    type NL_DS_Material
! ----- Material
        character(len=24) :: mater      = ' '
! ----- Field of material parameters (coded material)
        character(len=24) :: mateco     = ' '
! ----- Field for reference of external state variables
        character(len=24) :: varc_refe  = ' '
! ----- Field for initial value of external state variables
        character(len=24) :: varc_init  = ' '
! ----- Force for initial value of external state variables
        character(len=24) :: fvarc_init = ' '
! ----- Force from external state variables for predictor
        character(len=24) :: fvarc_pred = ' '
! ----- Force from external state variables for convergence criteria
        character(len=24) :: fvarc_curr = ' '
    end type NL_DS_Material
!
! - Type: combine vectors
!
    type NL_DS_VectComb
        integer            :: nb_vect       = 0
        real(kind=8)       :: vect_coef(20) = 0.d0
        character(len=19)  :: vect_name(20) = ' '
    end type NL_DS_VectComb
!
! - Type: non-linear system
!
    type NL_DS_System
! ----- Name of numbering (for assembling)
        character(len=24)     :: nume_dof    = 'Unknown'
! ----- Name of field for multiplicator for full prediction
        character(len=24)     :: code_pred   = '&&OP00XX.CODE_PRED'
! ----- Elementary and assembled vector for nodal force (no integration)
        character(len=19)     :: vefnod      = '&&OP00XX.VEFNOD'
        character(len=19)     :: cnfnod      = '&&OP00XX.CNFNOD'
! ----- Elementary and assembled vector for internal force (integration)
        character(len=19)     :: veinte      = '&&OP00XX.VEINTE'
        character(len=19)     :: cninte      = '&&OP00XX.CNINTE'
! ----- Internal forces
        character(len=19)     :: cnfint      = '&&OP00XX.CNFINT'
! ----- Internal forces for RESI_COMP_RELA
        character(len=19)     :: cncomp      = '&&OP00XX.CNCOMP'
! ----- Elementary rigidity matrix
        character(len=19)     :: merigi      = '&&OP00XX.MERIGI'
! ----- Flag for symmetric rigidity matrix
        aster_logical         :: l_rigi_syme = ASTER_FALSE
! ----- Flag for contact matrix to add in rigidity matrix (CONTINUE/XFEM)
        aster_logical         :: l_rigi_cont = ASTER_FALSE
! ----- Flag for modifiy matrix because of contact (LAC/DISCRETE/LIAISON_UNIL)
        aster_logical         :: l_matr_cont = ASTER_FALSE
    end type NL_DS_System
!
! - Type: error indicators' management
!
    type NL_DS_ErrorIndic
! ----- THM error (S. Meunier)
        aster_logical :: l_erre_thm   = ASTER_FALSE
        real(kind=8) :: erre_thm_loca = 0.d0
        real(kind=8) :: erre_thm_glob = 0.d0
        real(kind=8) :: parm_theta    = 0.d0
! ----- Nondimensionalization
        real(kind=8) :: adim_p        = 0.d0
        real(kind=8) :: adim_l        = 0.d0
    end type NL_DS_ErrorIndic
!
end module
