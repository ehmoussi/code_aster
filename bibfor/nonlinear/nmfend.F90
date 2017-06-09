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

function nmfend(dr)
! aslint: disable=W1304
    implicit none
!
!     ARGUMENTS:
!     ----------
#include "asterc/r8miem.h"
    real(kind=8) :: nmfend, dr
! ----------------------------------------------------------------------
!    BUT:  EVALUER LA DERIVEE DE LA FONCTION DONT ON CHERCHE LE ZERO
!          POUR VENDOCHAB
!
!     IN:  DR     : DEFORMATION PLASTIQUE CUMULEE*(1-D)
!    OUT:  NMFEND : VALEUR DE LA FONCTION
!
! ----------------------------------------------------------------------
!     VARIABLES LOCALES:
!     ------------------
!----- COMMONS NECESSAIRES A VENDOCHAB
    common   /fvendo/mu,syvp,kvp,rm,dm,seqe,ad,dt,rd,unsurn,unsurm
    real(kind=8) :: mu, syvp, kvp, rm, dm, seqe, ad, dt, unsurn, unsurm
    real(kind=8) :: dd, rd, gder, unmd, dtn, puis
!
    dtn=dt**unsurn
!
    if (dr .lt. r8miem()) then
        gder=0.d0
        dd=0.d0
    else
        gder=kvp*(dr**unsurn)*((rm+dr)**unsurm)+syvp*dtn
        puis=1.d0-rd*unsurn
        dd=(dt**puis)*((gder/ad)**rd)
    endif
    unmd=1.d0-dm-dd
    nmfend= gder*unmd+3.d0*mu*dr*dtn-seqe*unmd*dtn
!
end function
