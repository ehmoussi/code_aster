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
! aslint: disable=W1504
! person_in_charge: daniele.colombo at ifpen.fr
!
subroutine xequhm(imate, option, ta, ta1, ndim,&
                  kpi, npg, dimenr,&
                  enrmec, dimdef, dimcon, nbvari, defgem,&
                  congem, vintm, defgep, congep, vintp,&
                  mecani, press1, press2, tempe,&
                  rinstp, dt, r, drds,&
                  dsde, retcom, angmas, enrhyd, nfh)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterfort/xcomhm.h"
#include "asterfort/vecini.h"
!
!     BUT:  CALCUL DES OPTIONS RIGI_MECA_TANG, RAPH_MECA ET FULL_MECA
!           EN HM AVEC LA METHODE XFEM
!.......................................................................
! IN  NDIM    : DIMENSION DE L'ESPACE
! IN  OPTION  : OPTION DE CALCUL
! IN  DIMDEF  : DIMENSION DU TABLEAU DES DEFORMATIONS GENERALISEES
!               AU POINT DE GAUSS
! IN  DIMCON  : DIMENSION DU TABLEAU DES CONTRAINTES GENERALISEES
!               AU POINT DE GAUSS
! IN  NBVARI  : NOMBRE TOTAL DE VARIABLES INTERNES "MECANIQUES"
! IN  DEFGEP  : TABLEAU DES DEFORMATIONS GENERALISEES
!               AU POINT DE GAUSS AU TEMPS PLUS
! IN  DEFGEM  : TABLEAU DES DEFORMATIONS GENERALISEES
!               AU POINT DE GAUSS AU TEMPS MOINS
!             : EPSXY = (DV/DX+DU/DY)/SQRT(2)
! IN  CONGEM  : TABLEAU DES CONTRAINTES GENERALISEES
!               AU POINT DE GAUSS AU TEMPS MOINS
! IN  VINTM   : TABLEAU DES VARIABLES INTERNES (MECANIQUES ET
!               HYDRAULIQUES)AU POINT DE GAUSS AU TEMPS MOINS
! IN  NFH     : NOMBRE DE DDL HEAVISIDE PAR NOEUD
! OUT CONGEP  : TABLEAU DES CONTRAINTES GENERALISEES
!               AU POINT DE GAUSS AU TEMPS PLUS
!             : SIGXY = LE VRAI
! OUT VINTP   : TABLEAU DES VARIABLES INTERNES (MECANIQUES ET HYDRAULIQU
!               AU POINT DE GAUSS AU TEMPS PLUS
! OUT R       : TABLEAU DES RESIDUS
! OUT DRDE    : TABLEAU DE LA MATRICE TANGENTE AU POINT DE GAUSS
! OUT         : RETCOM RETOUR DES LOIS DE COMPORTEMENT
! ======================================================================

    integer :: imate, ndim, nbvari, kpi, npg, dimdef, dimcon, retcom
    integer :: mecani(5), press1(7), press2(7), tempe(5)
    integer :: addeme, adcome, addete, i, j
    integer :: nbpha1, addep1, adcp11, nfh
    integer :: nbpha2, addep2
    real(kind=8) :: defgem(dimdef), defgep(dimdef), congem(dimcon)
    real(kind=8) :: congep(dimcon), vintm(nbvari), vintp(nbvari)
    real(kind=8) :: pesa(3), dt, rinstp
    real(kind=8) :: deux, rac2, ta, ta1
    real(kind=8) :: angmas(3)
    parameter    (deux = 2.d0)
    character(len=16) :: option
!
! DECLARATIONS POUR XFEM
    integer :: dimenr, enrmec(3), enrhyd(3)
    integer :: yaenrm, adenme
    integer :: yaenrh, adenhy, ifh
    real(kind=8) :: r(dimenr), drds(dimenr, dimcon)
    real(kind=8) :: dsde(dimcon, dimenr)
! ======================================================================
! --- INITIALISATIONS DES VARIABLES DEFINISSANT LE PROBLEME ------------
! ======================================================================
    rac2 = sqrt(deux)
    addeme = mecani(2)
    adcome = mecani(3)
    nbpha1 = press1(2)
    addep1 = press1(3)
    adcp11 = press1(4)
    nbpha2 = press2(2)
    addep2 = press2(3)
    addete = tempe(2)
!
    yaenrm = enrmec(1)
    adenme = enrmec(2)
    yaenrh = enrhyd(1)
    adenhy = enrhyd(2)
!
    call vecini(3, 0.d0, pesa)
!
! ============================================================
! --- COMME CONGEM CONTIENT LES VRAIES CONTRAINTES ET --------
! --- COMME PAR LA SUITE ON TRAVAILLE AVEC SQRT(2)*SXY -------
! --- ON COMMENCE PAR MODIFIER LES CONGEM EN CONSEQUENCE -----
! ============================================================
    if (ds_thm%ds_elem%l_dof_meca) then
        do i = 4, 6
            congem(adcome+i-1)= congem(adcome+i-1)*rac2
            congem(adcome+6+i-1)= congem(adcome+6+i-1)*rac2
        end do
    endif
! ============================================================
! --- INITIALISATION DES TABLEAUX A ZERO ---------------------
! --- ET DU TABLEAU CONGEP A CONGEM --------------------------
! ============================================================
    if ((option .eq.'RAPH_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        do i = 1, dimcon
            congep(i)=congem(i)
        end do
    endif
!
    do i = 1, dimenr
        do j = 1, dimcon
            drds(i,j)=0.d0
            dsde(j,i)=0.d0
        end do
        r(i)=0.d0
    end do
!
    retcom = 0
!
    call xcomhm(option, imate, rinstp, &
                ndim, dimdef, dimcon, nbvari, &
                addeme, adcome, addep1, adcp11,&
                addep2, addete, defgem, &
                defgep, congem, congep, vintm,&
                vintp, dsde, pesa, retcom, kpi,&
                npg, dimenr,&
                angmas, yaenrh, adenhy, nfh)
!
    if (retcom .ne. 0) then
        goto 99
    endif
! ======================================================================
! --- CALCUL DE LA CONTRAINTE VIRTUELLE R ------------------------------
! ======================================================================
    if ((option(1:9).eq.'FULL_MECA') .or. (option(1:9).eq.'RAPH_MECA')) then
! ======================================================================
! --- SI PRESENCE DE MECANIQUE -----------------------------------------
! ======================================================================
        if (ds_thm%ds_elem%l_dof_meca) then
            do i = 1, 6
                r(addeme+ndim+i-1) = r(addeme+ndim+i-1) +congep(adcome-1+i)
            end do
!
            do i = 1, 6
                r(addeme+ndim-1+i) = r(addeme+ndim-1+i)+congep(adcome+6+i-1)
            end do
!
            if (ds_thm%ds_elem%l_dof_pre1) then
                do i = 1, ndim
                    r(addeme+i-1) = r(addeme+i-1) - pesa(i)*congep(adcp11)
                end do
            endif
        endif
! ======================================================================
! --- SI PRESENCE DE PRESS1 --------------------------------------------
! ======================================================================
        if (ds_thm%ds_elem%l_dof_pre1) then
!
            r(addep1)=r(addep1)-congep(adcp11)+congem(adcp11)
!
            do i = 1, ndim
                r(addep1+i)=r(addep1+i) +dt*(ta*congep(adcp11+i)+ta1* congem(adcp11+i))
            end do
        endif
! ======================================================================
! --- SI PRESENCE DE MECANIQUE AVEC XFEM -------------------------------
! ======================================================================
        if (yaenrm .eq. 1) then
            if (ds_thm%ds_elem%l_dof_meca) then
                if (ds_thm%ds_elem%l_dof_pre1) then
                    do ifh = 1, nfh
                        do i = 1, ndim
                            r(adenme+i-1+(ifh-1)*(ndim+1))=&
                                r(adenme+i-1+(ifh-1)*(ndim+1))-pesa(i)*congep(adcp11)
                        end do
                    end do
                endif
            endif
        endif
! ======================================================================
! --- SI PRESENCE DE PRESS1 AVEC XFEM ----------------------------------
! ======================================================================
         if(yaenrh.eq.1) then
            if(ds_thm%ds_elem%l_dof_pre1) then
               do ifh = 1, nfh
                  r(adenhy+(ifh-1)*(ndim+1))=&
                        r(adenhy+(ifh-1)*(ndim+1))-congep(adcp11)+congem(adcp11)
               end do
            endif
         endif
    endif
! ======================================================================
! --- CALCUL DES MATRICES DERIVEES CONSTITUTIVES DE DF -----------------
! ======================================================================
    if ((option(1:9) .eq. 'RIGI_MECA') .or. (option(1:9) .eq. 'FULL_MECA')) then
! ======================================================================
! --- SI PRESENCE DE MECANIQUE -----------------------------------------
! ======================================================================
        if (ds_thm%ds_elem%l_dof_meca) then
            do i = 1, 6
                drds(addeme+ndim-1+i,adcome+i-1)= drds(addeme+ndim-1+i,adcome+i-1)+1.d0
            end do
!
            do i = 1, 6
                drds(addeme+ndim-1+i,adcome+6+i-1)= drds(addeme+ndim-1+i,adcome+6+i-1)+1.d0
            end do
        endif
! ======================================================================
! --- SI PRESENCE DE PRESS1 --------------------------------------------
! ======================================================================
        if (ds_thm%ds_elem%l_dof_pre1) then
            if (ds_thm%ds_elem%l_dof_meca) then
                do i = 1, ndim
                    drds(addeme+i-1,adcp11)= drds(addeme+i-1,adcp11)-pesa(i)
                end do
            endif
!
            drds(addep1,adcp11)=drds(addep1,adcp11)-1.d0
!
            do i = 1, ndim
                drds(addep1+i,adcp11+i)=drds(addep1+i,adcp11+i)+ta*dt
            end do
        endif
! ======================================================================
! --- SI PRESENCE DE PRESS1 AVEC XFEM ----------------------------------
! ======================================================================
        if ((ds_thm%ds_elem%l_dof_pre1).and.(yaenrh.eq.1)) then
            do ifh = 1, nfh
                if ((ds_thm%ds_elem%l_dof_meca).and.(yaenrm.eq.1)) then
                    do i = 1, ndim
                        drds(adenme+i-1+(ifh-1)*(ndim+1),adcp11)=&
                            drds(adenme +i-1+(ifh-1)*(ndim+1),adcp11)-pesa(i)
                    end do
                endif
                drds(adenhy+(ifh-1)*(ndim+1),adcp11)=&
                        drds(adenhy+(ifh-1)*(ndim+1),adcp11)-1.d0
            end do
        endif
    endif
! ======================================================================
! --- FIN DU CALCUL DE DF ----------------------------------------------
! ======================================================================
! --- COMME CONGEP DOIT FINALEMENT CONTENIR LES VRAIES CONTRAINTES -----
! --- ET COMME  ON A TRAVAILLE AVEC SQRT(2)*SXY ------------------------
! --- ON MODIFIE LES CONGEP EN CONSEQUENCE -----------------------------
! ======================================================================
    if ((ds_thm%ds_elem%l_dof_meca) .and.&
        ((option .eq.'RAPH_MECA') .or. (option(1:9).eq.'FULL_MECA'))) then
        do i = 4, 6
            congep(adcome+i-1)= congep(adcome+i-1)/rac2
            congep(adcome+6+i-1)= congep(adcome+6+i-1)/rac2
            congem(adcome+i-1)= congem(adcome+i-1)/rac2
            congem(adcome+6+i-1)= congem(adcome+6+i-1)/rac2
        end do
    endif
! ======================================================================
99  continue
! ======================================================================
end subroutine
