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

function utmotp(fonree, motfac, iocc, motcle)
!
!     CETTE FONCTION TESTE LA PRESENCE D'UN MOTCLE
!     SOUS UN MOT-CLE FACTEUR
!     LE TEST SE FAIT EN FONCTION DE FONREE
!     SUR DES REELS, COMPLEXES OU FONCTIONS
!     UTILISE PAR EXEMPLE POUR AFFE_CHAR_MECA
!
    implicit none
    integer :: utmotp
#include "asterfort/getvc8.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/utmess.h"
    character(len=4) :: fonree
    character(len=*) :: motfac, motcle
!-----------------------------------------------------------------------
    integer :: iocc
!-----------------------------------------------------------------------
    if (fonree .eq. 'REEL') then
        call getvr8(motfac, motcle, iocc=iocc, nbval=0, nbret=utmotp)
    else if (fonree.eq.'FONC') then
        call getvid(motfac, motcle, iocc=iocc, nbval=0, nbret=utmotp)
    else if (fonree.eq.'COMP') then
        call getvc8(motfac, motcle, iocc=iocc, nbval=0, nbret=utmotp)
    else
        call utmess('F', 'UTILITAI5_52')
    endif
end function
