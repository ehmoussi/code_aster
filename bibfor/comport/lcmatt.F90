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

subroutine lcmatt(fami, kpg, ksp, mod, imat,&
                  nmat, poum, rela_comp, coefel, coefpl,&
                  typma, ndt, ndi, nr, nvi)
    implicit none
!     ROUTINE GENERIQUE DE RECUPERATION DU MATERIAU A T ET T+DT
!     ----------------------------------------------------------------
!     IN  FAMI   :  FAMILLE DE POINT DE GAUSS (RIGI,MASS,...)
!         KPG,KSP:  NUMERO DU (SOUS)POINT DE GAUSS
!         MOD    :  TYPE DE MODELISATION
!         IMAT   :  ADRESSE DU MATERIAU CODE
!         NMAT   :  DIMENSION  DE MATER
!         POUM   :  '+' ou '-'
!     OUT        :  COEFFICIENTS MATERIAU A T- OU T+
!         COEFEL :  CARACTERISTIQUES ELASTIQUES
!         COEFPL :  CARACTERISTIQUES PLASTIQUES
!         TYPMA  :  TYPE DE MATRICE TANGENTE
!         NDT    :  NB TOTAL DE COMPOSANTES TENSEURS
!         NDI    :  NB DE COMPOSANTES DIRECTES  TENSEURS
!         NR     :  NB DE COMPOSANTES SYSTEME NL
!         NVI    :  NB DE VARIABLES INTERNES
!     ----------------------------------------------------------------
#include "asterfort/assert.h"
#include "asterfort/matnor.h"
    integer :: kpg, ksp, nmat, ndt, ndi, nr, nvi, imat
    real(kind=8) :: coefel(nmat), coefpl(nmat)
    character(len=*) :: fami, poum
    character(len=16) :: rela_comp
    character(len=8) :: mod, typma
    character(len=11) :: meting
    common /meti/   meting
!     ----------------------------------------------------------------
!
! -   NB DE COMPOSANTES DES TENSEURS
!
    if (meting(1:11) .eq. 'RUNGE_KUTTA') then
        ndt = 6
    else if (mod(1:2).eq.'3D') then
        ndt = 6
    else if (mod(1:6).eq.'D_PLAN'.or.mod(1:4).eq.'AXIS') then
        ndt = 4
    else if (mod(1:6).eq.'C_PLAN') then
        ndt = 4
    else
        ASSERT(.false.)
    endif
    ndi = 3
    typma = 'COHERENT'
!
    if (rela_comp .eq. 'NORTON') then
        call matnor(fami, kpg, ksp, imat, nmat,&
                    poum, coefel, coefpl, ndt, nvi,&
                    nr)
    else
        ASSERT(.false.)
    endif
!
end subroutine
