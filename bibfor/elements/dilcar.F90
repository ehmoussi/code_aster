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
subroutine dilcar(option, icompo, icontm, ideplm, ideplp,&
                  igeom , imate , imatuu, ivectu, icontp,&
                  ivarip, ichg  , ichn  , jcret , idefo)
!
use Behaviour_module, only : behaviourOption
!
implicit none
!
#include "jeveux.h"
#include "asterf_types.h"
#include "asterc/ismaem.h"
#include "asterfort/assert.h"
#include "asterfort/jevech.h"
!
integer :: icompo, icontm, ideplm, ideplp, igeom, imate, jcret, idefo
integer :: imatuu, ivectu, icontp, ichg, ichn, ivarip
character(len=16) :: option
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! RECUPERATION DES ADRESSES DES CHAMPS DE L'ELEMENT POUR LES MODELES SECOND GRADIENT
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: lVect, lMatr, lVari, lSigm
!
! --------------------------------------------------------------------------------------------------
!
    lVect = ASTER_FALSE
    lMatr = ASTER_FALSE
    lSigm = ASTER_FALSE
    lVari = ASTER_FALSE
    icompo=ismaem()
    icontm=ismaem()
    ideplm=ismaem()
    ideplp=ismaem()
    igeom =ismaem()
    imate =ismaem()
    imatuu=ismaem()
    ivectu=ismaem()
    icontp=ismaem()
    ivarip=ismaem()
    ichg  =ismaem()
    ichn  =ismaem()
    jcret =ismaem()
    idefo =ismaem()
!
! - Input fields
!
    if (option(1:9) .eq. 'RIGI_MECA') then
        call jevech('PCONTMR', 'L', icontm)
        call jevech('PDEPLMR', 'L', ideplm)
        call jevech('PDEPLPR', 'L', ideplp)
        call jevech('PGEOMER', 'L', igeom)
        call jevech('PMATERC', 'L', imate)
    else if (option.eq.'RAPH_MECA') then
        call jevech('PCONTMR', 'L', icontm)
        call jevech('PDEPLMR', 'L', ideplm)
        call jevech('PDEPLPR', 'L', ideplp)
        call jevech('PGEOMER', 'L', igeom)
        call jevech('PMATERC', 'L', imate)
    else if (option(1:9).eq.'FULL_MECA') then
        call jevech('PCONTMR', 'L', icontm)
        call jevech('PDEPLMR', 'L', ideplm)
        call jevech('PDEPLPR', 'L', ideplp)
        call jevech('PGEOMER', 'L', igeom)
        call jevech('PMATERC', 'L', imate)
    else if (option.eq.'FORC_NODA') then
        call jevech('PCONTMR', 'L', icontm)
        call jevech('PDEPLMR', 'L', ideplm)
        call jevech('PGEOMER', 'L', igeom)
        call jevech('PMATERC', 'L', imate)
    else if (option.eq.'EPSI_ELGA') then
        call jevech('PGEOMER', 'L', igeom)
        call jevech('PDEPLAR', 'L', ideplp)
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Select objects to construct from option name
!
    if (option.ne.'EPSI_ELGA') then
        call jevech('PCOMPOR', 'L', icompo)
        call behaviourOption(option, zk16(icompo),&
                             lMatr , lVect ,&
                             lVari , lSigm)
    endif
!
    if (option .eq. 'CHAR_MECA_PESA_R') then
        ASSERT(ASTER_FALSE)
    endif
!
! - Output fields
!
    if (option.eq.'FORC_NODA') then
        call jevech('PVECTUR', 'E', ivectu)
    else if (option.eq.'EPSI_ELGA') then
        call jevech('PDEFOPG', 'E', idefo)
    else
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
    endif
!
end subroutine
