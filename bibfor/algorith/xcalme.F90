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
! person_in_charge: daniele.colombo at ifpen.fr
!
subroutine xcalme(option, meca, ndim, dimenr,&
                  dimcon, addeme, adcome, congep,&
                  dsde, deps, angl_naut)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterfort/tecael.h"
#include "asterfort/thmTherElas.h"
! **********************************************************************
! ROUTINE CALC_MECA
! CALCULE LES CONTRAINTES GENERALISEES ET LA MATRICE TANGENTE MECANIQUES
! ======================================================================
!
    real(kind=8), intent(in) :: angl_naut(3)

    integer :: ndim, dimenr, dimcon, addeme
    integer :: adcome
    real(kind=8) :: congep(dimcon)
    real(kind=8) :: dsde(dimcon, dimenr), rac2
    character(len=16) :: option, meca
! ======================================================================
! --- VARIABLES LOCALES ------------------------------------------------
! ======================================================================
    integer :: i, j
    real(kind=8) :: deps(6)
    real(kind=8) :: depstr(6)
    real(kind=8) :: mdal(6), dalal
    character(len=8) :: fami, poum
    integer :: spt, kpg
!
! - Initializations
!
    fami = 'XFEM'
    kpg  = 1
    spt  = 1
    poum = '+'
    rac2 = sqrt(2.0d0)

    if ((meca.eq.'ELAS')) then
!
!   DANS LE CAS ELASTIQUE ON REPASSE AUX CONTRAINTES RELLES POUR APPLIQU
!  LA MATRICE DE ROTATION DANS LE CAS ANISOTROPE
!
        depstr = deps
!
        do i = 4, 6
            depstr(i) = deps(i)*rac2
            congep(adcome+i-1)= congep(adcome+i-1)/rac2
         end do
!
! ----- Compute thermic quantities
!
        call thmTherElas(angl_naut, mdal, dalal)
!
        if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9) .eq.'FULL_MECA')) then
            do i = 1, 3
                do j = 1, 3
                    dsde(adcome-1+i,addeme+ndim-1+j) = dsde(adcome-1+i,addeme+ndim-1+j)+&
                                                       ds_thm%ds_material%elas%d(i,j)
                end do
                do j = 4, 6
                    dsde(adcome-1+i,addeme+ndim-1+j) = dsde(adcome-1+i,addeme+ndim-1+j)+&
                                                       ds_thm%ds_material%elas%d(i,j)*rac2
               end do
            end do
!
            do i = 4, 6
                do j = 1, 3
                    dsde(adcome-1+i,addeme+ndim-1+j) = dsde(adcome-1+i,addeme+ndim-1+j)+&
                                                       ds_thm%ds_material%elas%d(i,j)*rac2
                 end do
                do j = 4, 6
                    dsde(adcome-1+i,addeme+ndim-1+j) = dsde(adcome-1+i,addeme+ndim-1+j)+&
                                                       ds_thm%ds_material%elas%d(i,j)*2.d0
                 end do
             end do
        endif
!
!
        if ((option(1:9).eq.'RAPH_MECA') .or. (option(1:9) .eq.'FULL_MECA')) then
            do i = 1, 6
                do j = 1, 6
                    congep(adcome+i-1) = congep(adcome+i-1)+&
                                         ds_thm%ds_material%elas%d(i,j)*depstr(j)
                 end do
            end do
        endif
!
        do i = 4, 6
            congep(adcome+i-1)= congep(adcome+i-1)*rac2
         end do
!
    endif
! ======================================================================
end subroutine
