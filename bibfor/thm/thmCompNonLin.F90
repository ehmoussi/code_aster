! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine thmCompNonLin(option, ds_thm)
!
use THM_type
use Behaviour_module, only : behaviourOption
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/ismaem.h"
#include "asterfort/assert.h"
#include "asterfort/assthm.h"
#include "asterfort/thmGetElemPara.h"
#include "asterfort/thmGetParaOrientation.h"
#include "asterfort/jevech.h"
#include "asterfort/Behaviour_type.h"
!
character(len=16), intent(in) :: option
type(THM_DS), intent(inout) :: ds_thm
!
! --------------------------------------------------------------------------------------------------
!
! THM - Compute
!
! Non-linear options
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  ds_thm           : datastructure for THM
!
! --------------------------------------------------------------------------------------------------
!
    integer :: codret
    integer :: i_dimuel
    real(kind=8) :: angl_naut(3)
    integer :: jv_sigm, jv_vari, jv_disp
    integer :: jv_geom, jv_matr, jv_vect, jv_sigmm, jv_varim, jv_cret
    integer :: jv_mater, jv_instm, jv_instp, jv_dispm
    integer :: jv_dispp, jv_compor, jv_carcri, jv_varip, jv_sigmp
    aster_logical :: l_axi, l_steady
    character(len=3) :: inte_type
    integer :: mecani(5), press1(7), press2(7), tempe(5)
    integer :: dimdep, dimdef, dimcon, dimuel
    integer :: nddls, nddlm, nddl_p1, nddl_p2, nddl_meca
    integer :: ndim, nno, nnos
    integer :: npi, npg, nbvari
    integer :: jv_poids, jv_func, jv_dfunc, jv_poids2, jv_func2, jv_dfunc2, jv_gano
    character(len=8) :: type_elem(2)
    aster_logical :: lVect, lMatr, lVari, lSigm, lMatrPred
!
! --------------------------------------------------------------------------------------------------
!
    codret    = 0
    lMatrPred = option(1:9) .eq. 'RIGI_MECA'
!
! - Get all parameters for current element
!
    call thmGetElemPara(ds_thm   , l_axi    , l_steady ,&
                        type_elem, inte_type, ndim     ,&
                        mecani   , press1   , press2   , tempe  ,&
                        dimdep   , dimdef   , dimcon   , dimuel ,&
                        nddls    , nddlm    , nddl_meca, nddl_p1, nddl_p2,&
                        nno      , nnos     ,&
                        npi      , npg      ,&
                        jv_poids , jv_func  , jv_dfunc ,&
                        jv_poids2, jv_func2 , jv_dfunc2,&
                        jv_gano)
!
! - Input fields
!
    call jevech('PGEOMER', 'L', jv_geom)
    call jevech('PMATERC', 'L', jv_mater)
    call jevech('PINSTMR', 'L', jv_instm)
    call jevech('PINSTPR', 'L', jv_instp)
    call jevech('PDEPLMR', 'L', jv_dispm)
    call jevech('PDEPLPR', 'L', jv_dispp)
    call jevech('PCOMPOR', 'L', jv_compor)
    call jevech('PCARCRI', 'L', jv_carcri)
    call jevech('PVARIMR', 'L', jv_varim)
    call jevech('PCONTMR', 'L', jv_sigmm)
!
! - Select objects to construct from option name
!
    call behaviourOption(option, zk16(jv_compor),&
                         lMatr , lVect ,&
                         lVari , lSigm ,&
                         codret)
!
! - Output fields
!
    jv_matr  = ismaem()
    jv_vect  = ismaem()
    jv_sigmp = ismaem()
    jv_varip = ismaem()
    jv_cret  = ismaem()
    if (lMatr) then
        call jevech('PMATUNS', 'E', jv_matr)
    endif
    if (lVect) then
        call jevech('PVECTUR', 'E', jv_vect)
    endif
    if (lVari) then
        call jevech('PVARIPR', 'E', jv_varip)
    endif
    if (lSigm) then
        call jevech('PCONTPR', 'E', jv_sigmp)
        call jevech('PCODRET', 'E', jv_cret)
    endif
!
! - Get frame orientation for anisotropy
!
    call thmGetParaOrientation(ndim, nno, jv_geom, angl_naut)
!
! - Prepare reference configuration
!
    if (lMatrPred) then
        jv_disp = jv_dispm
        jv_sigm = jv_sigmm
        jv_vari = jv_varim
    else
        do i_dimuel = 1, dimuel
            zr(jv_dispp+i_dimuel-1) = zr(jv_dispm+i_dimuel-1) + zr(jv_dispp+i_dimuel-1)
        end do
        jv_disp = jv_dispp
        jv_sigm = jv_sigmp
        jv_vari = jv_varip
    endif
!
! - Number of (total) internal variables
!
    read (zk16(jv_compor-1+NVAR),'(I16)') nbvari
!
! - Compute
!
    call assthm(ds_thm         , option       , zi(jv_mater),&
                lMatr          , lSigm        , lVect       ,&
                lVari          , lMatrPred    , l_axi       , l_steady,&
                type_elem      , inte_type    , angl_naut   ,&
                ndim           , nbvari       , nno         , nnos    ,&
                npg            , npi          ,&
                nddls          , nddlm        , nddl_meca   ,&
                nddl_p1        , nddl_p2      ,&
                dimdef         , dimcon       , dimuel      ,&
                mecani         , press1       , press2      , tempe   ,&
                zk16(jv_compor), zr(jv_carcri),&
                jv_poids       , jv_poids2    ,&
                jv_func        , jv_func2     ,&
                jv_dfunc       , jv_dfunc2    ,&
                zr(jv_geom)    , zr(jv_dispm) , zr(jv_disp) ,&
                zr(jv_sigmm)   , zr(jv_sigm)  ,&
                zr(jv_varim)   , zr(jv_vari)  ,&
                zr(jv_instm)   , zr(jv_instp) ,& 
                zr(jv_matr)    , zr(jv_vect)  , codret)
!
! - Save error from integration
!
    if (lSigm) then
        zi(jv_cret) = codret
    endif
!
end subroutine
