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

subroutine dicora(lMatrPred, lMatr, lVect, lSigm, lVari,&
                  nbt, nno,&
                  nc, ulm, dul, pgl)
implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dicorn.h"
#include "asterfort/jevech.h"
#include "asterfort/pmavec.h"
#include "asterfort/ut2vlg.h"
#include "asterfort/utpslg.h"
#include "asterfort/utpvlg.h"
#include "asterfort/vecma.h"
!
aster_logical, intent(in) :: lMatr, lVect, lSigm, lMatrPred, lVari
integer :: nbt, nno, nc
real(kind=8) :: ulm(12), dul(12), pgl(3, 3)
!
! person_in_charge: jean-luc.flejou at edf.fr
! --------------------------------------------------------------------------------------------------
!
!  IN
!     nbt      : nombre de terme dans la matrice de raideur
!     nno      : nombre de noeuds de l'élément
!     nc       : nombre de composante par noeud
!     ulm      : déplacement moins
!     dul      : incrément de déplacement
!     pgl      : matrice de passage de global a local
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iiter, imat, ivarim, neq, iterat, ii, ifono, icontp, ivarip, icontm, irmetg
    real(kind=8) :: ulp(12), klv(78), klv2(78), varipc(7), klc(144), fl(12)
!
!   paramètres en entrée
    call jevech('PITERAT', 'L', iiter)
    call jevech('PMATERC', 'L', imat)
    call jevech('PVARIMR', 'L', ivarim)
    call jevech('PCONTMR', 'L', icontm)
!
    neq = nno*nc
    ulp(1:12) = ulm(1:12) + dul(1:12)
!   relation de comportement de la cornière
    irmetg = 0
    if (lMatrPred) irmetg = 1
    iterat = zi(iiter)
    call dicorn(irmetg, nbt, neq, iterat, zi(imat),&
                ulm, dul, ulp, zr(icontm), zr(ivarim),&
                klv, klv2, varipc)
!   actualisation de la matrice tangente
    if (lMatr) then
        call jevech('PMATUUR', 'E', imat)
        call utpslg(nno, nc, pgl, klv2, zr(imat))
    endif
!
!   calcul des efforts généralisés et des forces nodales
    if (lVect) then
!       Il faut séparer les deux => petit travail de réflexion
        ASSERT(lSigm)
        call jevech('PVECTUR', 'E', ifono)
        call jevech('PCONTPR', 'E', icontp)
!       demi-matrice klv transformée en matrice pleine klc
        call vecma(klv, nbt, klc, neq)
!       calcul de fl = klc.dul (incrément d'effort)
        call pmavec('ZERO', neq, klc, dul, fl)
!       efforts généralisés aux noeuds 1 et 2 (repère local)
!       on change le signe des efforts sur le premier noeud pour les MECA_DIS_TR_L et MECA_DIS_T_L
        if (nno .eq. 1) then
            do ii = 1, neq
                zr(icontp-1+ii) = fl(ii) + zr(icontm-1+ii)
                fl(ii) = fl(ii) + zr(icontm-1+ii)
            enddo
        elseif (nno.eq.2) then
            do ii = 1, nc
                zr(icontp-1+ii) = -fl(ii) + zr(icontm-1+ii)
                zr(icontp-1+ii+nc) = fl(ii+nc) + zr(icontm-1+ii+nc)
                fl(ii) = fl(ii) - zr(icontm-1+ii)
                fl(ii+nc) = fl(ii+nc) + zr(icontm-1+ii+nc)
            enddo
        endif
!       forces nodales aux noeuds 1 et 2 (repère global)
        if (nc .ne. 2) then
            call utpvlg(nno, nc, pgl, fl, zr(ifono))
        else
            call ut2vlg(nno, nc, pgl, fl, zr(ifono))
        endif
    endif
!   mise à jour des variables internes 
    if (lVari) then
        call jevech('PVARIPR', 'E', ivarip)
        do ii = 1, 7
            zr(ivarip+ii-1) = varipc(ii)
            zr(ivarip+ii+6) = varipc(ii)
        enddo
    endif
end subroutine
