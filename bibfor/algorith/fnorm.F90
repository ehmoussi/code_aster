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

subroutine fnorm(dnorm, vitloc, knorm, cnorm, cost,&
                 sint, fnorma, flocal, vnorm)
!
!***********************************************************************
! 01/01/91    G.JACQUART AMV/P61 47 65 49 41
!***********************************************************************
!     FONCTION  : CALCULE LA DISTANCE NORMALE A L'OBSTACLE (<0 SI CHOC)
!
!-----------------------------------------------------------------------
!                             ARGUMENTS
! .________________.____.______________________________________________.
!        NOCM       MODE                    ROLE
!  ________________ ____ ______________________________________________
!                         VARIABLES DU SYSTEME DYNAMIQUE MODAL
!  ________________ ____ ______________________________________________
!    DNORM          <--   DISTANCE NORMALE A L'OBSTACLE
!    VITLOC         <--   VITESSE DANS LE REPERE LOCAL
!    COST,SINT      <--   DIRECTION NORMALE A L'OBSTACLE
!    KNORM          <--   RAIDEUR NORMALE DE CHOC
!    CNORM          <--   AMORTISSEUR NORMALE DE CHOC
!    FNORMA          -->  FORCE NORMALE DE CHOC  (MODULE)
!    FLOCAL          -->  FORCE NORMALE DE CHOC REP. LOCAL
!-----------------------------------------------------------------------
    implicit none
    real(kind=8) :: vitloc(3), flocal(3), knorm, cnorm, fnorma
!-----------------------------------------------------------------------
    real(kind=8) :: cost, dnorm, sint, vnorm
!-----------------------------------------------------------------------
    vnorm = vitloc(2)*cost + vitloc(3)*sint
    fnorma = - knorm*dnorm - cnorm*vnorm
    if (fnorma .lt. 0.0d0) then
        fnorma = 0.0d0
    endif
    flocal(1)=0.d0
    flocal(2)=fnorma*cost
    flocal(3)=fnorma*sint
end subroutine
