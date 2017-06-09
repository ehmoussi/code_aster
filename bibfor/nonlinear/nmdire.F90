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

subroutine nmdire(noeu1, noeu2, ndim, cnsln, grln,&
                  grlt, compo, vect)
!
    implicit none
#include "jeveux.h"
#include "asterc/r8prem.h"
#include "asterfort/jeveuo.h"
#include "asterfort/provec.h"
    integer :: noeu1, noeu2, ndim
    character(len=19) :: cnsln, grln, grlt
    character(len=8) :: compo
    real(kind=8) :: vect(3)
!
! ----------------------------------------------------------------------
! CALCUL DIRECTION DE PILOTAGE DNOR, DTAN OU DTAN2
! FORMULATION XFEM
! ----------------------------------------------------------------------
!
!
! IN  NOEU1  : EXTREMITE 1 ARETE PILOTEE
! IN  NOEU1  : EXTREMITE 2 ARETE PILOTEE
! IN  NDIM   : DIMENSION PROBLEME
! IN  CNSLSN : NOM CHAM_NO_S LEVEL SET NORMALE
! IN  GRLN   : NOM CHAM_NO_S GRADIENT LEVEL SET NORMALE
! IN  GRLT   : NOM CHAM_NO_S GRADIENT LEVEL SET TANGENTIELLE
! IN  COMPO  : DIRECTION A PILOTER
! OUT  VECT  : VECTEUR NORME DE CETTE DIRECTION DANS LA BASE FIXE
!
!
!
!
    integer ::   jgrtno, i
    real(kind=8) :: norm(3), tang(3), normn
    real(kind=8) :: tang2(3), normt
    real(kind=8) :: lsn1, lsn2, eps
    real(kind=8), pointer :: grnno(:) => null()
    real(kind=8), pointer :: lsn(:) => null()
!
!
    call jeveuo(cnsln//'.CNSV', 'E', vr=lsn)
    call jeveuo(grln//'.CNSV', 'E', vr=grnno)
    call jeveuo(grlt//'.CNSV', 'E', jgrtno)
    lsn1 = lsn(noeu1)
    lsn2 = lsn(noeu2)
    eps=r8prem()
    norm(1)=0.d0
    norm(2)=0.d0
    norm(3)=0.d0
    tang(1)=0.d0
    tang(2)=0.d0
    tang(3)=0.d0
!
    if ((abs(lsn1).le.eps) .and. (abs(lsn2).le.eps)) then
        do 95 i = 1, ndim
            norm(i) = norm(i)+ grnno(ndim*(noeu1-1)+i)
95      continue
    else
        do 91 i = 1, ndim
            norm(i) = norm(i)+ abs(lsn1)*grnno(ndim*(noeu2-1)+i) + abs(lsn2)*grnno(nd&
                      &im*(noeu1-1)+i)
91      continue
    endif
    normn=sqrt(norm(1)**2+norm(2)**2+norm(3)**2)
    norm(1)=norm(1)/normn
    norm(2)=norm(2)/normn
    norm(3)=norm(3)/normn
!
    if (compo(1:4) .eq. 'DTAN') then
        if (ndim .eq. 2) then
            tang(1)=norm(2)
            tang(2)=-norm(1)
        else if (ndim.eq.3) then
            tang2(1)=1.d0
            tang2(2)=0.d0
            tang2(3)=0.d0
            call provec(norm, tang2, tang)
            normt=sqrt(tang(1)**2+tang(2)**2+tang(3)**2)
            if (normt .le. eps) then
                tang(1)=0.d0
                tang(2)=1.d0
                tang(3)=0.d0
            else
                tang(1)=tang(1)/normt
                tang(2)=tang(2)/normt
                tang(3)=tang(3)/normt
            endif
            call provec(norm, tang, tang2)
        endif
    endif
!
    do 92 i = 1, ndim
        if (compo .eq. 'DNOR') then
            vect(i)=norm(i)
        else if (compo.eq.'DTAN2') then
            vect(i)=tang2(i)
        else if (compo.eq.'DTAN') then
            vect(i)=tang(i)
        endif
92  continue
end subroutine
