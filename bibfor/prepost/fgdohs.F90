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

subroutine fgdohs(nommat, nbcycl, sigmin, sigmax, lke,&
                  rke, lhaigh, rcorr, dom)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/rcvale.h"
    character(len=8) :: nommat
    real(kind=8) :: sigmin(*), sigmax(*)
    real(kind=8) :: rke(*), rcorr(*), dom(*)
    integer :: nbcycl
    aster_logical :: lke, lhaigh
!     CALCUL DU DOMMAGE ELEMENTAIRE PAR INTERPOLATION SUR
!     UNE COURBE DE WOHLER DONNEE HORS ZONE SINGULIERE
!     ------------------------------------------------------------------
! IN  NOMMAT : K8  : NOM DU MATERIAU
! IN  NBCYCL : I   : NOMBRE DE CYCLES
! IN  SIGMIN : R   : CONTRAINTES MINIMALES DES CYCLES
! IN  SIGMAX : R   : CONTRAINTES MAXIMALES DES CYCLES
! IN  LKE    : L   : PRISE EN COMPTE DU COEFFICIENT KE
! IN  RKE    : R   : VALEURS DES COEFFICIENTS KE
! IN  LHAIGH : L   : PRISE EN COMPTE DE LA CORRECTION DE HAIGH
! IN  RCORR  : R   : VALEURS DES CORRECTIONS DE HAIGH
! OUT DOM    : R   : VALEURS DES DOMMAGES ELEMENTAIRES
!     ------------------------------------------------------------------
!
    integer :: icodre(6)
    character(len=8) :: nompar
    character(len=16) :: nomres(6)
!
    real(kind=8) :: delta, salt, x, y, nrupt, slmodi, val(6), rbid, re(1)
!
!-----------------------------------------------------------------------
    integer :: i, nbpar
!-----------------------------------------------------------------------
    rbid = 0.d0
    nomres(1) = 'E_REFE'
    nomres(2) = 'A0'
    nomres(3) = 'A1'
    nomres(4) = 'A2'
    nomres(5) = 'A3'
    nomres(6) = 'SL'
    nbpar = 0
    nompar = ' '
    call rcvale(nommat, 'FATIGUE', nbpar, nompar, [rbid],&
                6, nomres, val, icodre, 2)
    nomres(1) = 'E'
    call rcvale(nommat, 'ELAS', nbpar, nompar, [rbid],&
                1, nomres, re(1), icodre, 2)
    do 10 i = 1, nbcycl
        delta = abs(sigmax(i)-sigmin(i))
        if (lke) delta = delta * rke(i)
        if (lhaigh) then
            delta = delta / rcorr(i)
            slmodi = val(6) / rcorr(i)
        else
            slmodi = val(6)
        endif
        salt = 1.d0/2.d0*(val(1)/re(1))*delta
        x = log10 (salt)
        if (salt .ge. slmodi) then
            y = val(2) + val(3)*x + val(4)*x**2 + val(5)*x**3
            nrupt = 10**y
            dom(i) = 1.d0 / nrupt
        else
            dom(i) = 0.d0
        endif
 10 end do
!
end subroutine
