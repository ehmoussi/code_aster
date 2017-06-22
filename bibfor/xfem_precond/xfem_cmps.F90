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

function xfem_cmps(nocmp, phys)
!
!-----------------------------------------------------------------------
! BUT : TESTER LES COMPOSANTES DES NOEUDS XFEM
!-----------------------------------------------------------------------
!
! ARGUMENTS :
!------------
!   - NOCMP : NOM DE LA COMPOSANTE A TESTER
!   - PHYS  = OUI   : ON TESTE LES DDLS XFEM ET LES DDLS PHYSIQUES
!             SINON : ON NE TESTE QUE LES DDLS XFEM
!
!-----------------------------------------------------------------------
    implicit none
#include "asterf_types.h"
!
    aster_logical :: xfem_cmps
    character(len=*) :: nocmp
    character(len=*), optional :: phys
!-----------------------------------------------------------------------
    xfem_cmps=.true.
! ON TESTE LES CPMS XFEM STANDARDS
    if (nocmp .eq. 'H1' .or. nocmp .eq. 'H1X' .or. nocmp .eq. 'H1Y' .or. nocmp .eq. 'H1Z') then
        goto 99
    elseif (nocmp .eq. 'E1' .or. nocmp .eq. 'E1X' .or. nocmp .eq. 'E1Y' .or. nocmp .eq. 'E1Z') then
        goto 99
    elseif (nocmp .eq. 'E2' .or. nocmp .eq. 'E2X' .or. nocmp .eq. 'E2Y' .or. nocmp .eq. 'E2Z') then
        goto 99
    elseif (nocmp .eq. 'E3' .or. nocmp .eq. 'E3X' .or. nocmp .eq. 'E3Y' .or. nocmp .eq. 'E3Z') then
        goto 99
    elseif (nocmp .eq. 'E4' .or. nocmp .eq. 'E4X' .or. nocmp .eq. 'E4Y' .or. nocmp .eq. 'E4Z') then
        goto 99
! ON RAJOUTE LES CPMS MULTI-HEAVISIDE PAR PRECAUTION
    elseif (nocmp .eq. 'H2' .or. nocmp .eq. 'H2X' .or. nocmp .eq. 'H2Y' .or. nocmp .eq. 'H2Z') then
        goto 99
    elseif (nocmp .eq. 'H3' .or. nocmp .eq. 'H3X' .or. nocmp .eq. 'H3Y' .or. nocmp .eq. 'H3Z') then
        goto 99
    elseif (nocmp .eq. 'H4' .or. nocmp .eq. 'H4X' .or. nocmp .eq. 'H4Y' .or. nocmp .eq. 'H4Z') then
        goto 99
    elseif (nocmp .eq. 'K1' .or. nocmp .eq. 'K2' .or. nocmp .eq. 'K3') then
        goto 99
! ON RAJOUTE LES CPMS DE CONT/FROT
    elseif (nocmp .eq. 'LAGS_C' .or. nocmp .eq. 'LAGS_F1' .or. nocmp .eq. 'LAGS_F2' .or.  &
            nocmp .eq. 'LAG2_C' .or. nocmp .eq. 'LAG2_F1' .or. nocmp .eq. 'LAG2_F2' .or. & 
            nocmp .eq. 'LAG3_C' .or. nocmp .eq. 'LAG3_F1' .or. nocmp .eq. 'LAG3_F2' .or. & 
            nocmp .eq. 'LAG4_C' .or. nocmp .eq. 'LAG4_F1' .or. nocmp .eq. 'LAG4_F2' .or. &
            nocmp .eq. 'PRE_FLU' .or. nocmp .eq. 'LAG_FLI' .or. nocmp .eq. 'LAG_FLS' .or. &
            nocmp .eq. 'PR2_FLU' .or. nocmp .eq. 'LA2_FLI' .or. nocmp .eq. 'LA2_FLS' .or. &
            nocmp .eq. 'PR3_FLU' .or. nocmp .eq. 'LA3_FLI' .or. nocmp .eq. 'LA3_FLS' .or. &
            nocmp .eq. 'D1X' .or. nocmp .eq. 'D1Y' .or. nocmp .eq. 'D1Z' .or. &
            nocmp .eq. 'D2X' .or. nocmp .eq. 'D2Y' .or. nocmp .eq. 'D2Z' .or. &
            nocmp .eq. 'D3X' .or. nocmp .eq. 'D3Y' .or. nocmp .eq. 'D3Z' .or. &
            nocmp .eq. 'V11' .or. nocmp .eq. 'V12' .or. nocmp .eq. 'V13' .or. &
            nocmp .eq. 'V21' .or. nocmp .eq. 'V22' .or. nocmp .eq. 'V23' .or. &
            nocmp .eq. 'V31' .or. nocmp .eq. 'V32' .or. nocmp .eq. 'V33') then
        goto 99
! ON RAJOUTE LES CPMS DE HM-XFEM
    elseif (nocmp .eq. 'H1PRE1' .or. nocmp .eq. 'H2PRE1' .or. nocmp .eq. 'H3PRE1') then
        goto 99
! ON TESTE LES DDLS DE PHYSIQUES 
    elseif( present(phys)) then 
       if (phys .eq. 'OUI' .and. &
        (nocmp .eq. 'TEMP'.or. nocmp .eq. 'DX' .or. nocmp .eq. 'DY' .or. nocmp .eq. 'DZ' .or. &
         nocmp .eq. 'PRE1'))&
        goto 99
    endif
    xfem_cmps=.false.
99  continue
end function
