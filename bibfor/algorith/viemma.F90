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

subroutine viemma(nbvari, vintm, vintp, advico, vicphi,&
                  phi0, dp1, dp2, signe, sat,&
                  em, phi, phim, retcom)
!
! --- CALCUL ET STOCKAGE DE LA VARIABLE INTERNE DE POROSITE ------------
! ======================================================================
    implicit none
!
#include "jeveux.h"
    integer :: nbvari, advico, vicphi, retcom
    real(kind=8) :: vintm(nbvari), vintp(nbvari), phi0, em
    real(kind=8) :: dp1, dp2, signe, sat, phi, phim
    real(kind=8) :: dpreq
! ======================================================================
! ======================================================================
! --- CALCUL DES ARGUMENTS EN EXPONENTIELS -----------------------------
! --- ET VERIFICATION DE SA COHERENCE ----------------------------------
! ======================================================================
    dpreq = (dp2 - sat*signe*dp1 )
    phim = vintm(advico+vicphi) + phi0
    phi=phim+dpreq*em
    vintp(advico+vicphi) = phi- phi0
! ======================================================================
! ======================================================================
end subroutine
