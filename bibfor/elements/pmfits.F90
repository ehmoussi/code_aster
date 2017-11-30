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

subroutine pmfits(typfib, nf, ncarf, vf, vsig, vs)
!
!
! --------------------------------------------------------------------------------------------------
!
!   INTEGRATION DES CONTRAINTES SUR LA SECTION : CALCUL DES FORCES INTERIEURES
!
! --------------------------------------------------------------------------------------------------
!
!    IN
!       typfib  : type des fibres : 1 ou 2
!       nf      : nombre de fibres
!       ncarf   : nombre de caracteristiques sur chaque fibre
!       vf(*)   : positions des fibres
!           Types 1 et 2
!               vf(1,*) : Y fibres
!               vf(2,*) : Z fibres
!               vf(3,*) : Aire fibres
!           Types 2
!               vf(4,*) : Yp groupes de fibres
!               vf(5,*) : Zp groupes de fibres
!               vf(6,*) : GX groupes de fibres
!       vsig(*) : contrainte normale dans chaque fibre
!
!   OUT
!       vs(1) : int(sig.ds)      =  n0
!       vs(2) : int(sig.y.ds)    = -mfz0
!       vs(3) : int(sig.z.ds)    =  mfy0
!
! --------------------------------------------------------------------------------------------------
!
    implicit none
#include "asterfort/utmess.h"
!
    integer :: typfib, nf, ncarf
    real(kind=8) :: vf(ncarf, nf), vsig(nf), vs(3)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ii
    real(kind=8) :: sigsf, yy, zz, aire
!
! --------------------------------------------------------------------------------------------------
!
    vs(:)=0.0d0

!
    if ( typfib.eq.1 ) then
!       caractéristiques utiles par fibre : Y Z AIRE
        do ii = 1, nf
            yy   = vf(1,ii)
            zz   = vf(2,ii)
            aire = vf(3,ii)
!
            sigsf = vsig(ii)*aire
            vs(1) = vs(1)+sigsf
            vs(2) = vs(2)+yy*sigsf
            vs(3) = vs(3)+zz*sigsf
        enddo
    else if ( typfib.eq.2  .or. typfib.eq.3 ) then
!       caractéristiques utiles par fibre : Y Z AIRE YP ZP GX
        do ii = 1, nf
            yy   = vf(1,ii)
            zz   = vf(2,ii)
            aire = vf(3,ii)
!
            sigsf = vsig(ii)*aire
            vs(1) = vs(1)+sigsf
            vs(2) = vs(2)+yy*sigsf
            vs(3) = vs(3)+zz*sigsf
        enddo
    else
        call utmess('F', 'ELEMENTS2_40', si=typfib)
    endif
!
end subroutine
