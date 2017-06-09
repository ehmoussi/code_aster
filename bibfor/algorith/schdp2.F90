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

function schdp2(seq, i1e, phi, alpha, c,&
                pult, pmoins)
!
    implicit      none
    real(kind=8) :: seq, i1e, phi, alpha, c, pult, pmoins, schdp2
! --- BUT : CALCUL DU CRITERE PLASTIQUE --------------------------------
! ======================================================================
    real(kind=8) :: un, deux, trois, six, gamarp, gamapm
! ======================================================================
! --- INITIALISATION DE PARAMETRES -------------------------------------
! ======================================================================
    parameter       ( un     =  1.0d0  )
    parameter       ( deux   =  2.0d0  )
    parameter       ( trois  =  3.0d0  )
    parameter       ( six    =  6.0d0  )
! ======================================================================
    gamarp = sqrt ( trois / deux ) * pult
    gamapm = sqrt ( trois / deux ) * pmoins
    if (pmoins .lt. pult) then
        schdp2 = seq + deux*sin(phi)*i1e/(trois-sin(phi)) - six*c*cos( phi)/(trois-sin(phi)) * (u&
                 &n-(un-alpha)*gamapm/gamarp) * (un-(un-alpha)*gamapm/gamarp)
    else
        schdp2 = seq + deux*sin(phi)*i1e/(trois-sin(phi)) - six*c*cos( phi)/(trois-sin(phi)) * al&
                 &pha * alpha
    endif
! ======================================================================
end function
