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

subroutine rsdocu(docu, resu_type, iret)
!
implicit none
!
!
    character(len=4), intent(in)  :: docu
    character(len=*), intent(out)  :: resu_type
    integer, intent(out) :: iret
!
! --------------------------------------------------------------------------------------------------
!
! Results datastructure - Utility
!
! Get type of results datastructure from DOCU field
!
! --------------------------------------------------------------------------------------------------
!
! In  docu             : field DOCU
! Out resu_type        : type of results datastructure
! Out iret             : return code (0 if OK, 1 else)
!
! --------------------------------------------------------------------------------------------------
!
    iret = 0
    if (docu .eq. 'EVEL') then
        resu_type = 'EVOL_ELAS'
    else if (docu .eq. 'MUEL') then
        resu_type = 'MULT_ELAS'
    else if (docu .eq. 'FOEL') then
        resu_type = 'FOURIER_ELAS'
    else if (docu .eq. 'FOTH') then
        resu_type = 'FOURIER_THER'
    else if (docu .eq. 'COFO') then
        resu_type = 'COMB_FOURIER'
    else if (docu .eq. 'EVNO') then
        resu_type = 'EVOL_NOLI'
    else if (docu .eq. 'EVCH') then
        resu_type = 'EVOL_CHAR'
    else if (docu .eq. 'DYTR') then
        resu_type = 'DYNA_TRANS'
    else if (docu .eq. 'DYHA') then
        resu_type = 'DYNA_HARMO'
    else if (docu .eq. 'HAGE') then
        resu_type = 'HARM_GENE'
    else if (docu .eq. 'ACHA') then
        resu_type = 'ACOU_HARMO'
    else if (docu .eq. 'MOAC') then
        resu_type = 'MODE_ACOU'
    else if (docu .eq. 'MOFL') then
        resu_type = 'MODE_FLAMB'
    else if (docu .eq. 'MOSB') then
        resu_type = 'MODE_STAB'
    else if (docu .eq. 'MOME') then
        resu_type = 'MODE_MECA'
    else if (docu .eq. 'MOGE') then
        resu_type = 'MODE_GENE'
    else if (docu .eq. 'MOEM') then
        resu_type = 'MODE_EMPI'
    else if (docu .eq. 'EVTH') then
        resu_type = 'EVOL_THER'
    else if (docu .eq. 'EVVA') then
        resu_type = 'EVOL_VARC'
    else
        iret = 1
    endif
!
end subroutine
