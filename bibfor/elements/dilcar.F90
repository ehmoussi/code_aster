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

subroutine dilcar(option, icompo, icontm, ideplm, ideplp,&
                  igeom, imate, imatuu, ivectu, icontp,&
                  ivarip, ichg, ichn, jcret, idefo)
    implicit      none
#include "asterc/ismaem.h"
#include "asterfort/assert.h"
#include "asterfort/jevech.h"
    integer :: icompo, icontm, ideplm, ideplp, igeom, imate, jcret, idefo
    integer :: imatuu, ivectu, icontp, ichg, ichn, ivarip
    character(len=16) :: option
! ======================================================================
! --- BUT : RECUPERATION DES ADRESSES DES CHAMPS DE L'ELEMENT ----------
! -------   POUR LES MODELES SECOND GRADIENT ---------------------------
! ======================================================================
! --- VARIABLES LOCALES ------------------------------------------------
! ======================================================================
    integer :: ivarim
! ======================================================================
! --- INITIALISATION DE TOUTES LES ADRESSES A L'ENTIER MAXIMAL ---------
! ======================================================================
    icompo=ismaem()
    icontm=ismaem()
    ideplm=ismaem()
    ideplp=ismaem()
    igeom =ismaem()
    imate =ismaem()
    ivarim=ismaem()
    imatuu=ismaem()
    ivectu=ismaem()
    icontp=ismaem()
    ivarip=ismaem()
    ichg  =ismaem()
    ichn  =ismaem()
    jcret =ismaem()
    idefo =ismaem()
! ======================================================================
    if (option .eq. 'CHAR_MECA_PESA_R') then
! OPTION NON PROGRAMMEE
        ASSERT(.false.)
    endif
! ======================================================================
! --- RECUPERATION DES CHAMPS D'ENTREE DE L'ELEMENT --------------------
! ======================================================================
    if (option(1:9) .eq. 'RIGI_MECA') then
        call jevech('PCOMPOR', 'L', icompo)
        call jevech('PCONTMR', 'L', icontm)
        call jevech('PDEPLMR', 'L', ideplm)
        call jevech('PDEPLPR', 'L', ideplp)
        call jevech('PGEOMER', 'L', igeom)
        call jevech('PMATERC', 'L', imate)
        call jevech('PVARIMR', 'L', ivarim)
        call jevech('PMATUNS', 'E', imatuu)
    else if (option.eq.'RAPH_MECA') then
        call jevech('PCOMPOR', 'L', icompo)
        call jevech('PCONTMR', 'L', icontm)
        call jevech('PDEPLMR', 'L', ideplm)
        call jevech('PDEPLPR', 'L', ideplp)
        call jevech('PGEOMER', 'L', igeom)
        call jevech('PMATERC', 'L', imate)
        call jevech('PVARIMR', 'L', ivarim)
        call jevech('PVECTUR', 'E', ivectu)
        call jevech('PCONTPR', 'E', icontp)
        call jevech('PVARIPR', 'E', ivarip)
        call jevech('PCODRET', 'E', jcret)
    else if (option(1:9).eq.'FULL_MECA') then
        call jevech('PCOMPOR', 'L', icompo)
        call jevech('PCONTMR', 'L', icontm)
        call jevech('PDEPLMR', 'L', ideplm)
        call jevech('PDEPLPR', 'L', ideplp)
        call jevech('PGEOMER', 'L', igeom)
        call jevech('PMATERC', 'L', imate)
        call jevech('PVARIMR', 'L', ivarim)
        call jevech('PMATUNS', 'E', imatuu)
        call jevech('PVECTUR', 'E', ivectu)
        call jevech('PCONTPR', 'E', icontp)
        call jevech('PVARIPR', 'E', ivarip)
        call jevech('PCODRET', 'E', jcret)
    else if (option.eq.'FORC_NODA') then
        call jevech('PCOMPOR', 'L', icompo)
        call jevech('PCONTMR', 'L', icontm)
        call jevech('PDEPLMR', 'L', ideplm)
        call jevech('PGEOMER', 'L', igeom)
        call jevech('PMATERC', 'L', imate)
        call jevech('PVECTUR', 'E', ivectu)
    else if (option.eq.'EPSI_ELGA') then
        call jevech('PGEOMER', 'L', igeom)
        call jevech('PDEPLAR', 'L', ideplp)
        call jevech('PDEFOPG', 'E', idefo)
    endif
! ======================================================================
end subroutine
