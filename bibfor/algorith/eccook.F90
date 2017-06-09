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

subroutine eccook(acook, bcook, ccook, npuis, mpuis,&
                  epsp0, troom, tmelt, tp, dinst,&
                  pm, dp, rp, rprim)
! person_in_charge: sebastien.fayolle at edf.fr
    implicit none
!
!     ARGUMENTS:
!     ----------
    real(kind=8) :: acook, bcook, ccook, npuis, mpuis, epsp0, troom, tmelt, tp
    real(kind=8) :: dinst, pm, dp, rp, rprim
! ----------------------------------------------------------------------
! BUT: EVALUER LA FONCTION D'ECROUISSAGE ISOTROPE AVEC
!      LA LOI DE JOHNSON-COOK
!    IN: DP     : DEFORMATION PLASTIQUE CUMULEE
!   OUT: RP     : R(PM+DP)
!   OUT: RPRIM  : R'(PM+DP)
! ----------------------------------------------------------------------
!     VARIABLES LOCALES:
!     ------------------
    real(kind=8) :: p0
!
    p0=1.d-9
    if ((pm+dp) .le. p0) then
        rp= (acook+bcook*(p0)**npuis)
        rprim=npuis*bcook*(p0)**(npuis-1.d0)
    else
        rp=(acook+bcook*(pm+dp)**npuis)
        rprim=npuis*bcook*(pm+dp)**(npuis-1.d0)
        if (dp/dinst .gt. epsp0) then
            rprim=rprim+ccook*(rprim*log(dp/dinst/epsp0)+rp/dp)
            rp=rp*(1.d0+ccook*log(dp/dinst/epsp0))
        endif
        if ((tp.gt.troom) .and. (troom.ge.-0.5d0)) then
            rp=rp*(1.d0-((tp-troom)/(tmelt-troom))**mpuis)
            rprim=rprim*(1.d0-((tp-troom)/(tmelt-troom))**mpuis)
        endif
    endif
!
end subroutine
