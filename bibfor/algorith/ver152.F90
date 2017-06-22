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

subroutine ver152(option, moflui, moint, n12, model)
    implicit none
!
!---------------------------------------------------------------------
! AUTEUR : G.ROUSSEAU
! VERIFICATIONS SUPPLEMENTAIRES DANS L OP0152 DE CALCUL DE MASSE
! AJOUTEE, AMORTISSEMENT ET RAIDEUR AJOUTES EN THEORIE POTENTIELLE
! IN : K* : OPTION : OPTION DE CALCUL
! IN : K* : MOFLUI , MOINT : MODELES FLUIDE ET INTERFACE
! IN : K* : MODEL : DIMENSION DU MODELE (3D, 2D OU AXI)
! IN : I  : N12 : PRESENCE DU POTENTIEL PERMANENT
!---------------------------------------------------------------------
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/utmess.h"
    integer :: n12
    character(len=*) :: option, model, moflui, moint
    character(len=9) :: optio9
    character(len=16) :: rep, rk16
! -----------------------------------------------------------------
    optio9 = option
!
!        MOFLU8 =
!
    if (n12 .eq. 0 .and. (optio9.eq.'AMOR_AJOU'.or. optio9.eq.('RIGI_AJOU'))) then
        call utmess('F', 'ALGORITH11_24')
    endif
!
    call dismoi('PHENOMENE', moflui, 'MODELE', repk=rk16)
!
    if (rk16(1:9) .ne. 'THERMIQUE') then
        call utmess('F', 'ALGORITH11_25')
    endif
!
    call dismoi('PHENOMENE', moint, 'MODELE', repk=rk16)
!
    if (rk16(1:9) .ne. 'THERMIQUE') then
        call utmess('F', 'ALGORITH11_26')
    endif
!
    call dismoi('MODELISATION', moflui, 'MODELE', repk=rep)
    if (rep .eq. 'PLAN') then
        model='2D'
    else
        if (rep .eq. 'AXIS') then
            model='AX'
        else
            if (rep .eq. '3D') then
                model='3D'
            else
                call utmess('F', 'ALGORITH11_27')
            endif
        endif
    endif
end subroutine
