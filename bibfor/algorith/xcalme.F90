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
subroutine xcalme(option, meca, imate, ndim, dimenr,&
                  dimcon, addeme, adcome, congep,&
                  dsde, deps, t,&
                  ang2, aniso)
!
! **********************************************************************
! ROUTINE CALC_MECA
! CALCULE LES CONTRAINTES GENERALISEES ET LA MATRICE TANGENTE MECANIQUES
! ======================================================================
    implicit none
#   include "asterfort/rcvalb.h"
#   include "asterfort/calela.h"
#   include "asterfort/tecael.h"
    integer :: ndim, dimenr, dimcon, addeme
    integer :: adcome, imate
    real(kind=8) :: congep(dimcon)
    real(kind=8) :: dsde(dimcon, dimenr), rac2
    character(len=16) :: option, meca
! ======================================================================
! --- VARIABLES LOCALES ------------------------------------------------
! ======================================================================
    integer :: i, j, nelas, nresma, aniso
    real(kind=8) :: deps(6), t
    real(kind=8) :: young, nu, alpha0
    parameter     (nelas = 4  )
    parameter     (nresma = 18)
    real(kind=8) :: elas(nelas), ang2(3), depstr(6)
    real(kind=8) :: d(6, 6), mdal(6), dalal
    character(len=8) :: ncra1(nelas), fami, poum
    integer :: icodre(nresma)
    integer :: spt, kpg
!
    data ncra1 / 'E','NU','ALPHA','RHO' /
! ======================================================================
! --- RECUPERATION DES DONNEES MATERIAU DANS DEFI_MATERIAU -------------
! ======================================================================
    fami='XFEM'
    kpg=1
    spt=1
    poum='+'
!
    rac2 = sqrt(2.0d0)
!
    call rcvalb(fami, kpg, spt, poum, imate,&
                ' ', 'ELAS', 1, 'TEMP', [t],&
                3, ncra1(1), elas(1), icodre, 0)
    young = elas(1)
    nu = elas(2)
    alpha0 = elas(3)
! ======================================================================
! --- CALCUL DES CONTRAINTES -------------------------------------------
! ======================================================================
! --- LOI ELASTIQUE ----------------------------------------------------
! ======================================================================
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
!    CALCUL DE LA MATRICE DE HOOK DANS LE REPERE GLOBAL
!
        call calela(ang2, mdal, dalal, aniso, d)
!
        if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9) .eq.'FULL_MECA')) then
            do i = 1, 3
                do j = 1, 3
                    dsde(adcome-1+i,addeme+ndim-1+j)= dsde(adcome-1+i,&
                    addeme+ndim-1+j) +d(i,j)
                end do
                do j = 4, 6
                    dsde(adcome-1+i,addeme+ndim-1+j)= dsde(adcome-1+i,&
                    addeme+ndim-1+j)+d(i,j)*rac2
               end do
            end do
!
            do i = 4, 6
                do j = 1, 3
                    dsde(adcome-1+i,addeme+ndim-1+j)= dsde(adcome-1+i,&
                    addeme+ndim-1+j)+d(i,j)*rac2
                 end do
                do j = 4, 6
                    dsde(adcome-1+i,addeme+ndim-1+j)= dsde(adcome-1+i,&
                    addeme+ndim-1+j)+d(i,j)*2.d0
                 end do
             end do
        endif
!
!
        if ((option(1:9).eq.'RAPH_MECA') .or. (option(1:9) .eq.'FULL_MECA')) then
            do i = 1, 6
                do j = 1, 6
                    congep(adcome+i-1)=congep(adcome+i-1)+d(i,j)*&
                    depstr(j)
                 end do
            end do
        endif
!
!   ON REVIENT AUX CONTRAINTES * RAC2
!
        do i = 4, 6
            congep(adcome+i-1)= congep(adcome+i-1)*rac2
         end do
!
    endif
! ======================================================================
end subroutine
