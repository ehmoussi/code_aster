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

subroutine nmtama(fami, kpg, ksp, imate, instam,&
                  instap, matm, mat)
!
    implicit none
!
#include "asterf_types.h"
#include "asterfort/rcvalb.h"
#include "asterfort/utmess.h"
    integer :: kpg, ksp, imate
    character(len=*) :: fami
    real(kind=8) :: instam, instap, matm(3), mat(14)
!
! ----------------------------------------------------------------------
! TAHERI :  LECTURE DES CARACTERISTIQUES DU MATERIAU
! ----------------------------------------------------------------------
! IN   FAMI  FAMILLE DU POINT DE GAUSS
! IN  KPG    POINT DE GAUSS
! IN   KSP   SOUS-POINT DE GAUSS
! IN  IMATE  ADRESSE DU MATERIAU CODE
! IN  INSTAM INSTANT -
! IN  INSTAP INSTANT +
! OUT MATM   CARACTERISTIQUES (ELASTIQUES) EN T-
! OUT MAT    CARACTERISTIQUES (ELASTIQUES, PLASTIQUES, VISQUEUSES) EN T+
!             1 = TROISK            (ELASTICITE)
!             2 = DEUXMU            (ELASTICITE)
!             3 = ALPHA             (THERMIQUE)
!             4 = R_0               (ECROUISSAGE)
!             5 = ALPHA             (ECROUISSAGE)
!             6 = M                 (ECROUISSAGE)
!             7 = A                 (ECROUISSAGE)
!             8 = B                 (ECROUISSAGE)
!             9 = C1                (ECROUISSAGE)
!            10 = C_INF             (ECROUISSAGE)
!            11 = S                 (ECROUISSAGE)
!            12 = 1/N               (VISCOSITE)
!            13 = K/(DT)**1/N       (VISCOSITE)
!            14 = UN_SUR_M          (VISCOSITE)
! ----------------------------------------------------------------------
!
    aster_logical :: visco
    character(len=8) :: nom(14)
    integer :: ok(14)
    real(kind=8) :: e, nu
!
    data nom / 'E','NU','ALPHA',&
     &           'R_0','ALPHA','M','A','B','C1','C_INF','S',&
     &           'N','UN_SUR_K','UN_SUR_M' /
!
!
! - LECTURE DES CARACTERISTIQUES ELASTIQUES DU MATERIAU (T- ET T+)
!
    call rcvalb(fami, kpg, ksp, '-', imate,&
                ' ', 'ELAS', 0, ' ', [0.d0],&
                2, nom(1), matm(1), ok(1), 2)
    call rcvalb(fami, kpg, ksp, '-', imate,&
                ' ', 'ELAS', 0, ' ', [0.d0],&
                1, nom(3), matm(3), ok(3), 0)
    if (ok(3) .ne. 0) matm(3) = 0.d0
    e = matm(1)
    nu = matm(2)
    matm(1) = e/(1.d0-2.d0*nu)
    matm(2) = e/(1.d0+nu)
!
    call rcvalb(fami, kpg, ksp, '+', imate,&
                ' ', 'ELAS', 0, ' ', [0.d0],&
                2, nom(1), mat(1), ok(1), 2)
    call rcvalb(fami, kpg, ksp, '+', imate,&
                ' ', 'ELAS', 0, ' ', [0.d0],&
                1, nom(3), mat(3), ok(3), 0)
    if (ok(3) .ne. 0) mat(3) = 0.d0
    e = mat(1)
    nu = mat(2)
    mat(1) = e/(1.d0-2.d0*nu)
    mat(2) = e/(1.d0+nu)
!
!
! - LECTURE DES CARACTERISTIQUES D'ECROUISSAGE (T+)
    call rcvalb(fami, kpg, ksp, '+', imate,&
                ' ', 'TAHERI', 0, ' ', [0.d0],&
                8, nom(4), mat(4), ok(4), 2)
    mat(7) = mat(7) * (2.d0/3.d0)**mat(5)
!
! LECTURE DES CARACTERISTIQUES DE VISCOSITE (TEMPS +)
    call rcvalb(fami, kpg, ksp, '+', imate,&
                ' ', 'LEMAITRE', 0, ' ', [0.d0],&
                3, nom(12), mat(12), ok(12), 0)
    visco = ok(12).eq.0
!
    if (visco) then
        if (mat(12) .eq. 0.d0) then
            call utmess('F', 'ALGORITH8_32')
        endif
        mat(12) = 1.d0 / mat(12)
!
        if (mat(13) .eq. 0.d0) then
            call utmess('F', 'ALGORITH8_33')
        endif
        mat(13) = 1.d0 / mat(13) / (instap-instam)**mat(12)
!
        if (ok(14) .ne. 0) mat(14) = 0.d0
!
    else
        mat(12) = 1.d0
        mat(13) = 0.d0
        mat(14) = 1.d0
    endif
!
!
end subroutine
