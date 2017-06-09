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

subroutine dbgobj(ojbz, perm, iunit, mess)
    implicit none
! person_in_charge: jacques.pellet at edf.fr
! ----------------------------------------------------------------------
!     BUT : IMPRIMER SUR LE FICHIER "IUNIT"
!           QUELQUES VALEURS QUI "RESUMENT" UN OBJET JEVEUX (OJB)
!           (SIMPLE OU COLLECTION)
!     ARGUMENTS :
!       IN  OJB    (K24) : NOM DE L'OBJET A IMPRIMER
!       IN  IUNIT  (I)   : NUMERO DE L'UNITE LOGIQUE D'IMPRESSION
!       IN  MESS   (K*)  : "MESSAGE" PREFIXANT LA LIGNE IMPRIMEE
!       IN  PERM    K3 : /OUI/NON
!           NON : ON FAIT LA SOMME BETE DES ELEMENTS DU VECTEUR
!                 => UNE PERMUTATION DU VECTEUR NE SE VOIT PAS !
!           OUI : ON FAIT UNE "SOMME" QUI DONNE UN RESULTAT
!                 DEPENDANT UN PEU DE L'ORDRE DES ELEMENTS DU VECTEUR
! ----------------------------------------------------------------------
#include "asterfort/assert.h"
#include "asterfort/jeexin.h"
#include "asterfort/tstobj.h"
    integer :: iunit, ni
    character(len=24) :: ojb
    character(len=3) :: type
    character(len=*) :: mess, ojbz, perm
    integer :: sommi, resume, lonmax, lonuti, iret
    real(kind=8) :: sommr
!
! DEB-------------------------------------------------------------------
    ojb=ojbz
    call jeexin(ojb, iret)
    if (iret .eq. 0) goto 9999
!
    call tstobj(ojb, perm, resume, sommi, sommr,&
                lonuti, lonmax, type, iret, ni)
    if (type(1:1) .eq. 'K') then
        write (iunit,1002) mess,ojb,lonmax,lonuti,type,iret,sommi
    else if (type(1:1).eq.'I') then
        write (iunit,1002) mess,ojb,lonmax,lonuti,type,iret,sommi
    else if (type(1:1).eq.'L') then
        write (iunit,1002) mess,ojb,lonmax,lonuti,type,iret,sommi
    else if (type(1:1).eq.'R') then
        write (iunit,1003) mess,ojb,lonmax,lonuti,type,iret,ni,sommr
    else if (type(1:1).eq.'C') then
        write (iunit,1003) mess,ojb,lonmax,lonuti,type,iret,ni,sommr
    else if (type(1:1).eq.'?') then
        if (iret .ne. 0) then
            write (iunit,1004) mess,ojb,type,iret
        else
            ASSERT(.false.)
        endif
    else
        ASSERT(.false.)
    endif
!
9999  continue
!
    1002 format (a,' | ',a24,' | LONMAX=',i12,' | LONUTI=',i12,&
     &        ' | TYPE=',a4,' | IRET=',i7, ' | SOMMI=',i24 )
!
    1003 format (a,' | ',a24,' | LONMAX=',i12,' | LONUTI=',i12,&
     &        ' | TYPE=',a4,' | IRET=',i7,' | IGNORE=',i7,&
     &        ' | SOMMR=',e20.11)
!
    1004 format (a,' | ',a24, ' | TYPE=',a4,' | IRET=',i7)
!
end subroutine
