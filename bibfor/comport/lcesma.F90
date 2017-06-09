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

subroutine lcesma(mat, fami, kpg, ksp, poum, lccrma)
    implicit none
#include "asterfort/rcvalb.h"
#include "asterfort/rcvarc.h"
    interface
    subroutine lccrma(mat, fami, kpg, ksp, poum)
        integer,intent(in) :: mat, kpg, ksp
        character(len=1),intent(in):: poum
        character(len=*),intent(in) :: fami
    end subroutine lccrma
    end interface

    integer :: mat, kpg, ksp
    character(len=1) :: poum
    character(len=*) :: fami
! ----------------------------------------------------------------------
!   ENDOMMAGEMENT FRAGILE A GRADIENT DE VARIABLE INTERNE ENDO_SCALAIRE
!                    LECTURE DES PARAMETRES COMMUNS
! ----------------------------------------------------------------------
! IN  MAT    ADRESSE DU MATERIAU
! IN  FAMI   FAMILLE DE POINTS D'INTEGRATION (SI 'NONE', PAS DE TEMP.)
! IN  KPG    NUMERO DU POINT D'INTEGRATION
! IN  KSP    NUMERO DU SOUS-POINT
! IN  POUM   LECTURE DES PARAMETRES EN DEBUT '-' OU FIN '+' DU PAS
! IN  LCCRMA ROUTINE POUR LECTURE DES PARAMETRES DU CRITERE
! ----------------------------------------------------------------------
    integer :: nbel, nbnl
    parameter (nbel=2,nbnl=2)
    integer :: iok(nbel+nbnl),idum
    real(kind=8) :: valel(nbel), valnl(nbnl), alpha, temp, tref,rdum(1)
    real(kind=8) :: e, nu
    character(len=16),parameter,dimension(nbel) :: nomel=(/'E               ','NU              '/)
    character(len=16),parameter,dimension(nbnl) :: nomnl=(/'C_GRAD_VARI     ','PENA_LAGR       '/)
    character(len=8) :: nomdum(1)
! ----------------------------------------------------------------------
    real(kind=8) :: lambda, deuxmu, troisk, gamma, rigmin, pc, pr, epsth
    common /lcee/ lambda,deuxmu,troisk,gamma,rigmin,pc,pr,epsth
! ----------------------------------------------------------------------
!
! - LECTURE DES PARAMETRES MECANIQUES
!
    call rcvalb(fami,kpg,ksp,poum,mat,' ','ELAS'     ,0,nomdum,rdum,nbel,nomel,valel,iok,2)
    call rcvalb(fami,kpg,ksp,poum,mat,' ','NON_LOCAL',0,nomdum,rdum,nbnl,nomnl,valnl,iok,2)

    e      = valel(1)
    nu     = valel(2)
    lambda = e*nu / (1-2*nu) / (1+nu)
    deuxmu = e / (1+nu)
    troisk = e / (1-2*nu)
    gamma  = 0.d0
    pc     = valnl(1)
    pr     = valnl(2)

    call lccrma(mat, fami, kpg, ksp, poum)

!
! - LECTURE DES PARAMETRES THERMIQUES
!
    if (fami.eq.'NONE') then
        epsth = 0.d0
        goto 999
    endif

    call rcvalb(fami, kpg, ksp, poum, mat, ' ', 'ELAS', 0, nomdum, rdum, 1, 'ALPHA', valel, iok, 0)
    alpha = valel(1)
!
    if (iok(1) .eq. 0) then
        call rcvarc('F', 'TEMP', 'REF', fami, kpg, ksp, tref, idum)
        call rcvarc('F', 'TEMP', poum , fami, kpg, ksp, temp, idum)
        epsth = alpha*(temp-tref)
    else
        epsth = 0
    endif
!
999 continue
end subroutine
