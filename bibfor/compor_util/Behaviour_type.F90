! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
module Behaviour_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/Behaviour_type.h"
!
! --------------------------------------------------------------------------------------------------
!
! Behaviour: types for integration of behaviour
!
! --------------------------------------------------------------------------------------------------
!
! - Behaviour - Integration - Parameters on element
!
    type Behaviour_Elem
! ----- Size of element
        real(kind=8) :: eltsize1         = 0.d0
! ----- Size of element for ENDO_PORO_BETON
        real(kind=8) :: eltsize2(9)      = 0.d0
! ----- Gradient of velocity for *CRISTAL
        real(kind=8) :: gradvelo(9)      = 0.d0
! ----- Coordinates of all Gauss points
        real(kind=8) :: coor_elga(27, 3) = 0.d0
    end type Behaviour_Elem
!
! - Behaviour - Integration - Parameters on current Gauss point
!
    type Behaviour_Elga
! ----- For *_JOINT_HYME models : kinematic matrix
        real(kind=8) :: rotpg(3*3) = 0.d0
! ----- For CABLE_GAINE elements : tension of the cable
        real(kind=8) :: tenscab    = 0.d0
! ----- For CABLE_GAINE elements : curvature of the cable
        real(kind=8) :: curvcab    = 0.d0
! ----- For GRAD_VARI models : non-local variables PHI
        real(kind=8) :: nonloc(2)  = 0.d0
! ----- For CZM_*_MIX behaviours : Lagrange penalty coefficient
        real(kind=8) :: r          = 0.d0
! ----- Hygrometry
        real(kind=8) :: hygr_prev  = 0.d0
        real(kind=8) :: hygr_curr  = 0.d0
    end type Behaviour_Elga
!
! - Behaviour - Integration
!
    type Behaviour_Integ
! ----- Parameters on Gauss point
        type(Behaviour_Elga)  :: elga
! ----- Parameters on Element
        type(Behaviour_Elem)  :: elem
! ----- Flag when GEOM external state variable is present
        aster_logical         :: l_varext_geom = ASTER_FALSE
    end type Behaviour_Integ
!
! --------------------------------------------------------------------------------------------------
!
! Behaviour: types for preparation of behaviour (maps COMPOR and CARCRI)
!
! --------------------------------------------------------------------------------------------------
!
! - Behaviour - Preparation - Parameters for external behaviours
! 
    type Behaviour_ParaExte
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
    end type Behaviour_ParaExte
!
! - Behaviour - Preparation - Parameters for behaviour
! 
    type Behaviour_Para
! ----- Keyword RELATION
        character(len=16) :: rela_comp       = ' '
! ----- Keyword DEFORMATION
        character(len=16) :: defo_comp       = ' '
! ----- Keyword COMP_INCR/COMP_ELAS
        character(len=16) :: type_comp       = ' '
! ----- Keyword DEBORST
        character(len=16) :: type_cpla       = ' '
! ----- Keyword KIT
        character(len=16) :: kit_comp(4)     = ' '
! ----- Keyword COMPOR
        character(len=16) :: mult_comp       = ' '
! ----- Keyword POST_ITER
        character(len=16) :: post_iter       = ' '
! ----- Type of strain transmitted to the behaviour law : 'OLD', 'MECANIQUE' or 'TOTALE'
        character(len=16) :: defo_ldc        = ' '
! ----- Total number of internal state variables
        integer           :: nb_vari         = 0
! ----- Number of internal state variables for kit
        integer           :: nb_vari_comp(4) = 0
! ----- Index of law for kit
        integer           :: nume_comp(4)    = 0
    end type Behaviour_Para
!
! - Behaviour - Preparation - Criteria for behaviour
! 
    type Behaviour_Crit
! ----- Keyword RELATION
        character(len=16)         :: rela_comp = ' '
! ----- Parameters for external behaviours
        type(Behaviour_ParaExte)  :: paraExte
        integer                   :: type_matr_t      = 0
        real(kind=8)              :: parm_theta       = 0.d0
        integer                   :: iter_inte_pas    = 0
        real(kind=8)              :: vale_pert_rela   = 0.d0
        real(kind=8)              :: resi_deborst_max = 0.d0
        integer                   :: iter_deborst_max = 0
        real(kind=8)              :: resi_radi_rela   = 0.d0
        integer                   :: ipostiter        = 0
        integer                   :: ipostincr        = 0
        integer                   :: iveriborne       = 0
        aster_logical             :: l_matr_unsymm    = ASTER_FALSE
        real(kind=8)              :: algo_inte_r      = 0.d0
        real(kind=8)              :: resi_inte_rela   = 0.d0
        real(kind=8)              :: iter_inte_maxi   = 0.d0
        integer                   :: cptr_fct_ldc     = 0
        integer                   :: cptr_nbvarext    = 0
        integer                   :: cptr_namevarext  = 0
        integer                   :: cptr_nbprop      = 0
        integer                   :: cptr_nameprop    = 0
        integer                   :: jvariext1        = 0
        integer                   :: jvariext2        = 0
        integer                   :: jstrainexte      = 0
    end type Behaviour_Crit
!
! - Behaviour - Preparation - Map for criteria of behaviours (CARCRI)
! 
    type Behaviour_PrepCrit
! ----- Number of factor keywords
        integer                           :: nb_comp = 0
! ----- Parameters for THM scheme
        real(kind=8)                      :: parm_alpha_thm = 0.d0
        real(kind=8)                      :: parm_theta_thm = 0.d0
! ----- HHO parameters
        real(kind=8)                      :: hho_coef_stab = 0.d0
        real(kind=8)                      :: hho_type_stab = 0.d0
        real(kind=8)                      :: hho_type_calc = 0.d0
! ----- List of criteria (by keyword COMPORTEMENT)
        type(Behaviour_Crit), pointer     :: v_crit(:)
    end type Behaviour_PrepCrit
!
! - Behaviour - Preparation - Map for parameters of behaviours (COMPOR)
!
    type Behaviour_PrepPara
! ----- Number of factor keywords
        integer                             :: nb_comp = 0
! ----- List of parameters
        type(Behaviour_Para), pointer       :: v_para(:)     => null()
! ----- List of parameters for external behaviours
        type(Behaviour_ParaExte), pointer   :: v_paraExte(:) => null()
! ----- Flag for IMPLEX method
        aster_logical                       :: l_implex = ASTER_FALSE
    end type Behaviour_PrepPara
!
end module
