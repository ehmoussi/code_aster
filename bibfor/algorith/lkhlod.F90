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

function lkhlod(gamcjs, rcos3t)
!
    implicit none
    real(kind=8) :: gamcjs, rcos3t, lkhlod
! --- MODELE LETK : LAIGLE VISCOPLASTIQUE--------------------------
! =================================================================
! --- BUT : CALCUL DE H(T) OU T DESIGNE L'ANGLE DE LODE
! --- LA DIFFERENCE PAR RAPPORT A LA FONCTION HLODE EST LE SIGNE --
! =================================================================
! IN  : GAMCJS : PARAMETRE DE FORME DE LA SURFACDE DE CHARGE ------
! ------------ : DANS LE PLAN DEVIATOIRE --------------------------
! --- : RCOS3T : COS(3T) ------------------------------------------
! OUT : LKHLOD  = (1-GAMMA_CJS*COS3T)**(1/6) ----------------------
! =================================================================
    real(kind=8) :: un, six
! =================================================================
! --- INITIALISATION DE PARAMETRES --------------------------------
! =================================================================
    parameter       ( un     =  1.0d0  )
    parameter       ( six    =  6.0d0  )
! =================================================================
    lkhlod = (un-gamcjs*rcos3t)**(un/six)
! =================================================================
end function
