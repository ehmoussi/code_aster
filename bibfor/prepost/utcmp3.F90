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

subroutine utcmp3(nbcmp, nomcmp, numcmp)
    implicit none
#include "asterfort/lxliis.h"
#include "asterfort/utmess.h"
    integer :: nbcmp, numcmp(*)
    character(len=*) :: nomcmp(*)
! BUT :  VERIFIER QUE LES COMPOSANTES DE LA GRANDEUR VARI_R S'APPELLENT
!        BIEN V1, V2, .... ET RETOURNER LA LISTE DES NUMEROS CONCERNES
!
! ARGUMENTS :
!  IN NBCMP      : NOMBRE DE CMPS A VERIFIER
!  IN NOMCMP(*)  : LISTE DES NOMS DES CMPS    : (V1, V4, ...)
!  OUT NUMCMP(*) : LISTE DES NUMEROS DES CMPS : ( 1,  4, ...)
!
!
! ----------------------------------------------------------------------
    integer :: i, iret
    character(len=8) :: nom
    character(len=24) :: valk(2)
!     ------------------------------------------------------------------
!
    do 10 i = 1, nbcmp
        nom = nomcmp(i)
        numcmp(i) = 0
!
        call lxliis(nom(2:8), numcmp(i), iret)
!
        if (iret .ne. 0) then
            valk (1) = nom
            valk (2) = 'VARI_R'
            call utmess('F', 'CALCULEL6_49', nk=2, valk=valk)
        endif
10  end do
!
end subroutine
