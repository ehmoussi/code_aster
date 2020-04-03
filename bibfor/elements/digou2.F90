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
! person_in_charge: jean-luc.flejou at edf.fr
!
subroutine digou2(option, nomte,&
                  lMatr, lVect, lSigm, lVari,&
                  rela_comp,&
                  ndim, nbt, nno,&
                  nc, dul, pgl)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/digouj.h"
#include "asterfort/infdis.h"
#include "asterfort/jevech.h"
#include "asterfort/ut2mgl.h"
#include "asterfort/ut2mlg.h"
#include "asterfort/utpsgl.h"
#include "asterfort/utpslg.h"
#include "blas/dcopy.h"
!
character(len=*) :: option, nomte
aster_logical, intent(in) :: lMatr, lVect, lSigm, lVari
character(len=*), intent(in) :: rela_comp
integer :: ndim, nbt, nno, nc
real(kind=8) :: dul(12), pgl(3, 3)
!
! --------------------------------------------------------------------------------------------------
!
!  IN
!     option   : option de calcul
!     nomte    : nom terme élémentaire
!     ndim     : dimension du problème
!     nbt      : nombre de terme dans la matrice de raideur
!     nno      : nombre de noeuds de l'élément
!     nc       : nombre de composante par noeud
!     dul      : incrément de déplacement
!     pgl      : matrice de passage de global a local
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jdc, irep, imat, ivarim, ifono, icontp, ivarip, icontm, neq
    real(kind=8) :: r8bid, klv(78), klv2(78)
    character(len=8) :: k8bid
!
!   paramètres en entrée
    call jevech('PCADISK', 'L', jdc)
    call jevech('PMATERC', 'L', imat)
    call jevech('PCONTMR', 'L', icontm)
    call jevech('PVARIMR', 'L', ivarim)
!   matrice de rigidité en repère local
    call infdis('REPK', irep, r8bid, k8bid)
    if (irep .eq. 1) then
        if (ndim .eq. 3) then
            call utpsgl(nno, nc, pgl, zr(jdc), klv)
        elseif (ndim.eq.2) then
            call ut2mgl(nno, nc, pgl, zr(jdc), klv)
        endif
    else
        call dcopy(nbt, zr(jdc), 1, klv, 1)
    endif
!
    ifono  = 1
    icontp = 1
    ivarip = 1
    if (lVect) then
        call jevech('PVECTUR', 'E', ifono)
    endif
    if (lSigm) then
        call jevech('PCONTPR', 'E', icontp)
    endif
    if (lVari) then
        call jevech('PVARIPR', 'E', ivarip)
    endif
!   relation de comportement : élastique partout
!   sauf suivant Y local : élasto-plastique VMIS_ISOT_TRAC
    neq = nno*nc
    call digouj(option, rela_comp, nno, nbt, neq,&
                nc, zi(imat), dul, zr(icontm), zr(ivarim),&
                pgl, klv, klv2, zr(ivarip), zr(ifono),&
                zr(icontp), nomte)
!
    if (lMatr) then
        call jevech('PMATUUR', 'E', imat)
        if (ndim .eq. 3) then
            call utpslg(nno, nc, pgl, klv, zr(imat))
        elseif (ndim.eq.2) then
            call ut2mlg(nno, nc, pgl, klv, zr(imat))
        endif
    endif
!
end subroutine
