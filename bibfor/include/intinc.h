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

! Parameters definitions
! -------------------------------------------------------------------------
!
    integer :: parind(_INT_NBPAR)
    character(len=3)  :: partyp(_INT_NBPAR)
    character(len=8)  :: params(_INT_NBPAR)

    data params /'ACCE    ', 'AMOR_DIA', 'AMOR_FUL', 'DEPL    ', 'FORCE_EX', &
                 'INDEX   ', 'IND_ARCH', 'MASS_DIA', 'MASS_FAC', 'MASS_FUL', &
                 'MAT_UPDT', 'PARAMS  ', 'RIGI_DIA', 'RIGI_FUL', 'STEP    ', &
                 'TIME    ', 'VITE    ', 'WORK1   ', 'WORK2   ', 'WORK3   ', &
                 'WORK4   ', 'WORK5   ', 'WORK6   ', 'WORK7   '/

    data partyp /'R  ', 'R  ', 'R  ', 'R  ', 'R  ', &
                 'I  ', 'I  ', 'R  ', 'R  ', 'R  ', &
                 'I  ', 'R  ', 'R  ', 'R  ', 'R  ', &
                 'R  ', 'R  ', 'R  ', 'R  ', 'R  ', &
                 'R  ', 'R  ', 'R  ', 'R  '/ 

! -------------------------------------------------------------------------
!   parind = -2 : vector global        ; = -1 : scalar global ;
!          =  2 : vector per occurence ; =  1 : scalar per occurence
! -------------------------------------------------------------------------

    data parind / 2,  2,  2,  2,  2, &
                  1, -1,  2,  2,  2, &
                 -1, -2,  2,  2,  1, &
                  1,  2, -2, -2, -2, &
                 -2, -2, -2, -2/
