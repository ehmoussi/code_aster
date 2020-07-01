! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
!
subroutine nmgrt3(nno, poids, def, pff,&
                  lVect, lMatr, lMatrPred,&
                  dsidep, sigmPrev, sigmCurr, matsym,&
                  matuu, vectu)
!
implicit none
!
#include "asterf_types.h"
!
integer :: nno
real(kind=8) :: pff(6, nno, nno), def(6, nno, 3), dsidep(6, 6), poids
real(kind=8) :: vectu(3, nno)
real(kind=8) :: sigmCurr(6), sigmPrev(6), matuu(*)
aster_logical :: matsym, lVect, lMatr, lMatrPred
!
! --------------------------------------------------------------------------------------------------
!
!     BUT:  CALCUL DE LA MATRICE TANGENTE EN CONFIGURATION LAGRANGIENNE
!           OPTIONS RIGI_MECA_TANG ET FULL_MECA
!
! --------------------------------------------------------------------------------------------------
!
! IN  NNO     : NOMBRE DE NOEUDS DE L'ELEMENT
! IN  POIDS   : POIDS DES POINTS DE GAUSS
! IN  DEF     : PRODUIT DE F PAR LA DERIVEE DES FONCTIONS DE FORME
! IN  PFF     : PRODUIT DES FONCTIONS DE FORME
! IN  DSIDEP  : OPERATEUR TANGENT ISSU DU COMPORTEMENT
! IN  SIGN    : CONTRAINTES PK2 A L'INSTANT PRECEDENT (AVEC RAC2)
! IN  SIGMA   : CONTRAINTES PK2 A L'INSTANT ACTUEL    (AVEC RAC2)
! IN  MATSYM  : VRAI SI LA MATRICE DE RIGIDITE EST SYMETRIQUE
! OUT MATUU   : MATRICE DE RIGIDITE PROFIL (RIGI_MECA_TANG ET FULL_MECA)
! OUT VECTU   : VECTEUR DES FORCES INTERIEURES (RAPH_MECA ET FULL_MECA)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: kk, kkd, n, i, m, j, j1, kl, nmax
    real(kind=8) :: tmp1, tmp2, sigg(6), sig(6)
!
! --------------------------------------------------------------------------------------------------
!
    if (lMatr) then
! ----- Get stresses for geometric part
        if (lMatrPred) then
            sigg(1) = sigmPrev(1)
            sigg(2) = sigmPrev(2)
            sigg(3) = sigmPrev(3)
            sigg(4) = sigmPrev(4)
            sigg(5) = sigmPrev(5)
            sigg(6) = sigmPrev(6)
        else
            sigg(1) = sigmCurr(1)
            sigg(2) = sigmCurr(2)
            sigg(3) = sigmCurr(3)
            sigg(4) = sigmCurr(4)
            sigg(5) = sigmCurr(5)
            sigg(6) = sigmCurr(6)
        endif
! ----- Compute matrix
        do n = 1, nno
            do i = 1, 3
                do kl = 1, 6
                    sig(kl) = 0.d0
                    sig(kl) = sig(kl)+def(1,n,i)*dsidep(1,kl)
                    sig(kl) = sig(kl)+def(2,n,i)*dsidep(2,kl)
                    sig(kl) = sig(kl)+def(3,n,i)*dsidep(3,kl)
                    sig(kl) = sig(kl)+def(4,n,i)*dsidep(4,kl)
                    sig(kl) = sig(kl)+def(5,n,i)*dsidep(5,kl)
                    sig(kl) = sig(kl)+def(6,n,i)*dsidep(6,kl)
                end do
                if (matsym) then
                    nmax = n
                else
                    nmax = nno
                endif
                do j = 1, 3
                    do m = 1, nmax
! --------------------- Geometric part
                        tmp1 = 0.d0
                        if (i .eq. j) then
                            tmp1 = pff(1,n,m)*sigg(1) + pff(2,n,m)* sigg(2) +&
                                   pff(3,n,m)*sigg(3) + pff(4,n,m)* sigg(4) +&
                                   pff(5,n,m)*sigg(5) + pff(6,n,m)* sigg(6)
                        endif
! --------------------- Material part
                        tmp2=0.d0
                        tmp2=tmp2+sig(1)*def(1,m,j)
                        tmp2=tmp2+sig(2)*def(2,m,j)
                        tmp2=tmp2+sig(3)*def(3,m,j)
                        tmp2=tmp2+sig(4)*def(4,m,j)
                        tmp2=tmp2+sig(5)*def(5,m,j)
                        tmp2=tmp2+sig(6)*def(6,m,j)
                        if (matsym) then
                            if (m .eq. n) then
                                j1 = i
                            else
                                j1 = 3
                            endif
                            if (j .le. j1) then
                                kkd = (3*(n-1)+i-1) * (3*(n-1)+i)/2
                                kk = kkd + 3*(m-1)+j
                                matuu(kk) = matuu(kk) + (tmp1+tmp2)* poids
                            endif
                        else
                            kk = 3*nno*(3*(n-1)+i-1) + 3*(m-1)+j
                            matuu(kk) = matuu(kk) + (tmp1+tmp2)*poids
                        endif
                    end do
                end do
            end do
        end do
    endif
!
! - Internal forces
!
    if (lVect) then
        do n = 1, nno
            do i = 1, 3
                do kl = 1, 6
                    vectu(i,n) = vectu(i,n)+&
                                 def(kl,n,i)*sigmCurr(kl)*poids
                end do
            end do
        end do
    endif
!
end subroutine
