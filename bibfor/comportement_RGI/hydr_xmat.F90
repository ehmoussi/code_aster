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

subroutine hydr_xmat(xmat0, xmat1, hydra1, hydras, n,&
                     erreur)
! person_in_charge: etienne.grimal at edf.fr
!=====================================================================
!     effet de l hydratation sur les caracteristiques materiau
!     declaration externe
!=====================================================================
    implicit none
#include "asterfort/utmess.h"
    real(kind=8) :: xmat0, xmat1, hydra1, hydras, n
    integer :: erreur
!     declaration locale
    real(kind=8) :: yy, zzmin
!     avant le seuil d hydratation on a 1e-5 des cracateristiques
    parameter (zzmin=1.d-5)
!
    if (hydra1 .le. hydras) then
        xmat1=xmat0*zzmin
    else
        if ((hydra1.le.1.000000001d0) .and. (hydras.ge.-0.99999999d0) .and.&
            (hydras.lt.(1.d0-zzmin))) then
            yy=(hydra1-hydras)/(1.d0-hydras)
            xmat1=xmat0*(yy**n)
        else
            erreur=1
            call utmess('F', 'COMPOR1_90')
        end if
    end if
!      print*,'ds hydr_xmat'
!      print*,xmat0,xmat1,hydra1,hydras,n,erreur
end subroutine
