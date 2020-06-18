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
subroutine te0515(option, nomte)
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
#include "asterfort/assesu.h"
#include "asterfort/Behaviour_type.h"
#include "asterfort/thmGetElemPara_vf.h"
#include "asterfort/fnoesu.h"
#include "asterfort/jevech.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: 3D_HH2SUDA and D_PLAN_HH2SUDA (finite volume)
! Options: RIGI_MECA_*, FULL_MECA, RAPH_MECA and FORC_NODA
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nno, imatuu, ndim, imate, iinstm, jcret
    integer :: retloi
    integer :: igeom
    integer :: iinstp, ideplm, ideplp, icompo, icarcr
    integer :: icontm, ivarip, ivarim, ivectu, icontp
    integer :: mecani(5), press1(7), press2(7), tempe(5), dimuel
    integer :: dimdef, dimcon, nbvari
    integer :: nnos, nface
    real(kind=8) :: defgep(21), defgem(21)
    character(len=8) :: type_elem(2)
    integer :: li
    aster_logical :: l_axi, l_vf, l_steady
    aster_logical :: lVect, lMatr, lVari, lSigm, lMatrPred
    type(THM_DS) :: ds_thm
!
! --------------------------------------------------------------------------------------------------
!
! 
! - Get all parameters for current element - Finite volume version
!
    call thmGetElemPara_vf(ds_thm   , l_axi , l_steady , l_vf  ,&
                           type_elem, ndim  ,&
                           mecani   , press1, press2, tempe,&
                           dimdef   , dimcon, dimuel,&
                           nno      , nnos  , nface )
    ASSERT(l_vf)
!
! - Non-linear options
!
    if ((option(1:14).eq.'RIGI_MECA_TANG' ) .or. (option(1:9).eq.'RAPH_MECA' ) .or.&
        (option(1:9).eq.'FULL_MECA' )) then
! ----- Get input fields
        call jevech('PGEOMER', 'L', igeom)
        call jevech('PMATERC', 'L', imate)
        call jevech('PINSTMR', 'L', iinstm)
        call jevech('PINSTPR', 'L', iinstp)
        call jevech('PDEPLMR', 'L', ideplm)
        call jevech('PDEPLPR', 'L', ideplp)
        call jevech('PCOMPOR', 'L', icompo)
        call jevech('PCARCRI', 'L', icarcr)
        call jevech('PVARIMR', 'L', ivarim)
        call jevech('PCONTMR', 'L', icontm)
! ----- Select objects to construct from option name
        lMatrPred = option(1:9) .eq. 'RIGI_MECA'
        call behaviourOption(option, zk16(icompo),&
                             lMatr , lVect ,&
                             lVari , lSigm ,&
                             retloi)
! ----- Properties of behaviour
        read (zk16(icompo-1+NVAR),'(I16)') nbvari
! ----- Get output fields
        ivectu = ismaem()
        icontp = ismaem()
        ivarip = ismaem()
        imatuu = ismaem()
        if (lMatr) then
            call jevech('PMATUNS', 'E', imatuu)
        endif
        if (lVect) then
            call jevech('PVECTUR', 'E', ivectu)
        endif
        if (lSigm) then
            call jevech('PCONTPR', 'E', icontp)
            call jevech('PCODRET', 'E', jcret)
        endif
        if (lVari) then
            call jevech('PVARIPR', 'E', ivarip)
        endif
        if (option(1:14) .eq. 'RIGI_MECA_TANG') then
            call assesu(ds_thm      ,&
                        lMatr       , lVect    , lSigm ,&
                        lVari       , lMatrPred,&
                        option      , zi(imate) ,&
                        type_elem   ,&
                        ndim        , nbvari    ,&
                        nno         , nnos      , nface ,&
                        dimdef      , dimcon    , dimuel,&
                        mecani      , press1    , press2, tempe,&
                        zk16(icompo), zr(icarcr),&
                        zr(igeom)   ,&
                        zr(ideplm)  , zr(ideplm),&
                        defgem      , defgep    ,& 
                        zr(icontm)  , zr(icontm),&
                        zr(ivarim)  , zr(ivarim),&
                        zr(iinstm)  , zr(iinstp),& 
                        zr(imatuu)  , zr(ivectu))
        else
            do li = 1, dimuel
                zr(ideplp+li-1) = zr(ideplm+li-1) + zr(ideplp+li-1)
            end do
            call assesu(ds_thm      ,&
                        lMatr       , lVect    , lSigm ,&
                        lVari       , lMatrPred,&
                        option      , zi(imate) ,&
                        type_elem   ,&
                        ndim        , nbvari    ,&
                        nno         , nnos      , nface ,&
                        dimdef      , dimcon    , dimuel,&
                        mecani      , press1    , press2, tempe,&
                        zk16(icompo), zr(icarcr),&
                        zr(igeom)   ,&
                        zr(ideplm)  , zr(ideplp),&
                        defgem      , defgep    ,& 
                        zr(icontm)  , zr(icontp),&
                        zr(ivarim)  , zr(ivarip),&
                        zr(iinstm)  , zr(iinstp),& 
                        zr(imatuu)  , zr(ivectu))

        endif
        if (lSigm) then
            zi(jcret) = retloi
        endif
    endif
!
! - Option: FORC_NODA
!
    if (option .eq. 'FORC_NODA') then
        call jevech('PCONTMR', 'L', icontm)
        call jevech('PVECTUR', 'E', ivectu)
        call fnoesu(nface     ,&
                    dimcon    , dimuel   ,&
                    press1    , press2   ,&
                    zr(icontm), zr(ivectu))
    endif
!
end subroutine
