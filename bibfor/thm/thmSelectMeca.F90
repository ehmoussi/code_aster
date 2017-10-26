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
subroutine thmSelectMeca(p1    , dp1    , p2    , dp2   , satur    , tbiot,&
                         option, j_mater, ndim  , typmod, angl_naut,&
                         carcri, instam , instap, dtemp ,&
                         addeme, addete , adcome, addep1, addep2,&
                         dimdef, dimcon ,&
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
#include "asterfort/thmMecaSpecial.h"
!
integer, intent(in) :: j_mater
character(len=16), intent(in) :: option
real(kind=8), intent(in) :: p1, dp1, p2, dp2, satur, tbiot(6)
character(len=8), intent(in) :: typmod(2)
real(kind=8), intent(in) :: carcri(*)
real(kind=8), intent(in) :: instam, instap, dtemp
integer, intent(in) :: ndim, dimdef, dimcon
integer, intent(in) :: addeme, addete, adcome, addep1, addep2
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
! In  p1               : capillary pressure - At end of current step
! In  dp1              : increment of capillary pressure
! In  p2               : gaz pressure - At end of current step
! In  dp2              : increment of gaz pressure
! In  satur            : saturation
! In  tbiot            : tensor of Biot
! In  option           : option to compute
! In  j_mater          : coded material address
! In  ndim             : dimension of space (2 or 3)
! In  typmod           : type of modelization (TYPMOD2)
! In  angl_naut        : nautical angles
!                        (1) Alpha - clockwise around Z0
!                        (2) Beta  - counterclockwise around Y1
!                        (3) Gamma - clockwise around X
! In  carcri           : parameters for comportment
! In  instam           : time at beginning of time step
! In  instap           : time at end of time step
! In  dtemp            : increment of temperature
! In  addeme           : adress of mechanic dof in vector and matrix (generalized quantities)
! In  addete           : adress of thermic dof in vector and matrix (generalized quantities)
! In  adcome           : adress of mechanic stress in generalized stresses vector
! In  addep1           : adress of p1 dof in vector and matrix (generalized quantities)
! In  addep2           : adress of p2 dof in vector and matrix (generalized quantities)
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
    character(len=16) :: compor_meca(NB_COMP_MAXI)
    integer :: i, j
    real(kind=8) :: dsdeme(6, 6), alpha0, ther_meca(6)
    aster_logical :: l_matrix
    integer :: ndt, ndi
    common /tdim/   ndt  , ndi
    character(len=16) :: meca, defo
    integer :: nb_vari_meca, nume_meca, nume_thmc
!
! --------------------------------------------------------------------------------------------------
!
    ndt            = 2*ndim
    ndi            = ndim
    dsdeme(:, :)   = 0.d0
    ther_meca(:)   = 0.d0
    alpha0         = ds_thm%ds_material%ther%alpha
    compor_meca(:) = ' '
    retcom         = 0
    l_matrix       = (option(1:9).eq.'RIGI_MECA') .or. (option(1:9) .eq.'FULL_MECA')
!
! - Get storage parameters for behaviours
!
    defo         = ds_thm%ds_behaviour%defo
    meca         = ds_thm%ds_behaviour%rela_meca
    nb_vari_meca = ds_thm%ds_behaviour%nb_vari_meca
    nume_meca    = ds_thm%ds_behaviour%nume_meca
    nume_thmc    = ds_thm%ds_behaviour%nume_thmc
!
! - Check porosity
!
    call thmCheckPorosity(j_mater, meca)
!
! - Select
!
    if (nume_meca .eq. 0) then
! ----- Special behaviours
        call thmMecaSpecial(option , meca     , nume_thmc,&
                            p1     , dp1      , p2       , dp2   , satur, tbiot,&
                            j_mater, ndim     , typmod   , carcri, &
                            addeme , adcome   , addep1   , addep2,&
                            dimdef , dimcon   ,&
                            defgem , deps     ,&
                            congem , vintm    ,&
                            congep , vintp    ,&
                            dsde   , ther_meca, retcom)

    elseif (nume_meca .eq. 1) then
! ----- Elasticity
        ASSERT(meca .eq. 'ELAS')
        call thmMecaElas(option, angl_naut, dtemp,&
                         adcome, dimcon,&
                         deps  , congep, dsdeme, ther_meca)


    elseif (nume_meca .ge. 100) then
! ----- Forbidden behaviours
        call utmess('F', 'THM1_1', sk = meca)

    else
! ----- Standard behaviours
        compor_meca(NAME) = meca
        write (compor_meca(NVAR),'(I16)') nb_vari_meca
        compor_meca(DEFO) = defo
        write (compor_meca(NUME),'(I16)') nume_meca
        call calcme(option     , j_mater, ndim  , typmod, angl_naut,&
                    compor_meca, carcri , instam, instap,&
                    addeme     , adcome , dimdef, dimcon,&
                    defgem     , deps   ,&
                    congem     , vintm  ,&
                    congep     , vintp  ,&
                    dsdeme     , retcom )
! ----- Compute thermic dilatation
        if (ds_thm%ds_elem%l_dof_ther) then
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
        if (ds_thm%ds_elem%l_dof_ther) then
            do i = 1, 6
                dsde(adcome-1+i,addete) = dsde(adcome-1+i,addete) -&
                                          ther_meca(i)
            end do
        endif
    endif
!
end subroutine
