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

subroutine xmdeco(ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/copisd.h"
!
!
    type(NL_DS_Contact), intent(in) :: ds_contact
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONSTINUE - POST-TRAITEMENT)
!
! GESTION DE LA DECOUPE
!
! ----------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
!
    character(len=19) :: xindco, xmemco, xindcp, xmemcp
    character(len=19) :: xseuco, xseucp, xcohes, xcohep
!
! ----------------------------------------------------------------------
!
    xindco = ds_contact%sdcont_solv(1:14)//'.XFIN'
    xmemco = ds_contact%sdcont_solv(1:14)//'.XMEM'
    xindcp = ds_contact%sdcont_solv(1:14)//'.XFIP'
    xmemcp = ds_contact%sdcont_solv(1:14)//'.XMEP'
    xseuco = ds_contact%sdcont_solv(1:14)//'.XFSE'
    xseucp = ds_contact%sdcont_solv(1:14)//'.XFSP'
    xcohes = ds_contact%sdcont_solv(1:14)//'.XCOH'
    xcohep = ds_contact%sdcont_solv(1:14)//'.XCOP'
    call copisd('CHAMP_GD', 'V', xindco, xindcp)
    call copisd('CHAMP_GD', 'V', xmemco, xmemcp)
    call copisd('CHAMP_GD', 'V', xseuco, xseucp)
    call copisd('CHAMP_GD', 'V', xcohes, xcohep)
!
end subroutine
