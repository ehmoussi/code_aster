! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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
subroutine nmdopo(sddyna, ds_posttimestep)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/getfac.h"
#include "asterfort/assert.h"
#include "asterfort/as_allocate.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/infniv.h"
#include "asterfort/ndynlo.h"
#include "asterfort/omega2.h"
#include "asterfort/selectListRead.h"
!
character(len=19), intent(in) :: sddyna
type(NL_DS_PostTimeStep), intent(inout) :: ds_posttimestep
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Post-treatment management
!
! Read parameters for post-treatment parameters
!
! --------------------------------------------------------------------------------------------------
!
! IN  SDDYNA : SD DYNAMIQUE
! IO  ds_posttimestep  : datastructure for post-treatment at each time step
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nb_maxi_dof = 40
    integer :: iret, iocc, nb_dof_excl, nb_dof_stab, nocc
    integer :: ifm, niv
    aster_logical :: l_dyna, l_stat, l_impl
    aster_logical :: l_crit_stab = ASTER_FALSE, l_mode_vibr = ASTER_FALSE
    aster_logical :: l_small = ASTER_FALSE, l_strip = ASTER_FALSE
    character(len=16) :: option, type_matr_rigi, keywfact, answer, instab_sign
    integer :: nb_eigen, coef_dim_espace
    real(kind=8) :: strip(2)
    real(kind=8) :: instab_prec
    integer :: iarg
    character(len=16) :: level
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> . Read parameters for post-treatment parameters'
    endif
!
! - Initializations
!
    iocc        = 1
    strip(1)    = -10.d0
    strip(2)    = 10.d0
    l_mode_vibr = ASTER_FALSE
    l_crit_stab = ASTER_FALSE
!
! - Active functionnalities
!
    l_dyna = ndynlo(sddyna, 'DYNAMIQUE')
    l_stat = ndynlo(sddyna, 'STATIQUE')
    l_impl = ndynlo(sddyna, 'IMPLICITE')
!
! - What is active ?
!
    call getfac('CRIT_STAB', nocc)
    ASSERT(nocc .le. 1)
    l_crit_stab = nocc .ne. 0
    if (l_dyna) then
        call getfac('MODE_VIBR', nocc)
        ASSERT(nocc .le. 1)
        l_mode_vibr = nocc .ne. 0
    endif
    ds_posttimestep%l_crit_stab = l_crit_stab
    ds_posttimestep%l_mode_vibr = l_mode_vibr
!
! - Option to compute
!
    if (l_crit_stab) then
        if (l_stat) then
            option = 'FLAMBSTA'
        else if (l_impl) then
            option = 'FLAMBDYN'
        else
            ASSERT(ASTER_FALSE)
        endif
        ds_posttimestep%crit_stab%option = option
    endif
    if (l_mode_vibr) then
        if (l_impl) then
            option = 'VIBRDYNA'
        else
            ASSERT(ASTER_FALSE)
        endif
        ds_posttimestep%mode_vibr%option = option
    endif
!
! - Parameters for MODE_VIBR
!
    if (l_mode_vibr) then
        keywfact = 'MODE_VIBR'
! ----- Rigidity matrix
        call getvtx(keywfact, 'MATR_RIGI', iocc=iocc, scal=type_matr_rigi, nbret=iret,&
                    isdefault=iarg)
        ds_posttimestep%mode_vibr%type_matr_rigi = type_matr_rigi
! ----- How to seek eigen values
        call getvtx(keywfact, 'OPTION', iocc=iocc, scal=level, nbret=iret,&
                    isdefault=iarg)
        l_small = ASTER_FALSE
        l_strip = ASTER_FALSE
        if (level .eq. 'BANDE') then
            call getvr8(keywfact, 'FREQ', iocc=iocc, nbval=2, vect=strip,&
                        nbret=iret, isdefault=iarg)
            l_strip = ASTER_TRUE
            ds_posttimestep%mode_vibr%strip_bounds(1) = omega2(strip(1))
            ds_posttimestep%mode_vibr%strip_bounds(2) = omega2(strip(2))
        elseif (level .eq. 'PLUS_PETITE') then
            call getvis(keywfact, 'NMAX_FREQ', iocc=iocc, scal=nb_eigen, nbret=iret,&
                        isdefault=iarg)
            l_small = ASTER_TRUE
            ds_posttimestep%mode_vibr%nb_eigen = nb_eigen
        elseif (level .eq. 'CALIBRATION') then
            call getvr8(keywfact, 'FREQ', iocc=iocc, nbval=2, vect=strip,&
                        nbret=iret, isdefault=iarg)
            l_strip = ASTER_TRUE
            ds_posttimestep%mode_vibr%strip_bounds(1) = omega2(strip(1))
            ds_posttimestep%mode_vibr%strip_bounds(2) = omega2(strip(2))
        else
            ASSERT(ASTER_FALSE)
        endif
        ds_posttimestep%mode_vibr%level   = level
        ds_posttimestep%mode_vibr%l_small = l_small
        ds_posttimestep%mode_vibr%l_strip = l_strip
! ----- Get parameters for eigen solver
        call getvis(keywfact, 'COEF_DIM_ESPACE', iocc=iocc, scal=coef_dim_espace, nbret=iret,&
                    isdefault=iarg)
        ds_posttimestep%mode_vibr%coef_dim_espace = coef_dim_espace
! ----- Read select list
        call selectListRead(keywfact, iocc, ds_posttimestep%mode_vibr%selector)
    endif
!
! - Parameters for CRIT_STAB
!
    if (l_crit_stab) then
        keywfact = 'CRIT_STAB'
! ----- How to seek eigen values
        call getvtx(keywfact, 'OPTION', iocc=iocc, scal=level, nbret=iret,&
                    isdefault=iarg)
        l_small = ASTER_FALSE
        l_strip = ASTER_FALSE
        if (level .eq. 'BANDE') then
            call getvr8(keywfact, 'CHAR_CRIT', iocc=iocc, nbval=2, vect=strip,&
                        nbret=iret, isdefault=iarg)
            l_strip = ASTER_TRUE
            ds_posttimestep%crit_stab%strip_bounds(1) = strip(1)
            ds_posttimestep%crit_stab%strip_bounds(2) = strip(2)
        elseif (level .eq. 'PLUS_PETITE') then
            call getvis(keywfact, 'NMAX_CHAR_CRIT', iocc=iocc, scal=nb_eigen, nbret=iret,&
                        isdefault=iarg)
            l_small = ASTER_TRUE
            ds_posttimestep%crit_stab%nb_eigen = nb_eigen
        elseif (level .eq. 'CALIBRATION') then
            call getvr8(keywfact, 'CHAR_CRIT', iocc=iocc, nbval=2, vect=strip,&
                        nbret=iret, isdefault=iarg)
            l_strip = ASTER_TRUE
            ds_posttimestep%crit_stab%strip_bounds(1) = strip(1)
            ds_posttimestep%crit_stab%strip_bounds(2) = strip(2)
        else
            ASSERT(ASTER_FALSE)
        endif
        ds_posttimestep%mode_vibr%level   = level
        ds_posttimestep%crit_stab%l_small = l_small
        ds_posttimestep%crit_stab%l_strip = l_strip
! ----- Get parameters for eigen solver
        call getvis(keywfact, 'COEF_DIM_ESPACE', iocc=iocc, scal=coef_dim_espace, nbret=iret,&
                    isdefault=iarg)
        ds_posttimestep%crit_stab%coef_dim_espace = coef_dim_espace
! ----- Read select list
        call selectListRead(keywfact, iocc, ds_posttimestep%crit_stab%selector)
! ----- Geometric matrix
        call getvtx(keywfact, 'RIGI_GEOM', iocc=iocc, scal=answer, nbret=iret,&
                    isdefault=iarg)
        ds_posttimestep%stab_para%l_geom_matr = answer .eq. 'OUI'
! ----- Modification of rigidity matrix
        call getvtx(keywfact, 'MODI_RIGI', iocc=iocc, scal=answer, nbret=iret,&
                    isdefault=iarg)
        ds_posttimestep%stab_para%l_modi_rigi = answer .eq. 'OUI'
! ----- Excluded DOF
        call getvtx(keywfact, 'DDL_EXCLUS', iocc=iocc, nbval=0, nbret=nb_dof_excl,&
                    isdefault=iarg)
        nb_dof_excl = -nb_dof_excl
        ds_posttimestep%stab_para%nb_dof_excl = nb_dof_excl
        if (nb_dof_excl .ne. 0) then
            ASSERT(nb_dof_excl .le. nb_maxi_dof)
            AS_ALLOCATE(vk8 = ds_posttimestep%stab_para%list_dof_excl, size = nb_dof_excl)
            call getvtx(keywfact, 'DDL_EXCLUS', iocc=iocc,&
                        nbval=nb_dof_excl, vect=ds_posttimestep%stab_para%list_dof_excl,&
                        nbret=iret, isdefault=iarg)
        endif
! ----- Stabilized DOF
        call getvtx(keywfact, 'DDL_STAB', iocc=iocc, nbval=0, nbret=nb_dof_stab,&
                    isdefault=iarg)
        nb_dof_stab = -nb_dof_stab
        ds_posttimestep%stab_para%nb_dof_stab = nb_dof_stab
        if (nb_dof_stab .ne. 0) then
            ASSERT(nb_dof_stab .le. nb_maxi_dof)
            AS_ALLOCATE(vk8 = ds_posttimestep%stab_para%list_dof_stab, size = nb_dof_stab)
            call getvtx(keywfact, 'DDL_STAB', iocc=iocc,&
                        nbval=nb_dof_stab, vect=ds_posttimestep%stab_para%list_dof_stab,&
                        nbret=iret, isdefault=iarg)
        endif
! ----- Stabilization parameters
        call getvr8(keywfact, 'PREC_INSTAB', iocc=iocc, scal=instab_prec, nbret=iret,&
                    isdefault=iarg)
        ds_posttimestep%stab_para%instab_prec = instab_prec
        call getvtx(keywfact, 'SIGNE', iocc=iocc, scal=instab_sign, nbret=iret,&
                    isdefault=iarg)
        ds_posttimestep%stab_para%instab_sign = instab_sign
    endif
!
end subroutine
