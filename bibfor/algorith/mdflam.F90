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

subroutine mdflam(dnorm, vitloc, knorm, cost, sint,&
                  flim, fseuil, rigifl, defpla, fnorma,&
                  flocal, vnorm)
    implicit none
!
!***********************************************************************
! 01/01/91    G.JACQUART AMV/P61 47 65 49 41
!***********************************************************************
!     FONCTION  : CALCULE LA DISTANCE NORMALE A L'OBSTACLE (<0 SI CHOC)
!
!-----------------------------------------------------------------------
!                             ARGUMENTS
! .________________.____.______________________________________________.
!    DNORM          <--   DISTANCE NORMALE A L'OBSTACLE
!    VITLOC         <--   VITESSE DANS LE REPERE LOCAL
!    COST,SINT      <--   DIRECTION NORMALE A L'OBSTACLE
!    KNORM          <--   RAIDEUR NORMALE DE CHOC
!    FNORMA          -->  FORCE NORMALE DE CHOC  (MODULE)
!    FLOCAL          -->  FORCE NORMALE DE CHOC REP. LOCAL
!-----------------------------------------------------------------------
    real(kind=8) :: vitloc(3), flocal(3), knorm, fnorma
!-----------------------------------------------------------------------
    real(kind=8) :: cost, defpla, dnorm, flim, fseuil, rigifl, sint
    real(kind=8) :: vnorm
!-----------------------------------------------------------------------
    vnorm = vitloc(2)*cost + vitloc(3)*sint
!
    if (defpla .le. 0.d0) then
!     --- FLAMBAGE NON ENCORE RENCONTRE ---
        if (-dnorm .lt. 0.d0) then
            fnorma = 0.0d0
        else
            if (-dnorm .lt. flim/knorm) then
                fnorma = -knorm*dnorm
            else
!           --- DEBUT DU FLAMBAGE ---
                fnorma = flim
                defpla = flim/knorm - fseuil/rigifl
                if (defpla .le. 0.d0) defpla = 1.d-20
            endif
        endif
    else
!     --- LE FLAMBAGE A DEJA EU LIEU ---
        if (-dnorm .lt. defpla) then
            fnorma = 0.0d0
        else
            if (vnorm .gt. 0.d0 .or. -dnorm .le. (fseuil/rigifl+defpla)) then
                fnorma = -rigifl*(dnorm+defpla)
                if (fnorma .lt. 0.d0) fnorma = 0.d0
            else
                fnorma = fseuil
                defpla = -dnorm - fseuil/rigifl
            endif
        endif
    endif
    flocal(1)=0.d0
    flocal(2)=fnorma*cost
    flocal(3)=fnorma*sint
end subroutine
