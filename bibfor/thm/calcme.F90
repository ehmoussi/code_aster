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
! person_in_charge: sylvie.granet at edf.fr
!
subroutine calcme(option, compor, thmc, meca, imate,&
                  typmod, carcri, instam, instap, &
                  ndim, dimdef, dimcon, nvimec, yate,&
                  addeme, adcome, addete, defgem, congem,&
                  congep, vintm, vintp, addep1, addep2,&
                  dsde, deps, p1, p2, &
                  dt, retcom, dp1, dp2, sat,&
                  tbiot, angl_naut)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/nmcomp.h"
#include "asterfort/dsipdp.h"
#include "asterfort/elagon.h"
#include "asterfort/lchbr2.h"
#include "asterfort/nmbarc.h"
#include "asterfort/utmess.h"
#include "asterfort/lcidbg.h"
#include "asterfort/thmTherElas.h"
#include "asterfort/thmGetParaBehaviour.h"
#include "asterfort/Behaviour_type.h"
#include "asterfort/thmCheckPorosity.h"
!
    real(kind=8), intent(in) :: angl_naut(3)


! **********************************************************************
! ROUTINE CALC_MECA
! CALCULE LES CONTRAINTES GENERALISEES ET LA MATRICE TANGENTE MECANIQUES
! **********************************************************************
!               CRIT    CRITERES  LOCAUX
!                       CRIT(1) = NOMBRE D ITERATIONS MAXI A CONVERGENCE
!                                 (ITER_INTE_MAXI == ITECREL)
!                       CRIT(2) = TYPE DE JACOBIEN A T+DT
!                                 (TYPE_MATR_COMP == MACOMP)
!                                 0 = EN VITESSE     > SYMETRIQUE
!                                 1 = EN INCREMENTAL > NON-SYMETRIQUE
!                       CRIT(3) = VALEUR DE LA TOLERANCE DE CONVERGENCE
!                                 (RESI_INTE_RELA == RESCREL)
!                       CRIT(5) = NOMBRE D'INCREMENTS POUR LE
!                                 REDECOUPAGE LOCAL DU PAS DE TEMPS
!                                 (RESI_INTE_PAS == ITEDEC )
!                                 0 = PAS DE REDECOUPAGE
!                                 N = NOMBRE DE PALIERS
!                OUT RETCOM
! ======================================================================

    aster_logical :: mectru, pre2tr
    integer :: ndim, dimdef, dimcon, nvimec, addeme, addete, addep1
    integer :: addep2, adcome, imate, yate, retcom
    real(kind=8) :: defgem(dimdef), congem(dimcon), congep(dimcon)
    real(kind=8) :: vintm(nvimec), vintp(nvimec)
    real(kind=8) :: dsde(dimcon, dimdef), rac2
    character(len=8) :: typmod(2)
    character(len=16) :: option, compor(*), meca, thmc, mult_comp
! ======================================================================
! --- VARIABLES LOCALES ------------------------------------------------
! ======================================================================
    integer :: i, j, numlc
    real(kind=8) :: deps(6), dt, p1, p2
    real(kind=8) :: young, nu, alpha0, carcri(*), instam, instap
    character(len=8) :: fami, poum
    real(kind=8) :: dsdeme(6, 6)
    real(kind=8) :: depstr(6)
    real(kind=8) :: mdal(6), dalal
    character(len=16) :: complg(20)
    aster_logical :: yapre2
! ======================================================================
!    VARIABLES LOCALES POUR L'APPEL AU MODELE DE BARCELONE
    real(kind=8) :: dsidp1(6), dp1, dp2, sat, tbiot(6)
!CCC    SIP NECESSAIRE POUR CALCULER LES CONTRAINTES TOTALES
!CCC    ET ENSUITE CONTRAINTES NETTES DANS LE MODELE DE BARCELONE
    real(kind=8) :: sipm, sipp
! ======================================================================
!    VARIABLES LOCALES POUR L'APPEL AU MODELE DE HOEK_BROWN_TOT
    real(kind=8) :: dsidp2(6), dspdp1, dspdp2
! ======================================================================
    integer :: ndt, ndi, kpg, ksp
    common /tdim/   ndt  , ndi
!
! - Initializations
!
    fami      = 'FPG1'
    kpg       = 1
    ksp       = 1
    poum      = '+'
    mult_comp = ' '
    retcom    = 0
    mectru    = .false.
    rac2      = sqrt(2.0d0)
!
! - Check porosity
!
    call thmCheckPorosity(imate, meca)
! ======================================================================
! --- RECUPERATION OU NON DE LA PRESSION DE GAZ
! ======================================================================
    yapre2 = .false.
    if ((thmc.eq.'GAZ') .or. (thmc.eq.'LIQU_VAPE_GAZ') .or. (thmc.eq.'LIQU_AD_GAZ') .or.&
        (thmc.eq.'LIQU_GAZ') .or. (thmc.eq.'LIQU_AD_GAZ_VAPE')) then
        yapre2 = .true.
    endif

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
                                                       ds_thm%ds_material%elas%d(i,j)/(0.5*rac2)
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
        if ((option(1:9).eq.'RAPH_MECA') .or. (option(1:9) .eq.'FULL_MECA')) then
            do i = 1, 6
                do j = 1, 6
                    congep(adcome+i-1) = congep(adcome+i-1) + &
                                         ds_thm%ds_material%elas%d(i,j)*depstr(j)
                end do
            end do
        endif
!
        do i = 4, 6
            congep(adcome+i-1)= congep(adcome+i-1)*rac2
        end do
!
        if (yate .eq. 1) then
            if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9) .eq.'FULL_MECA')) then
                do i = 1, 6
                    dsde(adcome-1+i,addete)=dsde(adcome-1+i,addete)-mdal(i)
                end do
            endif
            if ((option(1:9).eq.'RAPH_MECA') .or. (option(1:9) .eq.'FULL_MECA')) then
                do i = 1, 6
                    congep(adcome+i-1)=congep(adcome+i-1)-mdal(i)*dt
                end do
            endif
        endif
    elseif (meca .eq. 'BARCELONE') then
! ======================================================================
! --- LOI BARCELONE ----------------------------------------------------
! ======================================================================
        complg(1) = 'BARCELONE'
        write (complg(2),'(I16)') nvimec
        complg(3) = compor(3)
        sipm=congem(adcome+6)
        sipp=congep(adcome+6)
        call nmbarc(ndim, imate, carcri, sat, tbiot(1),&
                    deps, congem(adcome), vintm,&
                    option, congep(adcome), vintp, dsdeme, p1,&
                    p2, dp1, dp2, dsidp1, sipm,&
                    sipp, retcom)
        if ((option(1:16).eq.'RIGI_MECA_TANG') .or. (option(1:9) .eq.'FULL_MECA')) then
            do i = 1, 2*ndim
                dsde(adcome+i-1,addep1) = dsde(adcome+i-1,addep1) +dsidp1(i)
                do j = 1, 2*ndim
                    dsde(adcome+i-1,addeme+ndim+j-1)=dsdeme(i,j)
                end do
            end do
! ======================================================================
! --- LA DEPENDANCE DES CONTRAINTES / T = -ALPHA0 * DEPENDANCE ---------
! --- PAR RAPPORT A TRACE DE DEPS ( APPROXIMATION) ---------------------
! ======================================================================
            if (yate .eq. 1) then
                do i = 1, 3
                    dsde(adcome-1+i,addete)=-alpha0* (dsde(adcome-1+i,&
                    addeme+ndim-1+1)+ dsde(adcome-1+i,addeme+ndim-1+2)&
                    + dsde(adcome-1+i,addeme+ndim-1+3))/3.d0
                end do
            endif
        endif
    elseif (meca .eq. 'GONF_ELAS') then
! ======================================================================
! --- LOI GONF_ELAS ----------------------------------------------------
! ======================================================================
        complg(1) = 'GONF_ELAS'
        write (complg(2),'(I16)') nvimec
        complg(3) = compor(3)
        sipm=congem(adcome+6)
        sipp=congep(adcome+6)
        young  = ds_thm%ds_material%elas%e
        nu     = ds_thm%ds_material%elas%nu
        alpha0 = ds_thm%ds_material%ther%alpha
!
        call elagon(ndim, imate, tbiot(1),&
                    alpha0, deps, young, &
                    nu, congem(adcome), option, congep(adcome), dsdeme,&
                    p1, dp1, dsidp1, dsidp2)
!
        if ((option(1:16).eq.'RIGI_MECA_TANG') .or. (option(1:9) .eq.'FULL_MECA')) then
!
            do i = 1, 2*ndim
                dsde(adcome+i-1,addep1) = dsde(adcome+i-1,addep1) +dsidp1(i)
                do j = 1, 2*ndim
                    dsde(adcome+i-1,addeme+ndim+j-1)=dsdeme(i,j)
                end do
            end do
!
            if (yapre2) then
                do i = 1, 2*ndim
                    dsde(adcome+i-1,addep2) = dsde(adcome+i-1,addep2) +dsidp2(i)
                end do
            endif
!
! ======================================================================
! --- LA DEPENDANCE DES CONTRAINTES / T = -ALPHA0 * DEPENDANCE ---------
! --- PAR RAPPORT A TRACE DE DEPS ( APPROXIMATION) ---------------------
! ======================================================================
            if (yate .eq. 1) then
                do i = 1, 3
                    dsde(adcome-1+i,addete)=-alpha0* (dsde(adcome-1+i,&
                    addeme+ndim-1+1)+ dsde(adcome-1+i,addeme+ndim-1+2)&
                    + dsde(adcome-1+i,addeme+ndim-1+3))/3.d0
                end do
            endif
        endif
    elseif (meca .eq. 'HOEK_BROWN_TOT') then
! ======================================================================
! --- LOI HOEK_BROWN_TOT -----------------------------------------------
! ======================================================================
        complg(1) = 'HOEK_BROWN_TOT'
        write (complg(2),'(I16)') nvimec
        complg(3) = compor(3)
        sipm=congem(adcome+6)
        sipp=congep(adcome+6)
        dspdp1 = 0.0d0
        dspdp2 = 0.0d0
        call dsipdp(thmc, adcome, addep1, addep2, dimcon,&
                    dimdef, dsde, dspdp1, dspdp2, pre2tr)
!
        call lchbr2(typmod, option, imate, carcri, congem(adcome),&
                    defgem( addeme+ndim), deps,&
                    vintm, vintp, dspdp1, dspdp2, sipp,&
                    congep(adcome), dsdeme, dsidp1, dsidp2, retcom)
        if ((option(1:16).eq.'RIGI_MECA_TANG') .or. (option(1:9) .eq.'FULL_MECA')) then
            do i = 1, 2*ndim
                if (addep1 .ge. 1) then
                    dsde(adcome+i-1,addep1) = dsidp1(i)
                endif
!
                if (pre2tr) then
                    dsde(adcome+i-1,addep2) = dsidp2(i)
                endif
                do j = 1, 2*ndim
                    dsde(adcome+i-1,addeme+ndim+j-1)=dsdeme(i,j)
                end do
            end do
! ======================================================================
! --- LA DEPENDANCE DES CONTRAINTES / T = -ALPHA0 * DEPENDANCE ---------
! --- PAR RAPPORT A TRACE DE DEPS ( APPROXIMATION) ---------------------
! ======================================================================
            if (yate .eq. 1) then
                do i = 1, 3
                    dsde(adcome-1+i,addete)=-alpha0* (dsde(adcome-1+i,&
                    addeme+ndim-1+1)+ dsde(adcome-1+i,addeme+ndim-1+2)&
                    + dsde(adcome-1+i,addeme+ndim-1+3))/3.d0
                end do
            endif
        endif
        mectru = .false.
    else
        mectru    = .false.
        complg(NAME) = meca
        write (complg(NVAR),'(I16)') nvimec
        complg(DEFO) = compor(DEFO)
        call thmGetParaBehaviour(compor, nume_meca_ = numlc)
        write (complg(NUME),'(I16)') numlc
        if (numlc .ge. 100) then
            call utmess('F', 'THM1_1', sk = meca)
        endif
        if (numlc .ne. 0) then
            mectru    = .true.
            fami      = 'RIGI'
            kpg       = 1
            ksp       = 1
            call nmcomp(fami, kpg, ksp, ndim, typmod,&
                      imate, complg, carcri, instam, instap,&
                      6, defgem(addeme+ndim), deps, 6, congem(adcome),&
                      vintm, option, angl_naut, 1, [0.d0],&
                      congep(adcome), vintp, 36, dsdeme, 1,&
                      [0.d0], retcom)
        endif
    endif


    if (mectru) then
        if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9) .eq.'FULL_MECA')) then
            do i = 1, ndt
                do j = 1, ndt
                    dsde(adcome+i-1,addeme+ndim+j-1)=dsdeme(i,j)
                end do
            end do
! ======================================================================
! --- LA DEPENDANCE DES CONTRAINTES / T = -ALPHA0 * DEPENDANCE ---------
! --- PAR RAPPORT A TRACE DE DEPS ( APPROXIMATION) ---------------------
! ======================================================================
            if (yate .eq. 1) then
                do i = 1, 3
                    dsde(adcome-1+i,addete)=-alpha0* (dsde(adcome-1+i,&
                    addeme+ndim-1+1)+ dsde(adcome-1+i,addeme+ndim-1+2)&
                    + dsde(adcome-1+i,addeme+ndim-1+3))/3.d0
                end do
            endif
        endif
    endif

! ======================================================================
! --- AFFICHAGE DES DONNEES NECESSAIRES POUR REJOUER CALCUL SI ---------
! --- ECHEC DU MODELE DE COMPORTEMENT - RETCOM.EQ.1 --------------------
! ======================================================================
    if(retcom .eq. 1) then
        call lcidbg(fami, kpg, ksp, typmod, complg, &
                    carcri, instam, instap, 6, & 
                    defgem(addeme+ndim),deps, 6,&
                    congem(adcome), vintm, option) 
    endif
!
end subroutine
