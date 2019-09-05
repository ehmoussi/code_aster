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
#include "asterf_types.h"
!
interface 
    subroutine coeihm(ds_thm, option, l_steady, l_resi, l_matr, j_mater,&
                      time_prev, time_curr, nomail,&
                      ndim, dimdef, dimcon, nbvari, &
                      addeme, adcome,&
                      addep1, adcp11, adcp12, addlh1, adcop1,&
                      addep2, adcp21, adcp22, addete, adcote,&
                      defgem, defgep, kpi, npg, npi,&
                      sigm, sigp, varim, varip, res,&
                      drde, retcom)
        use THM_type
        type(THM_DS), intent(inout) :: ds_thm
        integer, intent(in) :: j_mater
        character(len=8), intent(in) :: nomail
        character(len=16), intent(in) :: option
        integer, intent(in) :: dimdef, dimcon, npg, kpi, npi, ndim
        integer, intent(in) :: nbvari
        integer, intent(in) :: addeme, addep1, addep2, addete, adcop1, addlh1
        integer, intent(in) :: adcome, adcp11, adcp12, adcp21, adcp22, adcote
        real(kind=8), intent(in) :: defgem(1:dimdef), defgep(1:dimdef)
        real(kind=8), intent(in) :: varim(nbvari), time_prev, time_curr
        real(kind=8), intent(in) :: sigm(dimcon)
        aster_logical, intent(in) :: l_steady, l_resi, l_matr
        integer, intent(out) :: retcom
        real(kind=8), intent(inout) :: sigp(dimcon), varip(nbvari)
        real(kind=8), intent(out) :: res(dimdef), drde(dimdef, dimdef)
    end subroutine coeihm
end interface 
