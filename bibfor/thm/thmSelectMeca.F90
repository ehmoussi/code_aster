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
!
subroutine thmSelectMeca(yate  , yap1   , yap2  ,&
                         option, j_mater, ndim  , typmod, angl_naut,&
                         compor, carcri , instam, instap, dtemp    ,&
                         addeme, addete , adcome, dimdef, dimcon,&
                         defgem, deps   ,&
                         congem, vintm  ,&
                         congep, vintp  ,&
                         dsde  , retcom)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/calcme.h"
#include "asterfort/Behaviour_type.h"
#include "asterfort/thmMecaElas.h"
#include "asterfort/thmCheckPorosity.h"
#include "asterfort/thmGetParaBehaviour.h"
!
integer, intent(in) :: yate, yap1, yap2
integer, intent(in) :: j_mater
character(len=16), intent(in) :: option, compor(*)
character(len=8), intent(in) :: typmod(2)
real(kind=8), intent(in) :: carcri(*)
real(kind=8), intent(in) :: instam, instap, dtemp
integer, intent(in) :: ndim, dimdef, dimcon, addete, addeme, adcome
real(kind=8), intent(in) :: vintm(*)
real(kind=8), intent(in) :: angl_naut(3)
real(kind=8), intent(in) :: defgem(dimdef), deps(6), congem(dimcon)
real(kind=8), intent(inout) :: congep(dimcon)
real(kind=8), intent(inout) :: vintp(*)
real(kind=8), intent(inout) :: dsde(dimcon, dimdef)
integer, intent(out) :: retcom
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Main select subroutine to integrate mechanical behaviour
!
! --------------------------------------------------------------------------------------------------
!
! In  yate             : 1 if thermic dof
! In  yap1             : 1 if first pressure dof
! In  yap2             : 1 if second pressure dof
! In  option           : option to compute
! In  j_mater          : coded material address
! In  ndim             : dimension of space (2 or 3)
! In  typmod           : type of modelization (TYPMOD2)
! In  angl_naut        : nautical angles
!                        (1) Alpha - clockwise around Z0
!                        (2) Beta  - counterclockwise around Y1
!                        (3) Gamma - clockwise around X
! In  compor           : behaviour
! In  carcri           : parameters for comportment
! In  instam           : time at beginning of time step
! In  instap           : time at end of time step
! In  dtemp            : increment of temperature
! In  addeme           : adress of mechanic dof in vector and matrix (generalized quantities)
! In  addete           : adress of thermic dof in vector and matrix (generalized quantities)
! In  adcome           : adress of mechanic stress in generalized stresses vector
! In  dimdef           : dimension of generalized strains vector
! In  dimcon           : dimension of generalized stresses vector
! In  defgem           : generalized strains - At begin of current step
! In  deps             : increment of mechanic strains
! In  congem           : generalized stresses - At begin of current step
! In  vintm            : internal state variables - At begin of current step
! IO  congep           : generalized stresses - At end of current step
! IO  vintp            : internal state variables - At end of current step
! IO  dsde             : derivative matrix
! Out retcom           : return code
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: meca, compor_meca(NB_COMP_MAXI)
    integer :: nvimec, numlc, i, j
    real(kind=8) :: dsdeme(6, 6), alpha0, ther_meca(6)
    aster_logical :: l_matrix
    integer :: ndt, ndi
    common /tdim/   ndt  , ndi
!
! --------------------------------------------------------------------------------------------------
!
    ndt = 2*ndim
    ndi = ndim
!
! - Initializations
!
!    fami      = 'FPG1'
!    kpg       = 1
!    ksp       = 1
!    poum      = '+'
!    mult_comp = ' '
!    retcom    = 0
!    mectru    = .false.
!    rac2      = sqrt(2.0d0)
    ther_meca(:)   = 0.d0
    alpha0         = ds_thm%ds_material%ther%alpha
    compor_meca(:) = ' '
    retcom         = 0
    l_matrix       = (option(1:9).eq.'RIGI_MECA') .or. (option(1:9) .eq.'FULL_MECA')
!
! - Get mechanical behaviour
!
    call thmGetParaBehaviour(compor,&
                             meca_      = meca,&
                             nvim_      = nvimec,&
                             nume_meca_ = numlc)
!
! - Check porosity
!
    call thmCheckPorosity(j_mater, meca)
!
! - Select
!
    if (numlc .eq. 0) then
! ----- Special behaviours

    elseif (numlc .eq. 1) then
! ----- Elasticity
        ASSERT(meca .eq. 'ELAS')
        call thmMecaElas(yate  , option, angl_naut, dtemp,&
                         adcome, dimcon,&
                         deps  , congep, dsdeme, ther_meca)


    elseif (numlc .ge. 100) then
! ----- Forbidden behaviours
        call utmess('F', 'THM1_1', sk = meca)

    else
! ----- Standard behaviours
        compor_meca(NAME) = meca
        write (compor_meca(NVAR),'(I16)') nvimec
        compor_meca(DEFO) = compor(DEFO)
        write (compor_meca(NUME),'(I16)') numlc
        call calcme(option     , j_mater, ndim  , typmod, angl_naut,&
                    compor_meca, carcri , instam, instap,&
                    addeme     , adcome , dimdef, dimcon,&
                    defgem     , deps   ,&
                    congem     , vintm  ,&
                    congep     , vintp  ,&
                    dsdeme     , retcom )
! ----- Compute thermic dilatation
        if (yate .eq. 1) then
            do i = 1, 3
                ther_meca(i) = -alpha0*(&
                                dsde(adcome-1+i,addeme+ndim-1+1)+&
                                dsde(adcome-1+i,addeme+ndim-1+2)+&
                                dsde(adcome-1+i,addeme+ndim-1+3))/3.d0
            end do
        endif     
    endif
!
! - Add mechanical matrix
!
    if (l_matrix) then
        do i = 1, ndt
            do j = 1, ndt
                dsde(adcome+i-1,addeme+ndim+j-1) = dsde(adcome+i-1,addeme+ndim+j-1) +&
                                                   dsdeme(i,j)
            end do
        end do
    endif
!
! - Add thermic (dilatation) matrix
!
    if (l_matrix) then
        if (yate .eq. 1) then
            do i = 1, 6
                dsde(adcome-1+i,addete) = dsde(adcome-1+i,addete) -&
                                          ther_meca(i)
            end do
        endif
    endif

!    elseif (meca .eq. 'BARCELONE') then
!! ======================================================================
!! --- LOI BARCELONE ----------------------------------------------------
!! ======================================================================
!        complg(1) = 'BARCELONE'
!        write (complg(2),'(I16)') nvimec
!        complg(3) = compor(3)
!        sipm=congem(adcome+6)
!        sipp=congep(adcome+6)
!        call nmbarc(ndim, j_mater, carcri, sat, tbiot(1),&
!                    deps, congem(adcome), vintm,&
!                    option, congep(adcome), vintp, dsdeme, p1,&
!                    p2, dp1, dp2, dsidp1, sipm,&
!                    sipp, retcom)
!        if ((option(1:16).eq.'RIGI_MECA_TANG') .or. (option(1:9) .eq.'FULL_MECA')) then
!            do i = 1, 2*ndim
!                dsde(adcome+i-1,addep1) = dsde(adcome+i-1,addep1) +dsidp1(i)
!                do j = 1, 2*ndim
!                    dsde(adcome+i-1,addeme+ndim+j-1)=dsdeme(i,j)
!                end do
!            end do
!! ======================================================================
!! --- LA DEPENDANCE DES CONTRAINTES / T = -ALPHA0 * DEPENDANCE ---------
!! --- PAR RAPPORT A TRACE DE DEPS ( APPROXIMATION) ---------------------
!! ======================================================================
!            if (yate .eq. 1) then
!                do i = 1, 3
!                    dsde(adcome-1+i,addete)=-alpha0* (dsde(adcome-1+i,&
!                    addeme+ndim-1+1)+ dsde(adcome-1+i,addeme+ndim-1+2)&
!                    + dsde(adcome-1+i,addeme+ndim-1+3))/3.d0
!                end do
!            endif
!        endif
!    elseif (meca .eq. 'GONF_ELAS') then
!! ======================================================================
!! --- LOI GONF_ELAS ----------------------------------------------------
!! ======================================================================
!        complg(1) = 'GONF_ELAS'
!        write (complg(2),'(I16)') nvimec
!        complg(3) = compor(3)
!        sipm=congem(adcome+6)
!        sipp=congep(adcome+6)
!        young  = ds_thm%ds_material%elas%e
!        nu     = ds_thm%ds_material%elas%nu
!        alpha0 = ds_thm%ds_material%ther%alpha
!!
!        call elagon(ndim, j_mater, tbiot(1),&
!                    alpha0, deps, young, &
!                    nu, congem(adcome), option, congep(adcome), dsdeme,&
!                    p1, dp1, dsidp1, dsidp2)
!!
!        if ((option(1:16).eq.'RIGI_MECA_TANG') .or. (option(1:9) .eq.'FULL_MECA')) then
!!
!            do i = 1, 2*ndim
!                dsde(adcome+i-1,addep1) = dsde(adcome+i-1,addep1) +dsidp1(i)
!                do j = 1, 2*ndim
!                    dsde(adcome+i-1,addeme+ndim+j-1)=dsdeme(i,j)
!                end do
!            end do
!!
!            if (yapre2) then
!                do i = 1, 2*ndim
!                    dsde(adcome+i-1,addep2) = dsde(adcome+i-1,addep2) +dsidp2(i)
!                end do
!            endif
!!
!! ======================================================================
!! --- LA DEPENDANCE DES CONTRAINTES / T = -ALPHA0 * DEPENDANCE ---------
!! --- PAR RAPPORT A TRACE DE DEPS ( APPROXIMATION) ---------------------
!! ======================================================================
!            if (yate .eq. 1) then
!                do i = 1, 3
!                    dsde(adcome-1+i,addete)=-alpha0* (dsde(adcome-1+i,&
!                    addeme+ndim-1+1)+ dsde(adcome-1+i,addeme+ndim-1+2)&
!                    + dsde(adcome-1+i,addeme+ndim-1+3))/3.d0
!                end do
!            endif
!        endif
!    elseif (meca .eq. 'HOEK_BROWN_TOT') then
!! ======================================================================
!! --- LOI HOEK_BROWN_TOT -----------------------------------------------
!! ======================================================================
!        complg(1) = 'HOEK_BROWN_TOT'
!        write (complg(2),'(I16)') nvimec
!        complg(3) = compor(3)
!        sipm=congem(adcome+6)
!        sipp=congep(adcome+6)
!        dspdp1 = 0.0d0
!        dspdp2 = 0.0d0
!        call dsipdp(thmc, adcome, addep1, addep2, dimcon,&
!                    dimdef, dsde, dspdp1, dspdp2, pre2tr)
!!
!        call lchbr2(typmod, option, j_mater, carcri, congem(adcome),&
!                    defgem( addeme+ndim), deps,&
!                    vintm, vintp, dspdp1, dspdp2, sipp,&
!                    congep(adcome), dsdeme, dsidp1, dsidp2, retcom)
!        if ((option(1:16).eq.'RIGI_MECA_TANG') .or. (option(1:9) .eq.'FULL_MECA')) then
!            do i = 1, 2*ndim
!                if (addep1 .ge. 1) then
!                    dsde(adcome+i-1,addep1) = dsidp1(i)
!                endif
!!
!                if (pre2tr) then
!                    dsde(adcome+i-1,addep2) = dsidp2(i)
!                endif
!                do j = 1, 2*ndim
!                    dsde(adcome+i-1,addeme+ndim+j-1)=dsdeme(i,j)
!                end do
!            end do
!! ======================================================================
!! --- LA DEPENDANCE DES CONTRAINTES / T = -ALPHA0 * DEPENDANCE ---------
!! --- PAR RAPPORT A TRACE DE DEPS ( APPROXIMATION) ---------------------
!! ======================================================================
!            if (yate .eq. 1) then
!                do i = 1, 3
!                    dsde(adcome-1+i,addete)=-alpha0* (dsde(adcome-1+i,&
!                    addeme+ndim-1+1)+ dsde(adcome-1+i,addeme+ndim-1+2)&
!                    + dsde(adcome-1+i,addeme+ndim-1+3))/3.d0
!                end do
!            endif
!        endif
!        mectru = .false.
!    else
!        mectru    = .false.
!        complg(NAME) = meca
!        write (complg(NVAR),'(I16)') nvimec
!        complg(DEFO) = compor(DEFO)
!        call thmGetParaBehaviour(compor, nume_meca_ = numlc)
!        write (complg(NUME),'(I16)') numlc
!        if (numlc .ge. 100) then
!            call utmess('F', 'THM1_1', sk = meca)
!        endif
!        if (numlc .ne. 0) then
!            mectru    = .true.
!            fami      = 'RIGI'
!            kpg       = 1
!            ksp       = 1
!            call nmcomp(fami, kpg, ksp, ndim, typmod,&
!                      j_mater, complg, carcri, instam, instap,&
!                      6, defgem(addeme+ndim), deps, 6, congem(adcome),&
!                      vintm, option, angl_naut, 1, [0.d0],&
!                      congep(adcome), vintp, 36, dsdeme, 1,&
!                      [0.d0], retcom)
!        endif
!    endif


!    if (mectru) then
!        if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9) .eq.'FULL_MECA')) then
!            do i = 1, ndt
!                do j = 1, ndt
!                    dsde(adcome+i-1,addeme+ndim+j-1)=dsdeme(i,j)
!                end do
!            end do
!! ======================================================================
!! --- LA DEPENDANCE DES CONTRAINTES / T = -ALPHA0 * DEPENDANCE ---------
!! --- PAR RAPPORT A TRACE DE DEPS ( APPROXIMATION) ---------------------
!! ======================================================================
!            if (yate .eq. 1) then
!                do i = 1, 3
!                    dsde(adcome-1+i,addete)=-alpha0* (dsde(adcome-1+i,&
!                    addeme+ndim-1+1)+ dsde(adcome-1+i,addeme+ndim-1+2)&
!                    + dsde(adcome-1+i,addeme+ndim-1+3))/3.d0
!                end do
!            endif
!        endif
!    endif

!! ======================================================================
!! --- AFFICHAGE DES DONNEES NECESSAIRES POUR REJOUER CALCUL SI ---------
!! --- ECHEC DU MODELE DE COMPORTEMENT - RETCOM.EQ.1 --------------------
!! ======================================================================
!    if(retcom .eq. 1) then
!        call lcidbg(fami, kpg, ksp, typmod, complg, &
!                    carcri, instam, instap, 6, & 
!                    defgem(addeme+ndim),deps, 6,&
!                    congem(adcome), vintm, option) 
!    endif
!
end subroutine
