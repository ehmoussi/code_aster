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
! aslint: disable=W1504
!
interface 
    subroutine equthm(option   , j_mater  ,&
                      typmod   , angl_naut, parm_theta,&
                      ndim     , nbvari   ,&
                      kpi      , npg      ,&
                      dimdef   , dimcon   ,&
                      mecani   , press1   , press2    , tempe, &
                      compor   , carcri   ,&
                      thmc     , hydr     ,&
                      advihy   , advico   ,&
                      vihrho   , vicphi   , vicpvp    , vicsat,&
                      defgem   , defgep   ,&
                      congem   , congep   ,&
                      vintm    , vintp    ,&
                      time_prev, time_curr, time_incr ,&
                      r        , drds     , dsde      , retcom)
        character(len=16), intent(in) :: option
        integer, intent(in) :: j_mater
        character(len=8), intent(in) :: typmod(2)
        real(kind=8), intent(in)  :: angl_naut(3), parm_theta
        integer, intent(in) :: ndim, nbvari
        integer, intent(in) :: npg, kpi
        integer, intent(in) :: dimdef, dimcon
        integer, intent(in) :: mecani(5), press1(7), press2(7), tempe(5)
        character(len=16), intent(in)  :: compor(*)
        real(kind=8), intent(in) :: carcri(*)
        character(len=16), intent(in) :: thmc, hydr
        integer, intent(in) :: advihy, advico
        integer, intent(in) :: vihrho, vicphi, vicpvp, vicsat
        real(kind=8), intent(in) :: defgem(dimdef), defgep(dimdef)
        real(kind=8), intent(inout) :: congem(dimcon), congep(dimcon)
        real(kind=8), intent(in) :: vintm(nbvari)
        real(kind=8), intent(inout) :: vintp(nbvari)
        real(kind=8), intent(in) :: time_prev, time_curr, time_incr
        real(kind=8), intent(out) :: r(dimdef+1)
        real(kind=8), intent(out) :: drds(dimdef+1, dimcon), dsde(dimcon, dimdef)
        integer, intent(out) :: retcom
    end subroutine equthm
end interface 
