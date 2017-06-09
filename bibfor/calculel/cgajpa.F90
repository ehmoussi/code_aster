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

subroutine cgajpa(para, notype, nbpara, linopa, litypa, nxpara)
!
    implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
    integer :: nbpara, nxpara
    character(len=*) :: para, notype, litypa(nxpara), linopa(nxpara)

!
! person_in_charge: emricka.julan at edf.fr
!
!     SOUS-ROUTINE DE L'OPERATEUR CALC_G
!
!     BUT : AJOUT D'UN COUPLE (PARAMETRE,TYPE)
!           A UNE LISTE linopa/litypa
!
! ----------------------------------------------------------------------
!     IN  : PARA   : NOM DE PARAMETRE CORRESPONDANT A linopa
!     IN  : typ : NOM DU TYPE CORRESPONDANT A litypa
!     I/O : NBPARA : NOMBRE DE PARAMETRE
!     I/O : linopa : TABLEAU DES NOM DE PARAMETRE
!     I/O : litypa : TABLEAU DES NOMS DE TYPE
!     IN  : nxpara : NOMBRE MAXIMUM DE PARAMETRE
!
! ----------------------------------------------------------------------
!
    integer :: i
!
! ----------------------------------------------------------------------
!     

    ASSERT(para .ne. ' ')
      
!   1. RECHERCHE SI LE PARAMETRE EXISTE DEJA :
!   ------------------------------------------

    if (nbpara.ne.0) then 
        do 10 i = 1, nbpara
            if (linopa(i) .eq. para) goto 9999
10      enddo
    endif

!    2. IL S'AGIT D'UN NOUVEAU PARAMETRE ON L'AJOUTE :
!    -------------------------------------------------
     nbpara = nbpara+1  
     ASSERT(nbpara .le. nxpara)
     linopa(nbpara) = para
     litypa(nbpara) = notype

9999 continue
!
end subroutine
