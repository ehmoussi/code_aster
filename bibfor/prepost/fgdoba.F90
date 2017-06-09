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

subroutine fgdoba(nommat, nbcycl, sigmin, sigmax, lke,&
                  rke, lhaigh, rcorr, dom)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/rcvale.h"
    character(len=8) :: nommat
    real(kind=8) :: sigmin(*), sigmax(*)
    real(kind=8) :: rcorr(*), dom(*), rke(*)
    integer :: nbcycl
    aster_logical :: lhaigh, lke
!     CALCUL DU DOMMAGE ELEMENTAIRE PAR INTERPOLATION SUR
!     UNE COURBE DE WOHLER DONNEE PAR 1/N = A (DSIGMA)**BETA
!     FORMULE DE BASKIN
!     ------------------------------------------------------------------
! IN  NOMMAT : K8  : NOM DU MATERIAU
! IN  NBCYCL : I   : NOMBRE DE CYCLES
! IN  SIGMIN : R   : CONTRAINTES MINIMALES DES CYCLES
! IN  SIGMAX : R   : CONTRAINTES MAXIMALES DES CYCLES
! IN  LKE    : L   : PRISE EN COMPTE DU COEFFICIENT KE
! IN  RKE    : R   : VALEURS DU COEFFICIENT KE
! IN  LHAIGH : L   : PRISE EN COMPTE CORRECTION DE HAIGH
! IN  RCORR  : R   : VALEURS DE LA CORRECTION DE HAIGH
! OUT DOM    : R   : VALEURS DES DOMMAGES ELEMENTAIRES
!     ------------------------------------------------------------------
!
    real(kind=8) :: delta, val(2), rbid
    integer :: icodre(2)
    character(len=16) :: nomres(2)
    character(len=8) ::  nompar
!
!-----------------------------------------------------------------------
    integer :: i, nbpar
!-----------------------------------------------------------------------
    rbid = 0.d0
    nompar = ' '
    nbpar = 0
    nomres(1) = 'A_BASQUIN'
    nomres(2) = 'BETA_BASQUIN'
    call rcvale(nommat, 'FATIGUE', nbpar, nompar, [rbid],&
                2, nomres, val, icodre, 2)
    do 10 i = 1, nbcycl
        delta = (1.d0/2.d0)*abs(sigmax(i)-sigmin(i))
        if (lke) delta = delta * rke(i)
        if (lhaigh) delta = delta / rcorr(i)
        dom(i) = val(1)* delta**val(2)
 10 end do
!
end subroutine
