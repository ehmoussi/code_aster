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

subroutine irccmp(typ, gd, ncmpmx, nomcgd, nbcmp,&
                  nomcmp, nbcmpt, jcmp)
    implicit none
!
#include "jeveux.h"
#include "asterfort/utmess.h"
    character(len=*) :: gd, nomcgd(*), nomcmp(*), typ
    integer :: ncmpmx, nbcmp, nbcmpt, jcmp
! ----------------------------------------------------------------------
!     BUT :   TROUVER LE NOMBRE ET LES NOMS DES COMPOSANTES D'UNE LISTE
!             PRESENTENT DANS UNE GRANDEURS
!     ENTREES:
!        GD     : NOM DE LA GRANDEUR
!        NCMPMX : NOMBRE DE COMPOSANTES DE LA GRANDEUR  GD
!        NOMCGD : NOMS DES COMOPOSANTES DE LA GRANDEUR GD
!        NBCMP  : NOMBRE DE COMPOSANTES DE LA LISTE
!        NOMCMP : NOMS DES COMPOSANTES DE LA LISTE
!     SORTIES:
!        NBCMPT : NOMBRE DE COMPOSANTES DE LA LISTE PRESENTES DANS GD
!        JCMP   : ADRESSE OBJET JEVEUX CONTENANT NUMEROS DES COMPOSANTES
! ----------------------------------------------------------------------
    character(len=24) :: valk(2)
!     ------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: icm, icmpp
!-----------------------------------------------------------------------
    nbcmpt=0
!
    do 10 icm = 1, nbcmp
        do 11 icmpp = 1, ncmpmx
            if (nomcmp(icm) .eq. nomcgd(icmpp)) then
                nbcmpt=nbcmpt+1
                zi(jcmp-1+nbcmpt) = icmpp
                goto 10
            endif
11      continue
        if (typ(1:1) .ne. ' ') then
            valk (1) = nomcmp(icm)
            valk (2) = gd
            call utmess(typ, 'PREPOST5_25', nk=2, valk=valk)
        endif
10  end do
!
end subroutine
