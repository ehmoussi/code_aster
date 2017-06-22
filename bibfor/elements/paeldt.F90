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

subroutine paeldt(kpg, ksp, fami, poum, icdmat,&
                  materi, em, ep, nup, depsth,&
                  tmoins, tplus, trefer)
    implicit none
#include "asterfort/rcvalb.h"
#include "asterfort/verift.h"
!
    integer :: kpg, ksp, icdmat
    character(len=1) :: poum
    character(len=4) :: fami
    character(len=8) :: materi
    real(kind=8) :: em, ep, num, nup, depsth
    real(kind=8), intent(out), optional :: tmoins, tplus, trefer
! --------------------------------------------------------------------------------------------------
!
!        CALCUL DES PARAMETRES ELASTIQUES ET DE LA
!        DEFORMATION THERMIQUE POUR UN SOUS-POINT DONNE
!
! --------------------------------------------------------------------------------------------------
    integer :: icodre(2)
    real(kind=8) :: valres(2), tpl, tms, tref
    character(len=16) :: nomres(2)
!
    nomres(1) = 'E'
    nomres(2) = 'NU'
!
    if ( poum.eq. 'T' ) then
        call rcvalb(fami, kpg, ksp, '-', icdmat,&
                    materi, 'ELAS', 0, ' ', [0.d0],&
                    2, nomres, valres, icodre, 1)
        em  = valres(1)
        num = valres(2)
!
        call rcvalb(fami, kpg, ksp, '+', icdmat,&
                    materi, 'ELAS', 0, ' ', [0.d0],&
                    2, nomres, valres, icodre, 1)
        ep  = valres(1)
        nup = valres(2)
!
        call verift(fami, kpg, ksp, 'T', icdmat,&
                    materi, epsth_= depsth,&
                    temp_prev_=tms, temp_curr_=tpl, temp_refe_=tref)
!
    else
        call rcvalb(fami, kpg, ksp, poum, icdmat,&
                    materi, 'ELAS', 0, ' ', [0.d0],&
                    2, nomres, valres, icodre, 1)
        ep  = valres(1)
        nup = valres(2)
        em  = valres(1)
        call verift(fami, kpg, ksp, poum, icdmat,&
                    materi, epsth_=depsth,&
                    temp_prev_=tms, temp_curr_=tpl, temp_refe_=tref)
    endif
!
    if (present(tmoins)) then
        tmoins = tms
    endif
    if (present(tplus)) then
        tplus = tpl
    endif
    if (present(trefer)) then
        trefer = tref
    endif
end subroutine
