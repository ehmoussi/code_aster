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
!
subroutine fonoei(ndim, dt, fnoevo, dimdef, dimcon,&
                  addeme,&
                  addep1, addep2, addlh1, adcome,&
                  adcp11, &
                  adcop1, adcop2,congem,&
                  r)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
!
!    BUT : CALCUL DU TERME DE CHARGEMENT EXTERIEUR AUX POINTS
!    D'INTEGRATION
!
!
! ======================================================================
! IN NDIM  : DIMENSION ESPACE
! IN DT    : INCREMENT DE TEMPS
! IN FNOEVO : APPLE DEPUIS STAT_NON_LINE
! IN DIMDEF : DIMENSION DEFORMATIONS GENERALISEES
! IN DIMCON : DIMENSION VECTEUR CONTRAINTES GENERALISEES
! IN ADDEME : ADRESSE DES DEFORMATIONS MECANIQUES
! IN ADDEP1 : ADRESSE DES DEFORMATIONS CORRESPONDANT A LA PRESSION 1
! IN ADDEP2 : ADRESSE DES DEFORMATIONS CORRESPONDANT A LA PRESSION 2
! IN ADDETE : ADRESSE DES DEFORMATIONS THERMIQUES
! IN ADCOME : ADRESSE DES CONTRAINTES MECANIQUES
! IN ADCP11 : ADRESSE DES CONTRAINTES FLUIDE 1 PHASE 1
! IN ADCOP1 : ADRESSE DES CONTRAINTES CORRESPONDANT AU SAUT DE PRE1
! IN ADCOP2 : ADRESSE DES CONTRAINTES CORRESPONDANT AU SAUT DE PRE2
! IN CONGEM : CONTRAINTES GENERALISEES AU TEMPS MOINS
! ======================================================================
! OUT R : VECTEUR FORCES EXTERIEURES
! ======================================================================
    aster_logical :: fnoevo
    integer :: dimdef, dimcon
    integer :: ndim
    real(kind=8) :: dt, congem(dimcon), r(dimdef)
! ======================================================================
    integer :: addeme, adcome
    integer :: addep1, adcp11, addep2
    integer :: i, adcop1, adcop2, f, addlh1
!
! ======================================================================
! --- CALCUL DU RESIDU R -----------------------------------------------
! ======================================================================
! ======================================================================
! -------------------------------------
! ======================================================================
    do i = 1, ndim
        r(addeme+i-1)= r(addeme+i-1)+congem(adcome-1+i)
    end do
    r(addeme) = r(addeme) + congem(adcome+ndim)
    if (ds_thm%ds_elem%l_dof_pre1) then
        do f = 1, 2
            r(addlh1+1+f)=r(addlh1+1+f)+congem(adcop1+1+f)
        end do
    endif
    if (ds_thm%ds_elem%l_dof_pre2) then
        do f = 1, 2
            r(addep2+ndim+1+f)=r(addep1+ndim+1+f)+congem(adcop2+1+f)
        end do
    endif
!
    if (fnoevo) then
! ======================================================================
! --- TERMES DEPENDANT DE DT DANS FORC_NODA POUR STAT_NON_LINE ---------
! ======================================================================
        if (ds_thm%ds_elem%l_dof_pre1) then
            do f = 1, 2
                r(addep1) = r(addep1) + dt*congem(adcop1-1+f)
                r(addlh1-1+f) = -dt*congem(adcop1-1+f)
            end do
            do i = 1, ndim-1
                r(addep1+i) = dt*congem(adcp11+i)
            end do
        endif
    endif
!
end subroutine
