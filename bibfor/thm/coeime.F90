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
! aslint: disable=W1504,W1306
!
subroutine coeime(j_mater, nomail, option, l_resi,&
                  l_matr, ndim, dimdef, dimcon,&
                  addeme, addep1,&
                  nbvari, npg, npi,&
                  defgep, defgem, sigm, sigp, varim,&
                  varip, ouvh, tlint, drde, kpi,&
                  retcom)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/lcejex.h"
#include "asterfort/lcejli.h"
#include "asterfort/lcjohm.h"
#include "asterfort/rcvalb.h"
!
integer, intent(in) :: j_mater
character(len=8), intent(in) :: nomail
character(len=16), intent(in) :: option
aster_logical, intent(in) :: l_resi, l_matr
integer, intent(in) :: ndim, dimcon, dimdef
integer, intent(in) :: addeme, addep1, npg, kpi, npi, nbvari
real(kind=8), intent(in) :: defgem(dimdef), defgep(dimdef)
real(kind=8), intent(in) :: sigm(dimcon)
real(kind=8), intent(inout) :: sigp(dimcon)
real(kind=8), intent(in) :: varim(nbvari)
real(kind=8), intent(inout) :: varip(nbvari)
real(kind=8), intent(out) :: ouvh, tlint
real(kind=8), intent(inout) :: drde(dimdef, dimdef)
integer, intent(out) :: retcom
!
! --------------------------------------------------------------------------------------------------
!
!  INTEGRATION DE LA LOI DE COMPORTEMENT MECANIQUE ET RENVOI DE LA LOI CUBIQUE
!
! --------------------------------------------------------------------------------------------------
!
! IN MECA   : COMPORTEMENT MECA
! IN IMATE  : CODE MATERIAU
! IN RESI   : FULL_MECA OU RAPH_MECA
! IN RIGI   : FULL_MECA OU RIGI_MECA
! IN NDIM   : DIMENSION ESPACE
! IN DIMDEF : DIMENSION DEFORMATION GENERALISEE
! IN DIMCON : DIMENSION VECTEUR CONTRAINTES GENERALISEES
! IN ADDEME : ADRESSE DES DEFORMATIONS MECANIQUES
! IN ADDEP1 : ADRESSE DES DEFORMATIONS PRESSION 1
! IN NBVARI : NOMBRE DE VARIABLES INTERNES
! IN ADVIME : ADRESSE DES VI MECANIQUES
! IN ADVICO : ADRESSE DES VI DE COUPLAGE
! IN NPG    : NOMBRE DE POINTS DE GAUSS
! IN DEFGEP : DEFORMATIONS AU TEMPS PLUS
! IN DERGEM : DEFORMATIONS AU TEMPS MOINS
! IN SIGM   : CONTRAINTES AU TEMPS MOINS
! IN VARIM  : VARIABLES INTERNES AU TEMPS MOINS
! IN KPI    : POINT D'INTEGRATION
! =====================================================================
! OUT SIGP  : CONTRAINTES AU TEMPS PLUS
! OUT VARIP : VARIABLES INTERNES AU TEMPS PLUS
! OUT OUVH  : OUVERTURE NORMALE DU JOINT
! OUT TLINT : PERMEABILITE LONGITUDINALE
! OUT DRDE  : MATRICE DE RIGIDITE
! OUT RETCOM : RETOUR LOI DE COMPORTEMENT
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i, j, kpg, spt
    real(kind=8) :: da(ndim), dsidep(6, 6), para(2), ouvfic, unsurn
    character(len=8) :: fami, poum
    integer :: icodre(2)
    character(len=16) :: meca
    integer :: advime, advico, vicphi
    character(len=8), parameter :: ncra(2) = (/'OUV_FICT','UN_SUR_N' /)
!
! --------------------------------------------------------------------------------------------------
!
    ouvh   = 0.d0
    tlint  = 0.d0
    fami   = 'FPG1'
    kpg    = 1
    spt    = 1
    poum   = '+'
    meca   = ds_thm%ds_behaviour%rela_meca
    advime = ds_thm%ds_behaviour%advime
    advico = ds_thm%ds_behaviour%advico
    vicphi = ds_thm%ds_behaviour%vicphi
!
! ====================================================================
! LOI DE COMPORTEMENT JOINT_BANDIS
! ====================================================================
!
    if (meca .eq. 'JOINT_BANDIS') then
!
        call lcjohm(j_mater, l_resi, l_matr, kpi, npg,&
                    nomail, addeme, advico, ndim, dimdef,&
                    dimcon, nbvari, defgem, defgep, varim,&
                    varip, sigm, sigp, drde, ouvh,&
                    retcom)
!
        tlint = ouvh**2/12.d0
        if (l_resi) then
            varip(advime)=tlint
            if (ds_thm%ds_elem%l_dof_pre1) then
                sigp(1+ndim)=-defgep(addep1)
            endif
        endif
        if ((l_matr) .and. (kpi .le. npg)) then
            if (ds_thm%ds_elem%l_dof_pre1) then
                drde(addeme,addep1)=-1.d0
            endif
        endif
    endif
!
! ====================================================================
! LOI DE COMPORTEMENT CZM_LIN_REG
! ====================================================================
    if (meca .eq. 'CZM_LIN_REG') then
!
        do i = 1, ndim
            da(i) = defgep(i) - defgem(i)
        end do
!
! - INTEGRATION DE LA LOI DE COMPORTEMENT MECANIQUE
!
        call lcejli('RIGI', kpi, 1, ndim, j_mater,&
                    option, defgem, da, sigp, dsidep,&
                    varim(advime), varip(advime))
!
! - RECUPERATION DES PARAMETRES DE COUPLAGE POUR LA POINTE DE FISSURE
!
        if (nint(varip(advime)) .eq. 2) then
            unsurn=0.d0
        else
            call rcvalb(fami, kpg, spt, poum, j_mater,&
                        ' ', 'THM_RUPT', 0, ' ', [0.d0],&
                        2, ncra(1), para(1), icodre, 1)
            ouvfic = para(1)
            unsurn = para(2)
        endif
!
! - CALCUL DES TERMES MECA ET DE COUPLAGE DE L'OPERATEUR TANGENT
!
        if (l_matr) then
            if (kpi .le. npg) then
                do i = 1, ndim
                    do j = 1, ndim
                        drde(i,j)=dsidep(i,j)
                    end do
                end do
                if ((ds_thm%ds_elem%l_dof_pre1) .and.&
                    ((nint(varip(advime+2)) .eq. 1) .or.(nint(varip(advime+2)).eq. 2) )) then
                    drde(1,addep1)=-1.d0
                endif
            endif
            if ((kpi .gt. npg) .or. (npi .eq. npg)) then
                drde(addep1,addep1)=drde(addep1,addep1)-unsurn
            endif
! - CALCUL DE L'OUVERTURE HYDRO ET DE LA PERMEABILITE
            ouvh=varim(advico+vicphi)
            if (nint(varim(3)) .eq. 0) then
                ouvh=ouvfic
            endif
            tlint=ouvh**2/12
        endif
!
! - CALCUL DES TERMES MECA ET DE COUPLAGE DU VECTEUR FORCES INTERNES
!
        if (l_resi) then
            if ((ds_thm%ds_elem%l_dof_pre1) .and.&
                 ((nint(varip(advime+2)) .eq. 1) .or.( nint(varip(advime+2)).eq. 2))) then
                sigp(1+ndim)=-defgep(addep1)
            endif
! - CALCUL DE L'OUVERTURE HYDRO ET DE LA PERMEABILITE
            varip(advico+vicphi)=defgep(1)
            ouvh=varip(advico+vicphi)
! - SI FISSURE FERMEE ALORS ON DONNE UNE OUVERTURE HYDRO FICTIVE
            if ((nint(varip(3)).eq.0)) then
                ouvh=ouvfic
            endif
            tlint=ouvh**2/12
            varip(advico+vicphi)=defgep(1)+defgep(addep1)*unsurn
        endif
    endif
!
! ====================================================================
! LOI DE COMPORTEMENT CZM_EXP_REG
! ====================================================================
!
    if (meca .eq. 'CZM_EXP_REG') then
        do i = 1, ndim
            da(i) = defgep(i) - defgem(i)
        end do
!
! - INTEGRATION DE LA LOI DE COMPORTEMENT MECANIQUE
!
        call lcejex('RIGI', kpi, 1, ndim, j_mater,&
                    option, defgem, da, sigp, dsidep,&
                    varim(advime), varip(advime))
!
! - RECUPERATION DES PARAMETRES DE COUPLAGE POUR LA POINTE DE FISSURE
!
        call rcvalb(fami, kpg, spt, poum, j_mater,&
                    ' ', 'THM_RUPT', 0, ' ', [0.d0],&
                    2, ncra(1), para(1), icodre, 1)
        ouvfic = para(1)
        unsurn = para(2)
!
! - CALCUL DES TERMES MECA ET DE COUPLAGE DE L'OPERATEUR TANGENT
!
        if (l_matr) then
            if (kpi .le. npg) then
                do i = 1, ndim
                    do j = 1, ndim
                        drde(i,j)=dsidep(i,j)
                    end do
                end do
                if ((ds_thm%ds_elem%l_dof_pre1) .and. (nint(varip(advime+2)) .eq. 1)) then
                    drde(1,addep1)=-1.d0
                endif
            endif
            if ((kpi .gt. npg) .or. (npi .eq. npg)) then
                drde(addep1,addep1)=drde(addep1,addep1)-unsurn
            endif
! - CALCUL DE L'OUVERTURE HYDRO ET DE LA PERMEABILITE
            ouvh=varim(advico+vicphi)
            if (nint(varim(3)) .eq. 0) then
                ouvh=ouvfic
            endif
            tlint=ouvh**2/12
        endif
!
! - CALCUL DES TERMES MECA ET DE COUPLAGE DU VECTEUR FORCES INTERNES
!
        if (l_resi) then
            if ((ds_thm%ds_elem%l_dof_pre1) .and. (nint(varip(advime+2)) .eq. 1)) then
                sigp(1+ndim)=-defgep(addep1)
            endif
! - CALCUL DE L'OUVERTURE HYDRO ET DE LA PERMEABILITE
            varip(advico+vicphi)=defgep(1)
            ouvh=varip(advico+vicphi)
            if (nint(varip(3)) .eq. 0) then
! - SI FISSURE FERMEE ALORS ON DONNE UNE OUVERTURE HYDRO FICTIVE
                ouvh=ouvfic
            endif
            tlint=ouvh**2/12
            varip(advico+vicphi)=defgep(1)+defgep(addep1)*unsurn
        endif
    endif
!
end subroutine
