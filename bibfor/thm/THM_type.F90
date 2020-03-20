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
!
module THM_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/THM_type.h"
!
! --------------------------------------------------------------------------------------------------
!
! THM - Define types 
!
! --------------------------------------------------------------------------------------------------
!

! - Type of FE
    type THM_Element
! ----- Type of FE: element where dof TEMP exist
        aster_logical :: l_dof_ther = ASTER_FALSE
! ----- Type of FE: element where dof DX, DY, DZ exist
        aster_logical :: l_dof_meca = ASTER_FALSE
! ----- Type of FE: element where dof PRE1 exist
        aster_logical :: l_dof_pre1 = ASTER_FALSE
! ----- Type of FE: element where dof PRE2 exist
        aster_logical :: l_dof_pre2 = ASTER_FALSE
! ----- Type of FE: element where dof PRE1 and PRE2 exist
        aster_logical :: l_dof_hydr = ASTER_FALSE
! ----- Type of FE: number of phasis for each fluid
        integer :: nb_phase(2) = 0
! ----- Flag for weak coupling
        aster_logical :: l_weak_coupling = ASTER_FALSE
! ----- Flag for *JHMS elements
        aster_logical :: l_jhms = ASTER_FALSE
    end type THM_Element

! - Behaviour
    type THM_Behaviour
! ----- Name of deformation algorithm
        character(len=16) :: defo      = ' '
! ----- Name of behaviour law for coupling
        character(len=16) :: rela_thmc = ' '
! ----- Name of behaviour law for mechanic
        character(len=16) :: rela_meca = ' '
! ----- Name of behaviour law for thermic
        character(len=16) :: rela_ther = ' '
! ----- Name of behaviour law for hydraulic
        character(len=16) :: rela_hydr = ' '
! ----- Index of behaviour law for coupling
        integer :: nume_thmc = 0
! ----- Index of behaviour law for mechanic
        integer :: nume_meca = 0
! ----- Index of behaviour law for thermic
        integer :: nume_ther = 0
! ----- Index of behaviour law for hydraulic
        integer :: nume_hydr = 0
! ----- Total number of internal variables
        integer :: nb_vari   = 0
! ----- Number of internal variables for coupling
        integer :: nb_vari_thmc = 0
! ----- Number of internal variables for mechanic
        integer :: nb_vari_meca = 0
! ----- Number of internal variables for thermic
        integer :: nb_vari_ther = 0
! ----- Number of internal variables for hydraulic
        integer :: nb_vari_hydr = 0
! ----- advime: index of first internal variable for mechanic in internal variable vectors
! ----- advith: index of first internal variable for thermic in internal variable vectors
! ----- advihy: index of first internal variable for hydric in internal variable vectors
! ----- advico: index of first internal variable for coupling in internal variable vectors
! ----- vihrho: index of internal state variable for volumic mass of liquid
! ----- vicphi: index of internal state variable for porosity
! ----- vicpvp: index of internal state variable for pressure of steam
! ----- vicsat: index of internal state variable for saturation
! ----- vicpr1: index of internal state variable for saving capillary pressure (FV)
! ----- vicpr2: index of internal state variable for saving gaz pressure (FV)
        integer :: advime = 0, advith = 0, advihy = 0, advico = 0
        integer :: vihrho = 0, vicphi = 0, vicpvp = 0, vicsat = 0
        integer :: vicpr1 = 0, vicpr2 = 0
! ----- Flag for thermic
        aster_logical :: l_temp = ASTER_FALSE
! ----- Flag for mechanic
        aster_logical :: l_meca = ASTER_FALSE
! ----- Total number of pressures (0, 1 or 2)
        integer :: nb_pres     = 0
! ----- Number of phases by pressure
        integer :: nb_phase(2) = 0
! ----- Type of saturation
        integer :: satur_type  = SATURATED
! ----- Flag for Bishop stresses
        aster_logical :: l_stress_bishop = ASTER_TRUE
    end type THM_Behaviour

! - Initial condition (THM_INIT)
    type THM_ParaInit
        real(kind=8) :: temp_init = 0.d0
        real(kind=8) :: pre1_init = 0.d0
        real(kind=8) :: pre2_init = 0.d0
        real(kind=8) :: poro_init = 0.d0
        real(kind=8) :: prev_init = 0.d0
    end type THM_ParaInit

! - Biot parameters
    type THM_Biot
        integer      :: type = BIOT_TYPE_ISOT
        real(kind=8) :: coef = 0.d0
        real(kind=8) :: l    = 0.d0
        real(kind=8) :: n    = 0.d0
        real(kind=8) :: t    = 0.d0
    end type THM_Biot

! - Elasticity parameters
    type THM_Elas
        integer :: id  = 0
        character(len=16) :: keyword = ' '
        real(kind=8) :: e = 0.d0, nu = 0.d0, g = 0.d0
        real(kind=8) :: e_l = 0.d0, e_t = 0.d0, e_n = 0.d0
        real(kind=8) :: nu_lt = 0.d0, nu_ln = 0.d0, nu_tn = 0.d0
        real(kind=8) :: g_lt = 0.d0, g_ln = 0.d0, g_tn = 0.d0
        real(kind=8) :: d(6,6) = 0.d0
    end type THM_Elas

! - Thermic parameters
    type THM_Ther
        real(kind=8) :: alpha = 0.d0
        real(kind=8) :: alpha_l = 0.d0, alpha_t = 0.d0, alpha_n = 0.d0
        integer :: cond_type = -1
        real(kind=8) :: lambda = 0.d0
        real(kind=8) :: lambda_tl = 0.d0, lambda_tn = 0.d0, lambda_tt = 0.d0
        real(kind=8) :: dlambda = 0.d0
        real(kind=8) :: dlambda_tl = 0.d0, dlambda_tn = 0.d0, dlambda_tt = 0.d0
        real(kind=8) :: lambda_ct = 0.d0
        real(kind=8) :: lambda_ct_l = 0.d0, lambda_ct_n = 0.d0, lambda_ct_t = 0.d0
    end type THM_Ther

! - Hydraulic parameters
    type THM_Hydr
        real(kind=8) :: n        = 0.d0
        real(kind=8) :: pr       = 0.d0
        real(kind=8) :: sr       = 0.d0
        real(kind=8) :: smax     = 0.d0
        real(kind=8) :: satuma   = 0.d0
        real(kind=8) :: emmag    = 0.d0
        real(kind=8) :: pentree  = 0.d0
        aster_logical :: l_emmag = ASTER_FALSE
    end type THM_Hydr

! - Gaz parameters
    type THM_Gaz
        real(kind=8) :: mass_mol    = 0.d0
        real(kind=8) :: visc        = 0.d0
        real(kind=8) :: dvisc_dtemp = 0.d0
        real(kind=8) :: cp          = 0.d0
    end type THM_Gaz

! - Liquid parameters
    type THM_Liquid
        real(kind=8) :: rho         = 0.d0
        real(kind=8) :: unsurk      = 0.d0
        real(kind=8) :: visc        = 0.d0
        real(kind=8) :: dvisc_dtemp = 0.d0
        real(kind=8) :: cp          = 0.d0
        real(kind=8) :: alpha       = 0.d0
    end type THM_Liquid

! - Dissolved air
    type THM_Ad
        real(kind=8) :: cp         = 0.d0
        real(kind=8) :: coef_henry = 0.d0
    end type THM_Ad

! Solid (homogeneous)
    type THM_Solid
        real(kind=8) :: rho   = 0.d0
        real(kind=8) :: r_gaz = 0.d0
        real(kind=8) :: cp    = 0.d0
    end type THM_Solid

! - Material parameters
    type THM_Material
! ----- For Biot coefficient (evolution of porosity)
        type(THM_Biot)    :: biot
! ----- For elasticity
        type(THM_Elas)    :: elas
! ----- For thermic
        type(THM_Ther)    :: ther
! ----- For hydraulic
        type(THM_Hydr)    :: hydr
! ----- For hydraulic
        aster_logical     :: l_gaz    = ASTER_FALSE
        type(THM_Gaz)     :: gaz
! ----- For hydraulic
        aster_logical     :: l_steam  = ASTER_FALSE
        type(THM_Gaz)     :: steam
! ----- For liquid
        aster_logical     :: l_liquid = ASTER_FALSE
        type(THM_Liquid)  :: liquid
! ----- For dissolved air
        aster_logical     :: l_ad     = ASTER_FALSE
        type(THM_Ad)      :: ad
! ----- For solid
        aster_logical     :: l_r_gaz  = ASTER_FALSE
        type(THM_Solid)   :: solid
    end type THM_Material
! - All parameters
    type THM_DS
        type(THM_ParaInit)  :: ds_parainit
        type(THM_Behaviour) :: ds_behaviour
        type(THM_Element)   :: ds_elem
        type(THM_Material)  :: ds_material
    end type THM_DS
!
end module
