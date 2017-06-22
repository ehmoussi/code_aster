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

subroutine pmfdef(typfib, nf, ncarf, vf, dege, deff)
!
!
! --------------------------------------------------------------------------------------------------
!
!                       DEFORMATION AXIALE DES FIBRES
!
! --------------------------------------------------------------------------------------------------
!
!   IN
!       typfib  : type des fibres : 1 ou 2
!       nf      : nombre de fibres
!       ncarf   : nombre de caractéristiques sur chaque fibre
!       vf(*)   : positions des fibres
!           Types 1 et 2
!               vf(1,*) : Y fibres
!               vf(2,*) : Z fibres
!               vf(3,*) : Aire fibres
!           Types 2
!               vf(4,*) : Yp groupes de fibres
!               vf(5,*) : Zp groupes de fibres
!               vf(6,*) : num du groupe
!       dege(6) : deformations generalisees sur l'element
!
!   out
!       deff(nf) : deformations axiales des fibres
!
! person_in_charge: jean-luc.flejou at edf.fr
! --------------------------------------------------------------------------------------------------
!

    implicit none
#include "asterfort/utmess.h"
!
    integer :: typfib, nf, ncarf
    real(kind=8) :: vf(ncarf, nf), dege(6), deff(nf)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i
    real(kind=8) :: yy,zz,yp,zp
!
! --------------------------------------------------------------------------------------------------
!
    if ( typfib.eq.1 ) then
!       3 caractéristiques utiles par fibre : y z aire
        do i = 1, nf
            yy   = vf(1,i)
            zz   = vf(2,i)
            deff(i) = dege(1) - yy*dege(6) + zz*dege(5)
        enddo
    else if ( typfib.eq.2 ) then
!       6 caractéristiques utiles par fibre : y z aire yp zp numgr
        do  i = 1, nf
            yy   = vf(1,i)
            zz   = vf(2,i)
            yp   = vf(4,i)
            zp   = vf(5,i)
            deff(i) = dege(1) - (yy-yp)*dege(6) + (zz-zp)*dege(5)
        end do
    else
        call utmess('F', 'ELEMENTS2_40', si=typfib)
    endif

end subroutine
